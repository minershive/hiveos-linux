#!/usr/bin/env bash


VEGA20=$( lspci -vnns $busid | grep VGA -A 2 | grep AMD -A 2 | grep Vega -A 2 | grep "Vega 20" | wc -l )
#NAVI=$( lspci -vnns $busid | grep Navi | wc -l )

# GFX VDDC (Core), mV
NAVI_CVDDC_MIN=600   # Min VDDC - Gfx Core
NAVI_CVDDC_MAX=1200  # Max VDDC - Gfx Core
NAVI_CVDDC_SAFE=950  # Default fail safe voltage
# SoC VDD limits, mV
NAVI_SOC_VDD_MIN=600   # Min SoC VDD
NAVI_SOC_VDD_MAX=1200  # Max SoC VDD
# Memory Interface Controller Interface Voltage, mV
NAVI_VDDCI_MIN=650   # Min VDDCI
NAVI_VDDCI_MAX=850   # Max VDDCI
# Memory Voltage, mV
NAVI_MVDD_MIN=1200   # Min MVDD
NAVI_MVDD_MAX=1350   # Max MVDD
# Clocks, MHz
NAVI_MaxMemClock=1075 # Max memory clock

#echo "Set OC for GPU$i"
echo "manual" > /sys/class/drm/card$cardno/device/power_dpm_force_performance_level

if [[ $NAVI_COUNT -ne 0 ]]; then
    args=""
    
    if [[ ! -z $VDDCI && ${VDDCI[$i]} -ge $NAVI_VDDCI_MIN && ${VDDCI[$i]} -le $NAVI_VDDCI_MAX ]]; then
       vlt_vddci=$((${VDDCI[$i]} * 4 ))
       args+="smc_pptable/MemVddciVoltage/1=${vlt_vddci} smc_pptable/MemVddciVoltage/2=${vlt_vddci} smc_pptable/MemVddciVoltage/3=${vlt_vddci} "
    fi

    if [[ ! -z $MVDD && ${MVDD[$i]} -ge $NAVI_MVDD_MIN && ${MVDD[$i]} -le $NAVI_MVDD_MAX ]]; then
       vlt_mvdd=$((${MVDD[$i]} * 4 ))
       args+="smc_pptable/MemMvddVoltage/1=${vlt_mvdd} smc_pptable/MemMvddVoltage/2=${vlt_mvdd} smc_pptable/MemMvddVoltage/3=${vlt_mvdd} "
    fi

    if [[ ! -z $SOCCLK && ${SOCCLK[$i]} -gt 0 ]]; then
        args+="smc_pptable/FreqTableSocclk/1=${SOCCLK[$i]} "
    fi

    if [[ ! -z $SOCVDDMAX && ${SOCVDDMAX[$i]} -ge $NAVI_SOC_VDD_MIN && ${SOCVDDMAX[$i]} -le $NAVI_SOC_VDD_MAX ]]; then
        vlt_soc=$((${SOCVDDMAX[$i]} * 4 ))
        args+="smc_pptable/MaxVoltageSoc=${vlt_soc} "
    fi

    # overdrive_table/max/ 0/1/2/4/6=gfxclock, 3/5/7=gfxvolt, 9=pl_overdrive, 8=memclock
    python3 /hive/opt/upp2/upp.py  -p /sys/class/drm/card$cardno/device/pp_table set \
    	smc_pptable/FanStopTemp=0 smc_pptable/FanStartTemp=0 smc_pptable/FanZeroRpmEnable=0 \
    	smc_pptable/MinVoltageGfx=$(( NAVI_CVDDC_MIN * 4 ))  \
    	$args \
    	overdrive_table/max/8=${NAVI_MaxMemClock} \
    	overdrive_table/min/3=${NAVI_CVDDC_MIN} overdrive_table/min/5=${NAVI_CVDDC_MIN} overdrive_table/min/7=${NAVI_CVDDC_MIN} \
    	--write >/dev/null
fi

#	smcPPTable/FanTargetTemperature=85 
#	smcPPTable/MemMvddVoltage/3=5200
#	smcPPTable/MemVddciVoltage/3=3200
#	smcPPTable/FanPwmMin=35
#	OverDrive8Table/ODFeatureCapabilities/9=0

function _SetcoreVDDC {
#    echo "noop"
    return 0
}

function _SetcoreClock {
    local vdd=$2

    echo "s 1 $1" > /sys/class/drm/card$cardno/device/pp_od_clk_voltage
    [[  -z $vdd  || $vdd -eq 0 ]] && vdd="${NAVI_CVDDC_SAFE}"
    [[  -z $vdd  && $NAVI_COUNT -ne 0 ]] && vdd="0"
    [[ $vdd -ge $((NAVI_CVDDC_MIN+25)) ]] && echo "vc 1 $(($1-200)) $(($vdd-25))" > /sys/class/drm/card$cardno/device/pp_od_clk_voltage
    echo "vc 2 $1 $vdd" > /sys/class/drm/card$cardno/device/pp_od_clk_voltage
    echo c > /sys/class/drm/card$cardno/device/pp_od_clk_voltage
}

function _SetmemClock {
    echo "m 1 $1" > /sys/class/drm/card$cardno/device/pp_od_clk_voltage
    echo c > /sys/class/drm/card$cardno/device/pp_od_clk_voltage
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

echo 1 > /sys/class/drm/card$cardno/device/hwmon/hwmon*/pwm1_enable
echo "manual" > /sys/class/drm/card$cardno/device/power_dpm_force_performance_level
echo 5 > /sys/class/drm/card$cardno/device/pp_power_profile_mode

hwmondir=`realpath /sys/class/drm/card$cardno/device/hwmon/hwmon*/`
if [[ ! -z ${hwmondir} ]]; then
    # set PL
    if [[ ! -z $PL && ${PL[$i]} -gt 0 ]]; then
        if [[ -e ${hwmondir}/power1_cap_max ]] && [[ -e ${hwmondir}/power1_cap ]]; then
#           rocm-smi -d $cardno --autorespond=y --setpoweroverdrive ${PL[$i]} # --loglevel error 
           echo $((PL[$i]*1000000)) > ${hwmondir}/power1_cap && echo "Power Limit set to ${PL[$i]}W"
        fi
    fi

    # set fan speed
    [[ -e ${hwmondir}/pwm1_enable ]] && echo 1 > ${hwmondir}/pwm1_enable
    if [[ ${FAN[$i]} -gt 0 && -e ${hwmondir}/pwm1 ]]; then
        [[ -e ${hwmondir}/pwm1_max ]] && fanmax=`head -1 ${hwmondir}/pwm1_max` || fanmax=255
        [[ -e ${hwmondir}/pwm1_min ]] && fanmin=`head -1 ${hwmondir}/pwm1_min` || fanmin=0
        echo $(( FAN[i]*(fanmax - fanmin)/100 + fanmin )) > ${hwmondir}/pwm1
    fi
else
    echo "Error: unable to get HWMON dir"
fi

[[ -e /sys/class/drm/card$cardno/device/pp_od_clk_voltage ]] && echo "${CYAN}Applying all changes to Power Play table $NOCOLOR" && cat /sys/class/drm/card$cardno/device/pp_od_clk_voltage
