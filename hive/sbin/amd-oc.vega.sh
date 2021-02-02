#!/usr/bin/env bash

DEFAULT_CORE_STATE=4

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
	local HARD_LIM=800
	local MIN_SOCCLK=650
	local MAX_SOCCLK=1200

	local PPT=/tmp/pp_table$cardno                            # PPT prepared
	local CARDPPT=/sys/class/drm/card$cardno/device/pp_table  # PPT active

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
	safeCoreState=4
	SocState=$maxSocState

	echo "Max core: ${maxCoreClock}MHz, Max mem: ${maxMemoryClock}MHz, Max mem state: $maxMemoryState, Max core state: $maxCoreState, Max SoC state: $maxSocState"


	# set target temp for HW autofan
	[[ $AMD_TARGET_TEMP -gt 0 ]] &&
		args+=" FanTable/TargetTemperature=$AMD_TARGET_TEMP"

	# set bios max mem clock if needed
	[[ ${MEM_CLOCK[$i]} -gt $maxMemoryClock && $maxMemoryClock -gt $MIN_CLOCK ]] &&
		args+=" MaxODMemoryClock=$(( MEM_CLOCK[i]*100 ))"

	# set memory voltage contoller interface voltage
	if [[ ! -z ${VDDCI[$i]} &&  ${VDDCI[$i]} -gt $MIN_VOLT ]];then
		args+=" VddciLookupTable/0/Vdd=${VDDCI[$i]}"
	fi
	# set memory voltage and clock
	if [[ ! -z ${MVDD[$i]} &&  ${MVDD[$i]} -gt $MIN_VOLT ]];then
		args+=" VddmemLookupTable/0/Vdd=${MVDD[$i]}"
		#in aggr set HBM voltage with atitool too
		mvdd=$(echo "scale=3; ${MVDD[$i]}/1000" | bc )
		#[[ $AGGRESSIVE == 1 ]] && atitool -v=silent -debug=0 -i=$card_idx -vddcr_hbm=$mvdd >/dev/null && echo "Setting HBM voltage to ${mvdd}V"
		atitool -v=silent -debug=0 -i=$card_idx -vddcr_hbm=$mvdd >/dev/null && echo "Setting HBM voltage to ${mvdd}V"
	fi
	if [[ ! -z ${MEM_CLOCK[$i]} ]]; then
		clk=${MEM_CLOCK[$i]}
		for idx in `eval echo {$maxMemoryState..1}`; do
