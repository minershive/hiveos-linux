#!/usr/bin/env bash

DEFAULT_CORE_STATE=5

SLEEP=1

load=
# get gpu load and switch to fast mode if not used by miner
if [[ -e /sys/class/drm/card$cardno/device/gpu_busy_percent ]]; then
	load=`head -1 /sys/class/drm/card$cardno/device/gpu_busy_percent 2>/dev/null`
elif [[ -e /sys/kernel/debug/dri/$cardno/amdgpu_pm_info ]]; then
	load=`grep -m1 'GPU Load' /sys/kernel/debug/dri/$cardno/amdgpu_pm_info 2>/dev/null | awk '{printf("%d", $3)}'`
fi
[[ $load == 0 ]] && SLEEP="0.1"


function polaris_oc() {

	local MIN_CLOCK=400
	local MIN_VOLT=100

	local PPT=/tmp/pp_table$cardno
	local CARDPATH=/sys/class/drm/card$cardno/device
	local CARDPPT=$CARDPATH/pp_table

	local args=""
	local coreState=
	local memoryState=
	local idx

	[[ $(stat -c %s $savedpp) -lt 100 ]] && return 1

	readarray -t data < <( /hive/opt/upp2/upp.py -p $savedpp get \
		sHeader/TableFormatRevision \
		MclkDependencyTable/NumEntries \
		SclkDependencyTable/NumEntries \
		MaxODEngineClock \
		MaxODMemoryClock \
		PowerTuneTable/TDP \
		PowerTuneTable/TDC \
		PowerTuneTable/MaximumPowerDeliveryLimit \
		2>/dev/null)

	# check pp_table version 7.1
	[[ "${data[0]}" != 7 ]] && return 2

	maxMemoryState=$(( data[1] - 1 ))
	maxCoreState=$(( data[2] - 1 ))
	maxCoreClock=$(( data[3]/100 ))
	maxMemoryClock=$(( data[4]/100 ))
	TDP=${data[5]}
	TDC=${data[6]}
	maxPower=${data[7]}

	echo "Max core: ${maxCoreClock}MHz, Max mem: ${maxMemoryClock}MHz, Max mem state: $maxMemoryState, Max core state: $maxCoreState"
	echo "TDP: ${TDP}W, TDC: ${TDC}A, Max power: ${maxPower}W"

	[[ $AGGRESSIVE == 1 && ( ${CORE_VDDC[$i]} -le $MIN_VOLT || ${CORE_CLOCK[$i]} -le $MIN_CLOCK ) ]] &&
		echo "${RED}ERROR: Core clock and voltage must be set in aggressive mode $NOCOLOR"

	if [[ ! -z $CORE_STATE ]]; then
		if [[ ${CORE_STATE[$i]} -ge 0 && ${CORE_STATE[$i]} -le $maxCoreState ]]; then
			[[ ${CORE_STATE[$i]} != 0 ]] && # skip zero state, means auto
				coreState=${CORE_STATE[$i]}
		else
			echo "${RED}ERROR: Invalid core state ${CORE_STATE[$i]} specified $NOCOLOR"
		fi
	fi

	# core state is not specified, let's use some default or it will not work in some cases
	[[ -z $coreState && $AGGRESSIVE != 1 ]] &&
		if [[ ${CORE_VDDC[$i]} -gt $MIN_VOLT || ${CORE_CLOCK[$i]} -gt $MIN_CLOCK ]]; then
			coreState=$DEFAULT_CORE_STATE
			echo "${YELLOW}Empty core state, falling back to $coreState $NOCOLOR"
		fi

	if [[ ! -z $MEM_STATE ]]; then
		if [[ ${MEM_STATE[$i]} -ge 0 && ${MEM_STATE[$i]} -le $maxMemoryState ]]; then
			[[ ${MEM_STATE[$i]} != 0 ]] && # skip zero state, means auto
				memoryState="${MEM_STATE[$i]}"
		else
			if [[ -z ${VDDCI[$i]} && ${MEM_STATE[$i]} -gt $MIN_VOLT ]]; then
				# using as vddci voltage for back compatibility
				VDDCI[$i]="${MEM_STATE[$i]}"
				memoryState="$maxMemoryState"
			else
				echo "${RED}ERROR: Invalid memory state ${MEM_STATE[$i]} specified $NOCOLOR"
			fi
		fi
	fi

	# set memory state if needed
	[[ -z $memoryState && ${MEM_CLOCK[$i]} -gt $MIN_CLOCK ]] &&
		echo "${YELLOW}Empty memory state, setting to max state $maxMemoryState $NOCOLOR" &&
		memoryState="$maxMemoryState"

	# in aggressive mode if memory voltage not specified using core voltage for back compatibility
	[[ $AGGRESSIVE == 1 && ${MVDD[$i]} -le $MIN_VOLT && ${CORE_VDDC[$i]} -gt $MIN_VOLT ]] &&
		echo "${YELLOW}Empty memory voltage, using core voltage ${CORE_VDDC[$i]} $NOCOLOR" &&
		MVDD[$i]="${CORE_VDDC[$i]}"

	[[ ${MVDD[$i]} -gt $MIN_VOLT && ${MVDD[$i]} -gt ${CORE_VDDC[$i]} ]] &&
		echo "${RED}ERROR: Memory voltage can't be more than core voltage $NOCOLOR"

	# set target temp for HW autofan
	[[ $AMD_TARGET_TEMP -gt 0 ]] &&
		args+=" FanTable/TargetTemperature=$AMD_TARGET_TEMP"

	# set power limit
	[[ ${PL[$i]} -gt 0 ]] &&
		args+=" PowerTuneTable/TDP=${PL[i]}"

	# set bios max mem clock if needed
	[[ ${MEM_CLOCK[$i]} -gt $maxMemoryClock && $maxMemoryClock -gt $MIN_CLOCK ]] &&
		args+=" MaxODMemoryClock=$(( MEM_CLOCK[i]*100 ))"

	# set memory voltage and clock
	[[ ${MVDD[$i]} -gt $MIN_VOLT ]] && args+=" VddcLookupTable/8/Vdd=${MVDD[$i]}"
	for((idx=1; idx <= maxMemoryState; idx++)); do
		[[ ${VDDCI[$i]} -gt $MIN_VOLT ]] && args+=" MclkDependencyTable/${idx}/Vddci=${VDDCI[$i]}"
		[[ ${MVDD[$i]} -gt $MIN_VOLT ]] && args+=" MclkDependencyTable/${idx}/VddcInd=8"

		if [[ ${MEM_CLOCK[$i]} -gt $MIN_CLOCK ]]; then
			# always set lower clocks for previous mem states and the same to next
			[[ $idx -ge $memoryState ]] &&
				args+=" MclkDependencyTable/${idx}/Mclk=$(( MEM_CLOCK[i]*100 ))" ||
				args+=" MclkDependencyTable/${idx}/Mclk=$(( ( MEM_CLOCK[i] - 100 )*100 ))"
		fi
	done

	# set bios max core clock if needed
	[[ ${CORE_CLOCK[$i]} -gt $maxCoreClock && $maxCoreClock -gt $MIN_CLOCK ]] &&
		args+=" MaxODEngineClock=$(( CORE_CLOCK[i]*100 ))"

	# set core voltage and clock
	for((idx=1; idx <= maxCoreState; idx++)); do
		if [[ -z $coreState || $coreState -eq $idx || $AGGRESSIVE == 1 ]]; then
			[[ ${CORE_CLOCK[$i]} -gt $MIN_CLOCK ]] && args+=" SclkDependencyTable/${idx}/Sclk=$(( CORE_CLOCK[i]*100 ))"
			[[ ${CORE_VDDC[$i]} -gt $MIN_VOLT ]] && args+=" VddcLookupTable/${idx}/Vdd=${CORE_VDDC[$i]} SclkDependencyTable/${idx}/VddInd=${idx}"
		fi
	done


	# set auto performance level to reset manual DPM if no state will be set
	[[ -z $coreState && -z $memoryState ]] &&
		echo "Setting DPM to auto mode" &&
		echo "auto" > $CARDPATH/power_dpm_force_performance_level


	# using saved Power Play table
	cp $savedpp $PPT

	# apply all changes to PPT and check if they differ from already applied
	local output=""
	[[ ! -z "$args" ]] && output=`/hive/opt/upp2/upp.py -p $PPT set $args --write 2>&1 >/dev/null`

	# do not apply the same table again
	if cmp $PPT $CARDPPT >/dev/null; then
		echo "${GREEN}All changes were already applied to Power Play table $NOCOLOR"
	# compare to original one
	elif cmp $PPT $savedpp >/dev/null; then
		echo "${CYAN}Restoring original Power Play table $NOCOLOR"
		cp $PPT $CARDPPT && sleep $SLEEP
	# apply PPT to GPU
	else
		[[ ! -z "$output" ]] && echo "$output"
		echo "${CYAN}Applying all changes to Power Play table $NOCOLOR"
		cp $PPT $CARDPPT && sleep $SLEEP
	fi


	if [[ ! -z $coreState || ! -z $memoryState ]]; then
		echo "manual" > $CARDPATH/power_dpm_force_performance_level

		[[ ! -z $coreState ]] &&
			echo "Setting DPM core state to $coreState" &&
			echo $coreState > $CARDPATH/pp_dpm_sclk

		# setting memory state kills idle mode, so set it only if needed
		# if state is set without clock or in aggressive with DPM 1 and core clock set
		[[ ! -z $memoryState ]] &&
			[[ $AGGRESSIVE != 1 || $coreState -le 1 || ${CORE_CLOCK[$i]} -le $MIN_CLOCK ||
				( $memoryState != $maxMemstate && ${MEM_CLOCK[$i]} -le $MIN_CLOCK ) ]] &&
					echo "Setting DPM memory state to $memoryState" &&
					echo $memoryState > $CARDPATH/pp_dpm_mclk
	fi

	return 0
}


