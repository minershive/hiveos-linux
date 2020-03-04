#!/usr/bin/env bash

# applying all at once does not always work with running miner due to driver issues
FAST=0

PPT=/tmp/pp_table$cardno
CARDPPT=/sys/class/drm/card$cardno/device/pp_table

load=
# get gpu load and switch to fast mode if not used by miner
if [[ -e /sys/class/drm/card$cardno/device/gpu_busy_percent ]]; then
	load=`head -1 /sys/class/drm/card$cardno/device/gpu_busy_percent 2>/dev/null`
elif [[ -e /sys/kernel/debug/dri/$cardno/amdgpu_pm_info ]]; then
	load=`grep -m1 'GPU Load' /sys/kernel/debug/dri/$cardno/amdgpu_pm_info 2>/dev/null | awk '{printf("%d", $3)}'`
fi
[[ $load == 0 ]] && FAST=1


# using saved Power Play table
cp $savedpp $PPT

#coreState=`ohgodatool -p $PPT --show-core | grep -E "DPM state ([0-9]+):" | tail -n 1 | sed -r 's/.*([0-9]+).*/\1/'`
coreState=
memoryState=
vddci=


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
		echo "${RED}ERROR: Invalid core state ${CORE_STATE[$i]} specified $NOCOLOR"
	fi
fi

# core set is not specified, let's use some default or it will not work in some cases
[[ -z $coreState && ( ${CORE_VDDC[$i]} -le 0 || ${CORE_CLOCK[$i]} -le 400 ) ]] &&
	echo "${YELLOW}WARNING: Empty core state, falling back to $DEFAULT_CORE_STATE $NOCOLOR" &&
	coreState=$DEFAULT_CORE_STATE


if [[ ! -z $MEM_STATE ]]; then
	if [[ ${MEM_STATE[$i]} -ge 0 && ${MEM_STATE[$i]} -le $maxMemoryState ]]; then
		[[ ${MEM_STATE[$i]} != 0 ]] && #skip zero state, means auto
			memoryState=${MEM_STATE[$i]}
	else
		if [[ ${MEM_STATE[$i]} -gt 100 ]]; then
			# using as vddci voltage
			vddci=" --vddci ${MEM_STATE[$i]}"
			memoryState=$maxMemoryState
		else
			echo "${RED}ERROR: Invalid memory state ${MEM_STATE[$i]} specified $NOCOLOR"
		fi
	fi
fi

# set memory state if needed
[[ -z $memoryState && ${MEM_CLOCK[$i]} -gt 400 ]] &&
	echo "${YELLOW}WARNING: Empty memory state, setting to max state $maxMemoryState $NOCOLOR" &&
	memoryState=$maxMemoryState


function applyToPPT {

	if [[ ${MEM_CLOCK[$i]} -gt 400 ]]; then
		ohgodatool -p $PPT --mem-clock ${MEM_CLOCK[$i]} --mem-state $memoryState $vddci 2>&1
		# fix mem clock setting with MDPM 1 on some gpu/driver/kernel combinations
		[[ $memoryState -ne $maxMemoryState ]] &&
			ohgodatool -p $PPT --mem-clock ${MEM_CLOCK[$i]} --mem-state $maxMemoryState $vddci 2>&1
		# set MDPM 1 clocks lower than MDPM 2 to avoid switching in auto mode
		[[ $memoryState -eq 2 ]] &&
			ohgodatool -p $PPT --mem-clock $(( ${MEM_CLOCK[$i]} - 100 )) --mem-state 1 2>&1
		# set bios max mem clock if needed
		[[ ${MEM_CLOCK[$i]} -gt $maxMemoryClock ]] &&
			ohgodatool -p $PPT --set-max-mem-clock ${MEM_CLOCK[$i]} 2>&1
		[[ $1 -eq 1 ]] && cp $PPT $CARDPPT
	fi

	if [[ ${CORE_CLOCK[$i]} -gt 400 ]]; then
		# set core clock for all states
		echo "Setting core clock to ${CORE_CLOCK[$i]}"
		for coreStateCtr in {1..7}; do
			ohgodatool -p $PPT --core-clock ${CORE_CLOCK[$i]} --core-state $coreStateCtr >/dev/null 2>&1
		done
		# set bios max core clock if needed
		[[ ${CORE_CLOCK[$i]} -gt $maxCoreClock ]] &&
			ohgodatool -p $PPT --set-max-core-clock ${CORE_CLOCK[$i]} 2>&1
		[[ $1 -eq 1 ]] && cp $PPT $CARDPPT
	fi

	if [[ ${CORE_VDDC[$i]} -gt 0 ]]; then
		# set core volt
		echo "Setting core voltage to ${CORE_VDDC[$i]}"
		for voltStateCtr in {1..7}; do
			ohgodatool -p $PPT --vddc-table-set ${CORE_VDDC[$i]} --volt-state $voltStateCtr >/dev/null 2>&1
		done
		# set mem volt
		echo "Setting memory voltage to ${CORE_VDDC[$i]}"
		for voltStateCtr in {8..15}; do
			ohgodatool -p $PPT --vddc-table-set ${CORE_VDDC[$i]} --volt-state $voltStateCtr >/dev/null 2>&1
		done
		[[ $1 -eq 1 ]] && cp $PPT $CARDPPT
	fi
}


# apply all changes to PPT and check if they differ from already applied
output=$(applyToPPT)

# do not apply the same table again
if cmp $PPT $CARDPPT >/dev/null; then
	echo "${GREEN}All changes were already applied to Power Play table $NOCOLOR"
# compare to original one
elif cmp $PPT $savedpp >/dev/null; then
	echo "${CYAN}Restoring original Power Play table $NOCOLOR"
	cp $PPT $CARDPPT
# apply in fast mode
elif [[ $FAST -eq 1 ]]; then
	echo "$output"
	echo "${CYAN}Applying all changes to Power Play table $NOCOLOR"
	cp $PPT $CARDPPT
# apply in step by step mode
else
	cp $savedpp $PPT
	applyToPPT 1
fi

# this must be disabled for R9
echo 1 > /sys/class/drm/card$cardno/device/hwmon/hwmon*/pwm1_enable
[[ ! -z $FAN && ${FAN[$i]} > 0 ]] && ohgodatool -i $cardno --set-fanspeed ${FAN[$i]}

[[ ! -z $REF && ${REF[$i]} > 0 ]] && amdmemtweak --gpu $card_idx --REF ${REF[$i]}



##original fix from http://forum.hiveos.farm/discussion/721/how-to-undervolt-really-low
#for coreStateCtr in {1..7}; do eval wolfamdctrl -i $cardno --core-clock ${CORE_CLOCK[$i]} --core-state $coreStateCtr; done
#for voltStateCtr in {1..15}; do eval wolfamdctrl -i $cardno --vddc-table-set ${CORE_VDDC[$i]} --volt-state $voltStateCtr; done
#if [[ ! -z $FAN && ${FAN[$i]} > 0 ]]; then eval wolfamdctrl -i $cardno --set-fanspeed ${FAN[$i]}; fi
