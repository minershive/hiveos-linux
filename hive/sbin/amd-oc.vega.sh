#!/usr/bin/env bash


VEGA20=$( lspci -vnns $busid | grep VGA -A 2 | grep AMD -A 2 | grep Vega -A 2 | grep "Vega 20" | wc -l )

function _SetcoreVDDC {
	if [[ $VEGA20 -ne 0 ]]; then
		echo "Noop"
	else
	vegatool -i $cardno --volt-state 7 --vddc-table-set $1 --vddc-mem-table-set $1
	fi
}	

function _SetcoreClock {
	local vdd=$2
	if [[ $VEGA20 -ne 0 ]]; then
		echo "s 1 $1" > /sys/class/drm/card$cardno/device/pp_od_clk_voltage
		[[  -z $vdd  ]] && vdd="1050" 
		echo "vc 2 $1 $vdd" > /sys/class/drm/card$cardno/device/pp_od_clk_voltage
		echo c > /sys/class/drm/card$cardno/device/pp_od_clk_voltage

	else
		vegatool -i $cardno  --core-state 4 --core-clock $(($1-30))
		vegatool -i $cardno  --core-state 5 --core-clock $(($1-20))
		vegatool -i $cardno  --core-state 6 --core-clock $(($1-10))
		vegatool -i $cardno  --core-state 7 --core-clock $1
	fi
}	

function _SetmemClock {
	if [[ $VEGA20 -ne 0 ]]; then
		echo "m 1 $1" > /sys/class/drm/card$cardno/device/pp_od_clk_voltage
		echo c > /sys/class/drm/card$cardno/device/pp_od_clk_voltage
	else
		vegatool -i $cardno --mem-state 3 --mem-clock $1
	fi
}	

if [[ ! -z $MEM_CLOCK && ${MEM_CLOCK[$i]} > 0 ]]; then
	_SetmemClock ${MEM_CLOCK[$i]}
fi

if [[ ! -z $CORE_CLOCK && ${CORE_CLOCK[$i]} > 0 ]]; then
	_SetcoreClock ${CORE_CLOCK[$i]} ${CORE_VDDC[$i]}
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
