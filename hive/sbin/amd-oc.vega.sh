#!/usr/bin/env bash


VEGA20=$( lspci -vnns $busid | grep VGA -A 2 | grep AMD -A 2 | grep Vega -A 2 | grep "Vega 20" | wc -l )
#NAVI=$( lspci -vnns $busid | grep Navi | wc -l )

echo "manual" > /sys/class/drm/card$cardno/device/power_dpm_force_performance_level

if [[ $NAVI_COUNT -ne 0 ]]; then
    args=""
    if [[ ! -z $VDDCI && ${VDDCI[$i]} -ge 750 && ${VDDCI[$i]} -le 850 ]]; then
       vlt_vddci=$((${VDDCI[$i]} * 4 ))
       args+="smcPPTable/MemVddciVoltage/1=${vlt_vddci} smcPPTable/MemVddciVoltage/2=${vlt_vddci} smcPPTable/MemVddciVoltage/3=${vlt_vddci} "
    fi
    if [[ ! -z $MVDD && ${MVDD[$i]} -ge 1250 && ${MVDD[$i]} -le 1350 ]]; then
       vlt_mvdd=$((${MVDD[$i]} * 4 ))
       args+="smcPPTable/MemMvddVoltage/1=${vlt_mvdd} smcPPTable/MemMvddVoltage/2=${vlt_mvdd} smcPPTable/MemMvddVoltage/3=${vlt_mvdd} "
    fi
    python /hive/opt/upp/upp.py -i /sys/class/drm/card$cardno/device/pp_table set \
    	smcPPTable/FanStopTemp=20 smcPPTable/FanStartTemp=25 smcPPTable/FanZeroRpmEnable=0 \
    	smcPPTable/MinVoltageGfx=2800 $args \
    	OverDrive8Table/ODSettingsMax/8=960 \
    	OverDrive8Table/ODFeatureCapabilities/9=0 \
    	OverDrive8Table/ODSettingsMin/3=700 OverDrive8Table/ODSettingsMin/5=700 OverDrive8Table/ODSettingsMin/7=700 \
    	--write
fi
#    	smcPPTable/FanTargetTemperature=85 
#    	smcPPTable/MemMvddVoltage/3=5200
#    	smcPPTable/MemVddciVoltage/3=3200
#	smcPPTable/FanPwmMin=35

function _SetcoreVDDC {
	if [[ $VEGA20 -ne 0 || $NAVI_COUNT -ne 0  ]]; then
		echo "Noop"
	else
	vegatool -i $cardno --volt-state 7 --vddc-table-set $1 --vddc-mem-table-set $1
	fi
}	

function _SetcoreClock {
	local vdd=$2
	if [[ $VEGA20 -ne 0 || $NAVI_COUNT -ne 0 ]]; then
		echo "s 1 $1" > /sys/class/drm/card$cardno/device/pp_od_clk_voltage
		[[  -z $vdd  ]] && vdd="1050"
		[[  -z $vdd  && $NAVI_COUNT -ne 0 ]] && vdd="0"
		[[ $vdd -gt 725 ]] && echo "vc 1 $(($1-100)) $(($vdd-25))" > /sys/class/drm/card$cardno/device/pp_od_clk_voltage
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
	if [[ $VEGA20 -ne 0 || $NAVI_COUNT -ne 0 ]]; then
		echo "m 1 $1" > /sys/class/drm/card$cardno/device/pp_od_clk_voltage
		echo c > /sys/class/drm/card$cardno/device/pp_od_clk_voltage
	else
		vegatool -i $cardno --mem-state 3 --mem-clock $1
	fi
}	

if [[ ! -z $MEM_CLOCK && ${MEM_CLOCK[$i]} -gt 0 ]]; then
	_SetmemClock ${MEM_CLOCK[$i]}
fi

if [[ ! -z $CORE_CLOCK && ${CORE_CLOCK[$i]} -gt 0 ]]; then
	_SetcoreClock ${CORE_CLOCK[$i]} ${CORE_VDDC[$i]}
fi

if [[ ! -z $CORE_VDDC && ${CORE_VDDC[$i]} -gt 0 ]]; then
	_SetcoreVDDC ${CORE_VDDC[$i]}
fi

[[ ! -z $REF && ${REF[$i]} -gt 0 ]] && amdmemtweak --gpu $card_idx --REF ${REF[$i]}

	echo 1 > /sys/class/drm/card$cardno/device/hwmon/hwmon*/pwm1_enable
	echo "manual" > /sys/class/drm/card$cardno/device/power_dpm_force_performance_level
	echo 5 > /sys/class/drm/card$cardno/device/pp_power_profile_mode
	#vegatool -i $cardno --set-fanspeed 50
	if [[ $VEGA20 -ne 0 || $NAVI_COUNT -ne 0 ]]; then
		rocm-smi -d  $cardno --setfan 50%
	else	
		vegatool -i $cardno  --set-fanspeed 50
	fi




[[ ! -z $FAN && ${FAN[$i]} -gt 0 ]] &&
	if [[ $VEGA20 -ne 0 || $NAVI_COUNT -ne 0 ]]; then
		rocm-smi -d  $cardno --setfan ${FAN[$i]}%
	else	
		vegatool -i $cardno  --set-fanspeed ${FAN[$i]}
	fi
	