#!/usr/bin/env bash

args=""

function _SetVDDC {
	
	for coreState in {0..7}; do
		args+="VddcLookupTable/$coreState/Vdd=$1 "
	done
}

function _SetcoreClock {
#		args+="GfxClockDependencyTable/0/Clock=$(( $1-160 ))00 "
#		args+="GfxClockDependencyTable/1/Clock=$(( $1-150 ))00 "
		args+="GfxClockDependencyTable/2/Clock=$(( $1-100 ))00 "
		args+="GfxClockDependencyTable/3/Clock=$(( $1-20 ))00 "
		args+="GfxClockDependencyTable/4/Clock=$(( $1-15 ))00 "
		args+="GfxClockDependencyTable/5/Clock=$(( $1-10 ))00 "
		args+="GfxClockDependencyTable/6/Clock=$(( $1-5 ))00 "
		args+="GfxClockDependencyTable/7/Clock=$(( $1 ))00 "
}

function _SetmemClock {
#	args+="MemClockDependencyTable/0/MemClock=$(( $1-50 ))00 "
#	args+="MemClockDependencyTable/1/MemClock=$(( $1-20 ))00 "
	args+="MemClockDependencyTable/2/MemClock=$(( $1-10 ))00 "
	args+="MemClockDependencyTable/3/MemClock=$(( $1 ))00 "
}

function _SetMVDD {
	args+="VddcLookupTable/2/Vdd=$1 "
}

function _SetVDDCI {
	args+="VddciLookupTable/0/Vdd=$1 "
}



if [[ ! -z $CORE_VDDC && ${CORE_VDDC[$i]} -gt 800 ]]; then
	_SetVDDC ${CORE_VDDC[$i]}
fi

if [[ ! -z $CORE_CLOCK && ${CORE_CLOCK[$i]} -gt 0 ]]; then
	_SetcoreClock ${CORE_CLOCK[$i]} ${CORE_VDDC[$i]}
fi

if [[ ! -z $MEM_CLOCK && ${MEM_CLOCK[$i]} -gt 0 ]]; then
	_SetmemClock ${MEM_CLOCK[$i]}
fi

if [[ ! -z $MEM_STATE && ${MEM_STATE[$i]} -gt 800 ]]; then
	_SetMVDD  ${MEM_STATE[$i]}
fi

if [[ ! -z $CORE_STATE && ${CORE_STATE[$i]} -gt 800 ]]; then
	_SetVDDCI  ${CORE_STATE[$i]}
fi


#echo $args
python /hive/opt/upp/upp.py -i /sys/class/drm/card$cardno/device/pp_table set $args --write
cat /sys/class/drm/card$cardno/device/pp_od_clk_voltage

if [[ ! -z $PL && ${PL[$i]} -gt 0 ]]; then
	echo "${PL[$i]}000000" > /sys/class/drm/card$cardno/device/hwmon/hwmon*/power1_cap
fi

#[[ ! -z $REF && ${REF[$i]} > 0 ]] && amdmemtweak --gpu $i --REF ${REF[$i]}

	echo 1 > /sys/class/drm/card$cardno/device/hwmon/hwmon*/pwm1_enable
	echo "manual" > /sys/class/drm/card$cardno/device/power_dpm_force_performance_level
	echo 5 > /sys/class/drm/card$cardno/device/pp_power_profile_mode
	vegatool -i $cardno --set-fanspeed 50

[[ ! -z $FAN && ${FAN[$i]} -gt 0 ]] && vegatool -i $cardno  --set-fanspeed ${FAN[$i]}
