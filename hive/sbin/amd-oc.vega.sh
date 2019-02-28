#!/usr/bin/env bash


function _SetcoreVDDC {
	vegatool -i $cardno --volt-state 7 --vddc-table-set $1 --vddc-mem-table-set $1
}	


function _SetcoreClock {
	vegatool -i $cardno  --core-state 4 --core-clock $(($1-30))
	vegatool -i $cardno  --core-state 5 --core-clock $(($1-20))
	vegatool -i $cardno  --core-state 6 --core-clock $(($1-10))
	vegatool -i $cardno  --core-state 7 --core-clock $1
}	


function _SetmemClock {
	vegatool -i $cardno --mem-state 3 --mem-clock $1
}	

if [[ ! -z $MEM_CLOCK && ${MEM_CLOCK[$i]} > 0 ]]; then
	_SetmemClock ${MEM_CLOCK[$i]}
fi

if [[ ! -z $CORE_CLOCK && ${CORE_CLOCK[$i]} > 0 ]]; then
	_SetcoreClock ${CORE_CLOCK[$i]}
fi

if [[ ! -z $CORE_VDDC && ${CORE_VDDC[$i]} > 0 ]]; then
	_SetcoreVDDC ${CORE_VDDC[$i]}
fi

	echo 1 > /sys/class/drm/card$cardno/device/hwmon/hwmon*/pwm1_enable
	echo "manual" > /sys/class/drm/card$cardno/device/power_dpm_force_performance_level
	echo 4 > /sys/class/drm/card$cardno/device/pp_power_profile_mode
	vegatool -i $cardno --set-fanspeed 50



[[ ! -z $FAN && ${FAN[$i]} > 0 ]] &&
	vegatool -i $cardno  --set-fanspeed ${FAN[$i]}
