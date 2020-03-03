#!/usr/bin/env bash

# applying modified pp_table to driver without restoring original one
# just for testing purposes
SLOW=0

PPT=/tmp/pp_table$cardno
CARDPPT=/sys/class/drm/card$cardno/device/pp_table

# using saved Power Play table
cp $savedpp $PPT

#coreState=`ohgodatool -p $PPT --show-core | grep -E "DPM state ([0-9]+):" | tail -n 1 | sed -r 's/.*([0-9]+).*/\1/'`
args=''
coreState=
memoryState=


# getting max mem state
#maxMemoryState=`ohgodatool -p $PPT --show-mem | grep -E "Memory state ([0-9]+):" | tail -n 1 | sed -r 's/.*([0-9]+).*/\1/'`
maxMemoryState=`ohgodatool -p $PPT --show-mem | grep -oP "Memory state \K[0-9]+" | tail -n 1`
maxMemoryClock=`ohgodatool -p $PPT --show-max-mem-clock | grep -oP "\K[0-9]+"`
maxCoreClock=`ohgodatool -p $PPT --show-max-core-clock | grep -oP "\K[0-9]+"`
maxPower=`ohgodatool -p $PPT --show-max-power | grep -oP "\K[0-9]+"`
TDP=`ohgodatool -p $PPT --show-tdp | grep -oP "\K[0-9]+"`
TDC=`ohgodatool -p $PPT --show-tdc | grep -oP "\K[0-9]+"`
#echo "Max core: ${maxCoreClock}MHz, Max mem: ${maxMemoryClock}MHz, Max mem state: $maxMemoryState"
echo "TDP: ${TDP}W, TDC: ${TDC}A, Max power: ${maxPower}W"


if [[ ! -z $CORE_STATE ]]; then
	if [[ ${CORE_STATE[$i]} -ge 0 && ${CORE_STATE[$i]} -le 7 ]]; then
		[[ ${CORE_STATE[$i]} != 0 ]] && #skip zero state, means auto
			coreState=${CORE_STATE[$i]}
	else
		echo -e "${RED}ERROR: Invalid core state ${CORE_STATE[$i]} specified $NOCOLOR"
	fi
fi


if [[ ! -z $MEM_STATE ]]; then
	if [[ ${MEM_STATE[$i]} -ge 0 && ${MEM_STATE[$i]} -le $maxMemoryState ]]; then
		[[ ${MEM_STATE[$i]} != 0 ]] && #skip zero state, means auto
			memoryState=${MEM_STATE[$i]}
	else
		if [[ ${MEM_STATE[$i]} -gt 100 ]]; then
			memoryState=1 # setting to memstate 1 by default
			# using as vddci
			args+=" --vddci ${MEM_STATE[$i]}"
			#args+=" --mem-vddc-idx 8"
			#ohgodatool -p $PPT --volt-state 8 --vddc-table-set ${MEM_STATE[$i]}
		else
			echo "${RED}ERROR: Invalid memory state ${MEM_STATE[$i]} specified $NOCOLOR"
		fi
	fi
fi


if [[ ! -z $MEM_CLOCK && ${MEM_CLOCK[$i]} -gt 400 ]]; then
	[[ -z $memoryState ]] &&
		echo -e "${YELLOW}WARNING: Empty memory state, setting to max state $maxMemoryState $NOCOLOR" &&
		memoryState=$maxMemoryState
	args+=" --mem-clock ${MEM_CLOCK[$i]} --mem-state $memoryState"
	[[ ${MEM_CLOCK[$i]} -gt $maxMemoryClock ]] &&
		args+="  --set-max-mem-clock ${MEM_CLOCK[$i]}"
fi


if [[ ! -z $CORE_CLOCK && ${CORE_CLOCK[$i]} -gt 400 ]]; then
	[[ -z $coreState ]] && # core set is not specified, let's use some default or it will not work
		echo -e "${YELLOW}WARNING: Empty core state, falling back to $DEFAULT_CORE_STATE $NOCOLOR" &&
		coreState=$DEFAULT_CORE_STATE
	args+=" --core-clock ${CORE_CLOCK[$i]} --core-state $coreState"
	[[ ${CORE_CLOCK[$i]} -gt $maxCoreClock ]] &&
		args+=" --set-max-core-clock ${CORE_CLOCK[$i]}"
fi


if [[ ! -z $CORE_VDDC && ${CORE_VDDC[$i]} -gt 0 ]]; then
	[[ -z $coreState ]] && # core set is not specified, let's use some default or it will not work
		echo -e "${YELLOW}WARNING: Empty core state, falling back to $DEFAULT_CORE_STATE $NOCOLOR" &&
		coreState=$DEFAULT_CORE_STATE
	args+=" --vddc-table-set ${CORE_VDDC[$i]} --volt-state $coreState"
fi


if [[ ! -z $args ]]; then
	if [[ $SLOW -ne 1 ]]; then
		# apply changes to table
		#echo "ohgodatool -p $PPT $args"
		output=`ohgodatool -p $PPT $args 2>&1`

		# fix mem clock setting with MDPM 1 on some gpu/driver/kernel combinations
		[[ ! -z $memoryState && $memoryState -ne $maxMemoryState && ${MEM_CLOCK[$i]} -gt 400 ]] &&
			output+=$'\n'`ohgodatool -p $PPT --mem-clock ${MEM_CLOCK[$i]} --mem-state $maxMemoryState 2>&1`

		# do not apply the same table again
		if cmp $PPT $CARDPPT >/dev/null; then
			echo -e "${GREEN}All changes were already applied to Power Play table $NOCOLOR"
		else
			echo "$output"
			echo -e "${CYAN}Applying all changes to Power Play table $NOCOLOR"
			cp $PPT $CARDPPT
		fi
	else
		# restore saved Power Play table
		cp $savedpp $CARDPPT
		# apply changes to gpu
		#echo "ohgodatool -i $cardno $args"
		ohgodatool -i $cardno $args

		# fix mem clock setting with MDPM 1 on some bios/gpu/driver/kernel combinations
		[[ ! -z $memoryState && $memoryState -ne $maxMemoryState && ${MEM_CLOCK[$i]} -gt 400 ]] &&
			ohgodatool -i $cardno --mem-clock ${MEM_CLOCK[$i]} --mem-state $maxMemoryState
	fi
else
	# do not apply the same table again
	if cmp $savedpp $CARDPPT >/dev/null; then
		echo -e "${GREEN}All changes were already applied to Power Play table $NOCOLOR"
	else
		echo -e "${CYAN}Restoring original Power Play table $NOCOLOR"
		# restore saved Power Play table
		cp $savedpp $CARDPPT
	fi
fi


# this must be disabled for R9
echo 1 > /sys/class/drm/card$cardno/device/hwmon/hwmon*/pwm1_enable
[[ ! -z $FAN && ${FAN[$i]} > 0 ]] && ohgodatool -i $cardno --set-fanspeed ${FAN[$i]}

[[ ! -z $REF && ${REF[$i]} > 0 ]] && amdmemtweak --gpu $i --REF ${REF[$i]}