function legacy_oc() {

	local MIN_CLOCK=400
	local MIN_VOLT=100

	local CARDPATH=/sys/class/drm/card$cardno/device

	local coreState=
	local memoryState=
	local states

	echo "${BYELLOW}Legacy mode: voltage and clocks can be changed only via bios $NOCOLOR"

	[[ -e ${CARDPATH}/pp_dpm_sclk ]] && states=`cat ${CARDPATH}/pp_dpm_sclk | wc -l` || states=8
	maxCoreState=$(( states - 1 ))

	[[ -e ${CARDPATH}/pp_dpm_mclk ]] && states=`cat ${CARDPATH}/pp_dpm_mclk | wc -l` || states=2
	maxMemoryState=$(( states - 1 ))

	echo "Max memory state: $maxMemoryState, Max core state: $maxCoreState"

	if [[ ! -z $CORE_STATE ]]; then
		if [[ ${CORE_STATE[$i]} -ge 0 && ${CORE_STATE[$i]} -le $maxCoreState ]]; then
			[[ ${CORE_STATE[$i]} != 0 ]] && # skip zero state, means auto
				coreState=${CORE_STATE[$i]}
		else
			echo "${RED}ERROR: Invalid core state ${CORE_STATE[$i]} specified $NOCOLOR"
		fi
	fi

	if [[ ! -z $MEM_STATE ]]; then
		if [[ ${MEM_STATE[$i]} -ge 0 && ${MEM_STATE[$i]} -le $maxMemoryState ]]; then
			[[ ${MEM_STATE[$i]} != 0 ]] && # skip zero state, means auto
				memoryState="${MEM_STATE[$i]}"
		else
			echo "${RED}ERROR: Invalid memory state ${MEM_STATE[$i]} specified $NOCOLOR"
		fi
	fi

	# set core state for compatibility
	if [[ -z $coreState ]]; then
		# using max state in agressive
		if [[ $AGGRESSIVE == 1 ]]; then
			coreState=$maxCoreState
			echo "${YELLOW}Empty core state, setting to max state $coreState $NOCOLOR"
		elif [[ ${CORE_VDDC[$i]} -gt $MIN_VOLT || ${CORE_CLOCK[$i]} -gt $MIN_CLOCK ]]; then
			coreState=$DEFAULT_CORE_STATE
			echo "${YELLOW}Empty core state, falling back to $coreState $NOCOLOR"
		fi
	fi

	# set memory state if mem clock is set for compatibility
	[[ -z $memoryState && ${MEM_CLOCK[$i]} -gt $MIN_CLOCK ]] &&
		echo "${YELLOW}Empty memory state, setting to max state $maxMemoryState $NOCOLOR" &&
		memoryState=$maxMemoryState


	# set auto performance level to reset manual DPM if no state will be set
	if [[ -z $coreState && -z $memoryState ]]; then
		echo "Setting DPM to auto mode"
		echo "auto" > $CARDPATH/power_dpm_force_performance_level
	else
		echo "manual" > $CARDPATH/power_dpm_force_performance_level

		[[ ! -z $coreState ]] &&
			echo "Setting DPM core state to $coreState" &&
			echo $coreState > $CARDPATH/pp_dpm_sclk

		# setting memory state kills idle mode, so set it only if needed
		# if state is set without clock or in aggressive with DPM 1 and core clock set
		[[ ! -z $memoryState ]] &&
			[[ $AGGRESSIVE != 1 || $coreState -le 1 || ${CORE_CLOCK[$i]} -le $MIN_CLOCK ||
				( $memoryState != $maxMemstate && ${MEM_CLOCK[$i]} -le $MIN_CLOCK ) ]] &&
					echo "Setting DPM memory state to $memoryState" &&
					echo $memoryState > $CARDPATH/pp_dpm_mclk
	fi

	return 0
}


