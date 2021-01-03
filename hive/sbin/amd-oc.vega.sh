#!/usr/bin/env bash

DEFAULT_CORE_STATE=7

SLEEP=1

load=
# get gpu load and switch to fast mode if not used by miner
if [[ -e /sys/class/drm/card$cardno/device/gpu_busy_percent ]]; then
	load=`head -1 /sys/class/drm/card$cardno/device/gpu_busy_percent 2>/dev/null`
elif [[ -e /sys/kernel/debug/dri/$cardno/amdgpu_pm_info ]]; then
	load=`grep -m1 'GPU Load' /sys/kernel/debug/dri/$cardno/amdgpu_pm_info 2>/dev/null | awk '{printf("%d", $3)}'`
fi
[[ $load == 0 ]] && SLEEP="0.1"


function vega10_oc() {

	local MIN_CLOCK=700
	local MIN_VOLT=750

	local PPT=/tmp/pp_table$cardno
	local CARDPPT=/sys/class/drm/card$cardno/device/pp_table

	# using saved Power Play table
	cp $savedpp $PPT

	local args=""
	local coreState=
	local memoryState=
	local idx

	readarray -t data < <( python3 /hive/opt/upp2/upp.py -p $PPT get \
		MclkDependencyTable/NumEntries \
		GfxclkDependencyTable/NumEntries \
		SocclkDependencyTable/NumEntries \
		MaxODEngineClock \
		MaxODMemoryClock \
	)

	maxMemoryState=$(( data[0] - 1 ))
	maxCoreState=$(( data[1] - 1 ))
	maxSocState=$(( data[2] - 1 ))
	maxCoreClock=$(( data[3]/100 ))
	maxMemoryClock=$(( data[4]/100 ))

	echo "Max core: ${maxCoreClock}MHz, Max mem: ${maxMemoryClock}MHz, Max mem state: $maxMemoryState, Max core state: $maxCoreState, Max SoC state: $maxSocState"


	# set target temp for HW autofan
	[[ $AMD_TARGET_TEMP -gt 0 ]] &&
		args+=" FanTable/TargetTemperature=$AMD_TARGET_TEMP"

	# set bios max mem clock if needed
	[[ ${MEM_CLOCK[$i]} -gt $maxMemoryClock && $maxMemoryClock -gt $MIN_CLOCK ]] &&
		args+=" MaxODMemoryClock=$(( MEM_CLOCK[i]*100 ))"

	# set memory voltage and clock
	if [[ ! -z ${MVDD[$i]} &&  ${MVDD[$i]} -gt $MIN_VOLT ]];then
		args+=" VddmemLookupTable/0/Vdd=${MVDD[$i]}"
		#in aggr set HBM voltage with atitool too
		mvdd=$(echo "scale=2; ${MVDD[$i]}/1000" | bc )
		[[ $AGGRESSIVE == 1 ]] && atitool -v=silent -debug=0 -i=$card_idx -vddcr_hbm=$mvdd >/dev/null && 
		echo "Setting HBM voltage to ${mvdd}V"
	fi
	if [[ ! -z ${MEM_CLOCK[$i]} ]];then
	clk=${MEM_CLOCK[$i]}
	for idx in `eval echo  {$maxMemoryState..1}`; do
#		[[ ${VDDCI[$i]} -gt $MIN_VOLT ]] && args+=" MclkDependencyTable/${idx}/Vddci=0"
		[[ ${MVDD[$i]} -gt $MIN_VOLT ]] && args+=" MclkDependencyTable/${idx}/VddInd=1"

		if [[ ${MEM_CLOCK[$i]} -gt $MIN_CLOCK ]]; then
				args+=" MclkDependencyTable/${idx}/MemClk=$(( clk*100 ))"
		fi
		clk=$(($clk-100))
	done
	fi
	# set bios max core clock if needed
	[[ ${CORE_CLOCK[$i]} -gt $maxCoreClock && $maxCoreClock -gt $MIN_CLOCK ]] &&
		args+=" MaxODEngineClock=$(( CORE_CLOCK[i]*100 )) "
	
	# set core voltage and clock
	if [[ ! -z $CORE_VDDC && ${CORE_VDDC[$i]} -gt $MIN_VOLT  ]]; then
		for coreState in {0..7}; do
			args+=" VddcLookupTable/$coreState/Vdd=${CORE_VDDC[$i]} "
		done
	fi
	if [[ ! -z $CORE_CLOCK && ${CORE_CLOCK[$i]} -gt $MIN_CLOCK ]]; then
		clk=${CORE_CLOCK[$i]}
		for idx in `eval echo  {$maxCoreState..0}`; do
			args+="GfxclkDependencyTable/$idx/Clk=${clk}00 "
			clk=$(($clk-20))
		done
		#in aggressive mode use soc OC
		if [[  ! -z $SOCCLK && ${SOCCLK[$i]} -gt 800 ]];then
		clk=$((${SOCCLK[$i]}+20))
			for idx in `eval echo  {$maxSocState..0}`; do
				args+="SocclkDependencyTable/$idx/Clk=${clk}00 "
				clk=$(($clk-10))
		 	done
		fi
	fi


	# apply all changes to PPT and check if they differ from already applied
	local output=""
	[[ ! -z "$args" ]] && output=`python3 /hive/opt/upp2/upp.py -p $PPT set $args --write >/dev/null`
	# do not apply the same table again
#	if cmp $PPT $CARDPPT ; then
#		echo "${GREEN}All changes were already applied to Power Play table $NOCOLOR"
	# compare to original one
#	elif cmp $PPT $savedpp >/dev/null; then
#		echo "${CYAN}Restoring original Power Play table $NOCOLOR"
#		cp $PPT $CARDPPT && sleep $SLEEP
	# apply PPT to GPU
#	else
#		echo "$output"
		echo "${CYAN}Applying all changes to Power Play table $NOCOLOR"
		cp $PPT $CARDPPT && sleep $SLEEP
		cat /sys/class/drm/card$cardno/device/pp_od_clk_voltage
	#in aggr set Core/Soc voltage with atitool too
	[[ $AGGRESSIVE == 1 &&  ${CORE_VDDC[$i]} -gt $MIN_VOLT  ]] && vdd=$(echo "scale=2; ${CORE_VDDC[$i]}/1000" | bc -l) &&
			 		atitool -v=silent -i=$card_idx -vddcr_soc=$vdd >/dev/null && 
			 		echo "Setting Core/SoC voltage to ${vdd}V"
#	fi

	#memtweak if exist
	[[ ! -z $TWEAKS && `echo $TWEAKS | jq --arg gpu "$card_idx" -r -c '. | .amdmemtweak[$gpu|tonumber] | .cmdline'` != "null" ]] &&
		amdmemtweak --gpu $card_idx `echo $TWEAKS | jq --arg gpu "$card_idx" -r -c '. | .amdmemtweak[$gpu|tonumber] | .cmdline'` || echo "No tweaks found for GPU$card_idx"

	echo "manual" > /sys/class/drm/card$cardno/device/power_dpm_force_performance_level

	echo "Setting DPM core state to $maxCoreState" &&
	echo $maxCoreState > /sys/class/drm/card$cardno/device/pp_dpm_sclk

	echo "Setting DPM memory state to $maxMemoryState" &&
	echo $maxMemoryState > /sys/class/drm/card$cardno/device/pp_dpm_mclk


	# set fan speed
	local hwmondir=`realpath /sys/class/drm/card$cardno/device/hwmon/hwmon*/`
	if [[ ! -z ${hwmondir} ]]; then
		[[ -e ${hwmondir}/pwm1_enable ]] && echo 1 > ${hwmondir}/pwm1_enable
		if [[ ${FAN[$i]} -gt 0 && -e ${hwmondir}/pwm1 ]]; then
			[[ -e ${hwmondir}/pwm1_max ]] && fanmax=`head -1 ${hwmondir}/pwm1_max` || fanmax=255
			[[ -e ${hwmondir}/pwm1_min ]] && fanmin=`head -1 ${hwmondir}/pwm1_min` || fanmin=0
			echo $(( FAN[i]*(fanmax - fanmin)/100 + fanmin )) > ${hwmondir}/pwm1
		fi
	else
		echo "Error: unable to get HWMON dir to set fan"
	fi
}

# Main code
vega10_oc
