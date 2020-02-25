#!/usr/bin/env bash

# applying all at once does not always work with running miner due to driver issues
FAST=0

PPT=/tmp/pp_table$cardno
CARDPPT=/sys/class/drm/card$cardno/device/pp_table

# using saved Power Play table
cp $savedpp $PPT

#coreState=`ohgodatool -p $PPT --show-core | grep -E "DPM state ([0-9]+):" | tail -n 1 | sed -r 's/.*([0-9]+).*/\1/'`
args=''
coreState=

# getting max mem state
#maxMemoryState=`ohgodatool -p $PPT --show-mem | grep -E "Memory state ([0-9]+):" | tail -n 1 | sed -r 's/.*([0-9]+).*/\1/'`
maxMemoryState=`ohgodatool -p $PPT --show-mem | grep -oP "Memory state \K[0-9]+" | tail -n 1`
maxMemoryClock=`ohgodatool -p $PPT --show-max-mem-clock | grep -oP "\K[0-9]+"`
maxCoreClock=`ohgodatool -p $PPT --show-max-core-clock | grep -oP "\K[0-9]+"`
maxPower=`ohgodatool -p $PPT --show-max-power | grep -oP "\K[0-9]+"`
TDP=`ohgodatool -p $PPT --show-tdp | grep -oP "\K[0-9]+"`
TDC=`ohgodatool -p $PPT --show-tdc | grep -oP "\K[0-9]+"`
#echo "Max core: ${maxCoreClock}MHz, Max mem: ${maxMemoryClock}MHz"
echo "TDP: ${TDP}W, TDC: ${TDC}A, Max power: ${maxPower}W"


if [[ ! -z $CORE_STATE ]]; then
	if [[ ${CORE_STATE[$i]} -ge 0 && ${CORE_STATE[$i]} -le 7 ]]; then
		[[ ${CORE_STATE[$i]} != 0 ]] && #skip zero state, means auto
			coreState=${CORE_STATE[$i]}
	else
		echo -e "${YELLOW}WARNING: Invalid core state ${CORE_STATE[$i]}, falling back to $DEFAULT_CORE_STATE${NOCOLOR}"
		#coreState=$DEFAULT_CORE_STATE
	fi
fi


if [[ -z ${MEM_STATE[$i]} || ${MEM_STATE[$i]} -le 0 || ${MEM_STATE[$i]} -gt $maxMemoryState ]]; then
	[[ ! -z ${MEM_STATE[$i]} && ${MEM_STATE[$i]} -ne 0 ]] && echo -e "${YELLOW}WARNING: Invalid mem state ${MEM_STATE[$i]}, falling back to $maxMemoryState${NOCOLOR}"
	MEM_STATE[$i]=$maxMemoryState
fi


if [[ ! -z $MEM_CLOCK && ${MEM_CLOCK[$i]} -gt 0 ]]; then
	ohgodatool -p $PPT --mem-clock ${MEM_CLOCK[$i]} --mem-state ${MEM_STATE[$i]}
	# fix mem clock setting with MDPM=1 on some gpu/driver/kernel combinations
	[[ ${MEM_STATE[$i]} -ne $maxMemoryState ]] &&
		ohgodatool -p $PPT --mem-clock ${MEM_CLOCK[$i]} --mem-state $maxMemoryState
	[[ ${MEM_CLOCK[$i]} -gt $maxMemoryClock ]] &&
		ohgodatool -p $PPT --set-max-mem-clock ${MEM_CLOCK[$i]}
	[[ $FAST -ne 1 ]] && cp $PPT $CARDPPT
fi


if [[ ! -z $CORE_CLOCK && ${CORE_CLOCK[$i]} -gt 0 ]]; then
	[[ -z $coreState ]] && # core set is not specified, let's use some default or it will not work
		echo -e "${YELLOW}WARNING: Unset core state, falling back to $DEFAULT_CORE_STATE${NOCOLOR}" &&
		coreState=$DEFAULT_CORE_STATE
	for coreStateCtr in {1..7}; do #setting frequencies for all states
		ohgodatool -p $PPT --core-clock ${CORE_CLOCK[$i]} --core-state $coreStateCtr
	done
	[[ ${CORE_CLOCK[$i]} -gt $maxCoreClock ]] &&
		ohgodatool -p $PPT --set-max-core-clock ${CORE_CLOCK[$i]}
	[[ $FAST -ne 1 ]] && cp $PPT $CARDPPT
fi


if [[ ! -z $CORE_VDDC && ${CORE_VDDC[$i]} -gt 0 ]]; then
	[[ -z $coreState ]] && # core set is not specified, let's use some default or it will not work
		echo -e "${YELLOW}WARNING: Unset core state, falling back to $DEFAULT_CORE_STATE${NOCOLOR}" &&
		coreState=$DEFAULT_CORE_STATE
	for voltStateCtr in {1..15}; do #setting undervolt for all volt states
		ohgodatool -p $PPT --vddc-table-set ${CORE_VDDC[$i]} --volt-state $voltStateCtr
	done
	[[ $FAST -ne 1 ]] && cp $PPT $CARDPPT
fi


[[ $FAST -eq 1 ]] &&
	echo "Applying all changes to Power Play table" &&
	cp $PPT $CARDPPT


# this must be disabled for R9
echo 1 > /sys/class/drm/card$cardno/device/hwmon/hwmon*/pwm1_enable
[[ ! -z $FAN && ${FAN[$i]} > 0 ]] && ohgodatool -i $cardno --set-fanspeed ${FAN[$i]}

[[ ! -z $REF && ${REF[$i]} > 0 ]] && amdmemtweak --gpu $i --REF ${REF[$i]}



##original fix from http://forum.hiveos.farm/discussion/721/how-to-undervolt-really-low
#for coreStateCtr in {1..7}; do eval wolfamdctrl -i $cardno --core-clock ${CORE_CLOCK[$i]} --core-state $coreStateCtr; done
#for voltStateCtr in {1..15}; do eval wolfamdctrl -i $cardno --vddc-table-set ${CORE_VDDC[$i]} --volt-state $voltStateCtr; done
#if [[ ! -z $FAN && ${FAN[$i]} > 0 ]]; then eval wolfamdctrl -i $cardno --set-fanspeed ${FAN[$i]}; fi