function set_fan() {
	# set fan speed
	local hwmondir=`realpath /sys/class/drm/card$cardno/device/hwmon/hwmon*/`
	if [[ ! -z ${hwmondir} ]]; then
		if [[ ${FAN[$i]} -gt 0 && -e ${hwmondir}/pwm1 ]]; then
			[[ -e ${hwmondir}/pwm1_enable ]] && echo 1 > ${hwmondir}/pwm1_enable
			[[ -e ${hwmondir}/pwm1_max ]] && fanmax=`head -1 ${hwmondir}/pwm1_max` || fanmax=255
			[[ -e ${hwmondir}/pwm1_min ]] && fanmin=`head -1 ${hwmondir}/pwm1_min` || fanmin=0
			echo $(( FAN[i]*(fanmax - fanmin)/100 + fanmin )) > ${hwmondir}/pwm1
		else
			# set to auto mode
			[[ -e ${hwmondir}/pwm1_enable ]] && echo 2 > ${hwmondir}/pwm1_enable
		fi
	else
		echo "Error: unable to get HWMON dir to set fan"
	fi
}


polaris_oc || legacy_oc

set_fan

# finally set REF
[[ ${REF[$i]} -gt 0 ]] && amdmemtweak --gpu "$card_idx" --REF "${REF[$i]}"
