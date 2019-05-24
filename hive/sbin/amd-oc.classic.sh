#!/usr/bin/env bash

#coreState=`wolfamdctrl -i $cardno --show-core | grep -E "DPM state ([0-9]+):" | tail -n 1 | sed -r 's/.*([0-9]+).*/\1/'`
args=''
coreState=

#memoryState=
#memoryState=1 #hello ethos
#getting max mem state
memoryState=`wolfamdctrl -i $cardno --show-mem | grep -E "Memory state ([0-9]+):" | tail -n 1 | sed -r 's/.*([0-9]+).*/\1/'`

if [[ ! -z $CORE_STATE ]]; then
	if [[ ${CORE_STATE[$i]} -ge 0 && ${CORE_STATE[$i]} -le 7 ]]; then
		[[ ${CORE_STATE[$i]} != 0 ]] && #skip zero state, means auto
			coreState=${CORE_STATE[$i]}
	else
		echo -e "${YELLOW}WARNING: Invalid core state ${CORE_STATE[$i]}, falling back to $DEFAULT_CORE_STATE${NOCOLOR}"
		#coreState=$DEFAULT_CORE_STATE
	fi
fi


if [[ ! -z $MEM_STATE ]]; then
	if [[ ${MEM_STATE[$i]} -ge 0 && ${MEM_STATE[$i]} -le $memoryState ]]; then
		[[ ${MEM_STATE[$i]} != 0 ]] && #skip zero state, means auto
			memoryState=${MEM_STATE[$i]}
	else
		echo -e "${YELLOW}WARNING: Invalid mem state ${MEM_STATE[$i]}, falling back to $memoryState${NOCOLOR}"
	fi
fi


if [[ ! -z $MEM_CLOCK && ${MEM_CLOCK[$i]} > 0 ]]; then
	#echo "Setting mem to ${MEM_CLOCK[$i]}" &&
	#wolfamdctrl -i $cardno --mem-clock ${MEM_CLOCK[$i]} --mem-state $memoryState
	args+=" --mem-clock ${MEM_CLOCK[$i]} --mem-state $memoryState"
fi

if [[ ! -z $CORE_CLOCK && ${CORE_CLOCK[$i]} > 0 ]]; then
	[[ -z $coreState ]] && # core set is not specified, let's use some default or it will not work
		echo -e "${YELLOW}WARNING: Unset core state, falling back to $DEFAULT_CORE_STATE${NOCOLOR}" &&
		coreState=$DEFAULT_CORE_STATE
	#wolfamdctrl -i $cardno --core-clock ${CORE_CLOCK[$i]} --core-state $coreState
	args+=" --core-clock ${CORE_CLOCK[$i]} --core-state $coreState"
fi


if [[ ! -z $CORE_VDDC && ${CORE_VDDC[$i]} > 0 ]]; then
	[[ -z $coreState ]] && # core set is not specified, let's use some default or it will not work
		echo -e "${YELLOW}WARNING: Unset core state, falling back to $DEFAULT_CORE_STATE${NOCOLOR}" &&
		coreState=$DEFAULT_CORE_STATE
	args+=" --vddc-table-set ${CORE_VDDC[$i]} --volt-state $coreState"
fi



#[[ ! -z $CORE_VDDC_INDEX && ${CORE_VDDC_INDEX[$i]} > 0 ]] &&
#	wolfamdctrl -i $cardno --core-vddc-idx ${CORE_VDDC_INDEX[$i]} --core-state $coreState


#[[ ! -z $FAN && ${FAN[$i]} > 0 ]] &&
	#wolfamdctrl -i $cardno --set-fanspeed ${FAN[$i]}
#	args+=" --set-fanspeed ${FAN[$i]}"


if [[ -z $args ]]; then
	: #maybe there is just DPM level to set
	#echo "Nothing to set"
else
	cp $savedpp /sys/class/drm/card$cardno/device/pp_table
	sync

	#wolfamdctrl -i $cardno --core-state $coreState --mem-state $memoryState --core-clock 1100 --mem-clock 2000
	oc_cmd="wolfamdctrl -i $cardno $args"
	echo $oc_cmd
	eval $oc_cmd

	echo 1 > /sys/class/drm/card$cardno/device/hwmon/hwmon*/pwm1_enable
	
	[[ ! -z $FAN && ${FAN[$i]} > 0 ]] && wolfamdctrl -i $cardno --set-fanspeed ${FAN[$i]}
	[[ ! -z $REF && ${REF[$i]} > 0 ]] && amdmemtweak --gpu $i --REF ${REF[$i]}
	
fi