#			[[ ${VDDCI[$i]} -gt $MIN_VOLT ]] && args+=" MclkDependencyTable/${idx}/Vddci=0"
			[[ ${MVDD[$i]} -gt $MIN_VOLT ]] && args+=" MclkDependencyTable/${idx}/VddInd=1"
			if [[ ${MEM_CLOCK[$i]} -gt $MIN_CLOCK ]]; then
				args+=" MclkDependencyTable/${idx}/MemClk=$(( clk*100 ))"
			fi
			clk=$(($clk-100))
		done
		# If SoC Clock isn't set than starting lookup procedure to find best matching SoC clock to memory clock
		if [[ -z ${SOCCLK[i]} || ${SOCCLK[$i]} -eq 0 ]]; then
			for idx in `eval echo {1..$maxSocState}`; do
				SocClk=`python3 /hive/opt/upp2/upp.py -p $PPT get SocclkDependencyTable/$idx/Clk 2> /dev/null`
				SocState=$idx
				if [[ ${MEM_CLOCK[$i]} -ge $((SocClk/100)) ]]; then
					args+=" SocclkDependencyTable/$idx/Clk=$SocClk "
					continue
				else
					break
				fi
			done
			args+=" SocclkDependencyTable/$SocState/Clk=$SocClk "
		fi # end SocClock
	fi
	# set bios max core clock if needed
	[[ ${CORE_CLOCK[$i]} -gt $maxCoreClock && $maxCoreClock -gt $MIN_CLOCK ]] &&
		args+=" MaxODEngineClock=$(( CORE_CLOCK[i]*100 )) "
	
	# set core voltage and clock
	if [[ ! -z $CORE_VDDC && ${CORE_VDDC[$i]} -gt $MIN_VOLT  ]]; then
		[[ ${CORE_VDDC[$i]} -gt $HARD_LIM ]] && minCoreState=1 || minCoreState=0
		for coreState in `eval echo {$minCoreState..$maxCoreState}`; do
			args+=" VddcLookupTable/$coreState/Vdd=${CORE_VDDC[$i]} "
		done
	fi
	if [[ $maxCoreState -ge $safeCoreState ]]; then
		CoreState=$safeCoreState
	else
		CoreState=$maxCoreState
	fi
	if [[ ! -z $CORE_CLOCK && ${CORE_CLOCK[$i]} -gt $MIN_CLOCK ]]; then
		clk=${CORE_CLOCK[$i]}
		for idx in `eval echo {1..$CoreState}`; do
			CoreClk=`python3 /hive/opt/upp2/upp.py -p $PPT get GfxclkDependencyTable/$idx/Clk 2> /dev/null`
			CoreState=$idx
			if [[ $clk -gt $((CoreClk/100)) ]]; then
				args+=" GfxclkDependencyTable/$idx/Clk=$CoreClk "
				continue
			else
				break
			fi
		done
		args+=" GfxclkDependencyTable/$CoreState/Clk=${clk}00 "
		if [[ ${SOCCLK[$i]} -gt $MIN_SOCCLK && ${SOCCLK[$i]} -lt $MAX_SOCCLK ]]; then
			clk=$((${SOCCLK[$i]}))
			SocState=3 #$maxSocState # TBD
			#clk=${SOCCLK[$i]}
			for idx in `eval echo {$maxSocState..1}`; do
				args+=" SocclkDependencyTable/$idx/Clk=${clk}00 "
				[[ $SocState -ge $idx ]] && clk=$(($clk-10))
			done
		fi
	fi


	# apply all changes to PPT and check if they differ from already applied
	# echo $args
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
	#	cat /sys/class/drm/card$cardno/device/pp_od_clk_voltage
	#in aggr set Core/Soc voltage with atitool too
	[[ ${CORE_VDDC[$i]} -gt $MIN_VOLT && ${CORE_VDDC[$i]} -lt $HARD_LIM ]] && vdd=$(echo "scale=2; ${CORE_VDDC[$i]}/1000" | bc -l) &&
			 		atitool -v=silent -i=$card_idx -vddcr_soc=$vdd >/dev/null && 
			 		echo -e "Setting Core/SoC voltage to ${PURPLE}$(echo ${vdd} | awk '{printf "%.0f\n", 1000*$1}')${NOCOLOR} mV"
#	fi

	#memtweak if exist
	[[ ! -z $TWEAKS && `echo $TWEAKS | jq --arg gpu "$card_idx" -r -c '. | .amdmemtweak[$gpu|tonumber] | .cmdline'` != "null" ]] &&
		amdmemtweak --gpu $card_idx `echo $TWEAKS | jq --arg gpu "$card_idx" -r -c '. | .amdmemtweak[$gpu|tonumber] | .cmdline'` || echo "No tweaks found for GPU$card_idx"

	echo "manual" > /sys/class/drm/card$cardno/device/power_dpm_force_performance_level

	echo -n -e "Setting DPM Core state to ${PURPLE}$CoreState ${NOCOLOR}" &&
	echo $CoreState > /sys/class/drm/card$cardno/device/pp_dpm_sclk  && echo "on ${GREEN}"`cat /sys/class/drm/card$cardno/device/pp_dpm_sclk | grep "*" | awk '{ print $2 }'`${NOCOLOR}
	
	echo -n -e "Setting DPM SoC  state to ${PURPLE}$SocState ${NOCOLOR}" &&
	echo $SocState > /sys/class/drm/card$cardno/device/pp_dpm_socclk && echo "on ${GREEN}"`cat /sys/class/drm/card$cardno/device/pp_dpm_socclk | grep "*" | awk '{ print $2 }'`${NOCOLOR}
	
	echo -n -e "Setting DPM MEM  state to ${PURPLE}$maxMemoryState ${NOCOLOR}" &&
	echo $maxMemoryState > /sys/class/drm/card$cardno/device/pp_dpm_mclk && echo -e "on ${GREEN}"`cat /sys/class/drm/card$cardno/device/pp_dpm_mclk | grep "*" | awk '{ print $2 }'`${NOCOLOR}
	
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
