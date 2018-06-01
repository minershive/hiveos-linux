#!/usr/bin/env bash
source /etc/environment
. colors

export DISPLAY=":0"

NS='/usr/bin/nvidia-settings'

# TODO this block must be refactored to library functions

amd_indexes_query='[ . | to_entries[] | select(.value.brand == "amd") | .key ]'
amd_indexes_array=`echo "$HIVE_GPU_DETECT_JSON" | jq -r "$amd_indexes_query | .[]"`
amd_cards_number=`echo "$HIVE_GPU_DETECT_JSON" | jq -c "$amd_indexes_query | length"`

nvidia_indexes_query='[ . | to_entries[] | select(.value.brand == "nvidia") | .key ]'
nvidia_indexes_array=`echo "$HIVE_GPU_DETECT_JSON" | jq -r "$nvidia_indexes_query| .[]"`
nvidia_cards_number=`echo "$HIVE_GPU_DETECT_JSON" | jq -c "$nvidia_indexes_query | length"`

# TODO cpus maybe required to use autofans too
#cpu_indexes_query='[ . | to_entries[] | select(.value.brand == "cpu") | .key ]'
#cpu_indexes_array=`echo "$HIVE_GPU_DETECT_JSON" | jq -r "$cpu_indexes_query"`
#cpu_cores_number=`echo "$HIVE_GPU_DETECT_JSON" | jq -c "$cpu_indexes_query | length"`

if [[ $nvidia_indexes_array == '[]' && $amd_indexes_array == '[]' ]]; then
    echo -e "No one ${RED}AMD${NOCOLOR} or ${GREEN}NVIDIA${NOCOLOR} cards found"
    exit 1
fi

if (( $nvidia_cards_number > 0 )); then
  echo -e "You have ${GREEN}NVIDIA${NOCOLOR} GPU's: $nvidia_cards_number"
  nvidia-smi -pm 1
  $NS -a GPUPowerMizerMode=1
fi
if (( $amd_cards_number > 0 )); then
  echo -e "You have ${RED}AMD${NOCOLOR} GPU's: $amd_cards_number"
fi

# Default settings
mode_default="auto"
mode=$mode_default

# Probably Nvidia and AMD will have different default settings
targettemp_default=65
targettemp=$targettemp_default
mintemp_default=10
mintemp=$mintemp_default
maxtemp_default=79
maxtemp=$maxtemp_default

fanpercent_default="80"
fanpercent=$fanpercent_default

usage ()
{
    echo "⚞ HIVE-GPU-AUTOFANS ⚟"
    echo
    echo "usage: $0 -m=(auto|constant) [-t=TEMP] [-mt=TEMP] [-Mt=TEMP] [-s=SPEED]"
    echo
    echo "Description:"
    echo "  -m|--mode      coolers adjustment (default: $mode_default)"
    echo "      auto            (recommended) automatic coolers adjustment. By default it holds ${targettemp_default}C but you may change this through '-t'"
    echo "      constant         constant coolers speed. Set the value via '-s'"
    echo
    echo "  -t|--gputemp   target temperature (default: ${targettemp_default}C)"
    echo "      TEMP            integer value. Temperature in Celsius"
    echo
    echo "  -mt|--mintemp  minimal temperature (cannot be lower than $mintemp_default%)"
    echo "      TEMP            integer value. Temperature in Celsius"
    echo
    echo "  -Mt|--maxtemp  maximal temperature when the miner will stopped (default: $maxtemp_default)"
    echo "      TEMP            integer value. Temperature in Celsius"
    echo
    echo "  -s|--fanspeed  fans speed (default: $fanpercent_default%)"
    echo "      SPEED           integer value. Speed in percents"
    exit
}

###
# Getting fan speed
# (required) temperature - current GPU chipset temperature
# (required) gpu_fan_speed - current card's fan speed in percents
#
# Result:
# The speed of fan in percents
get_fan_speed () {
    local temperature=$1
    local gpu_fan_speed=$2
    local target_fan_speed=$mintemp
    if (( $temperature < ($targettemp - 10) )); then
        # no reasons to change fan speed
        target_fan_speed=$gpu_fan_speed
    else
        # this action is going in a period from ($targettemp - 10) to $targettemp
        if (( $temperature < $targettemp )); then
            target_fan_speed=($gpu_fan_speed + 5)
        else
            target_fan_speed=($gpu_fan_speed + 10)
        fi
        if (( $temperature < ($maxtemp-5) )); then
            target_fan_speed=($gpu_fan_speed + 30)
        fi
    fi
    if (($target_fan_speed > 100)); then
        target_fan_speed=100
    fi
    echo $target_fan_speed
}

###
# What we must to do if temperature reached some limits
event_by_temperature() {
    local temperature=$1
    AUTOFAN_MINER="miner-start"
    if (( $temperature >= $maxtemp )); then
        AUTOFAN_MINER="miner-stop"
    fi
}

action_by_event() {
    case $AUTOFAN_MINER in
        "miner-start")
        local miners_started=`screen -ls | grep miner | wc -l`
        if (( $miners_started <1 )); then
            miner start
        fi
        ;;

        "miner-stop")
        miner stop
        ;;
    esac
}


# TODO merge with amd_auto_fan_control
nvidia_auto_fan_control ()
{
    args=
    for index in ${nvidia_indexes_array[@]}
    do
        local gpu_temperature=${temperatures_array[index]}
        local gpu_fan_speed=${fans_array[index]}
        event_by_temperature $gpu_temperature
#        echo -e "GPU:$index T=$gpu_temperature FAN=$gpu_fan_speed%"
        local TARGET_FAN_SPEED=$(get_fan_speed $gpu_temperature $gpu_fan_speed)
        args+=" -a [gpu:$index]/GPUFanControlState=1 -a [fan-$index]/GPUTargetFanSpeed=$TARGET_FAN_SPEED"
    done
    $NS $args > /dev/null 2>&1
    action_by_event
}

amd_auto_fan_control ()
{
    for index in ${amd_indexes_array[@]}
    do
        local gpu_temperature=${temperatures_array[index]}
        local gpu_fan_speed=${fans_array[index]}
        event_by_temperature $gpu_temperature
#        echo -e "GPU:$index T=$gpu_temperature FAN=$gpu_fan_speed%"
        local TARGET_FAN_SPEED=$(get_fan_speed $gpu_temperature $gpu_fan_speed)
        wolfamdctrl -i $index --set-fanspeed $TARGET_FAN_SPEED 1>/dev/null
    done
    action_by_event
}

auto_fan_control() {
	while true;	do
        declare -a temperatures_array=(`cat $HIVE_GPU_STATS_LOG | tail -1 | jq -r ".params.temp | .[]"`)
        declare -a fans_array=(`cat $HIVE_GPU_STATS_LOG | tail -1 | jq -r ".params.fan | .[]"`)
        if (( $nvidia_cards_number > 0 )); then
            nvidia_auto_fan_control
        fi
        if (( $amd_cards_number > 0 )); then
            amd_auto_fan_control
        fi
		sleep 10
	done
}

set_constant_fan_speeds ()
{
    if (( $nvidia_cards_number > 0 )); then
        args=
        for index in ${nvidia_indexes_array[@]}
        do
            args+=" -a [gpu:$index]/GPUFanControlState=1 -a [fan-$index]/GPUTargetFanSpeed=$fanpercent"
        done
        $NS $args > /dev/null 2>&1
    fi
    if (( $amd_cards_number > 0 )); then
        for index in ${amd_indexes_array[@]}
        do
            wolfamdctrl -i $index --set-fanspeed $fanpercent 1>/dev/null
        done
    fi
}

set_requested_fans_speed ()
{
    case $mode in
        "constant") set_constant_fan_speeds ;;
        "auto") auto_fan_control ;;
    esac
}

# Arguments parsing and validating
#if [[ -z "$1" ]]; then
#    echo -e "(EE) Error: invalid arguments. Please see available arguments below \n\n"
#    usage;
#    exit 1;
#fi

# TODO refactor this to function
for i in "$@"
do
case $i in
    -m=*|--mode=*)
    mode="${i#*=}"
    if [[ "auto" != $mode && "constant" != $mode ]]; then
        echo -e "(EE) The value '$mode' is invalid. Please see available arguments and values below \n\n"
        usage;
        exit 1
    fi
    shift # past argument=value
    ;;

    -s=*|--fanspeed=*)
    fanpercent="${i#*=}"
    shift # past argument=value
    ;;

    -t=*|--gputemp=*)
    targettemp="${i#*=}"
    shift # past argument=value
    ;;

    -mt=*|--mintemp=*)
    mintemp="${i#*=}"
    if (( $mintemp < $mintemp_default )); then
        mintemp=$mintemp_default
    fi
    shift # past argument=value
    ;;

    -Mt=*|--maxtemp=*)
    maxtemp="${i#*=}"
    shift # past argument=value
    ;;

    --default)
    DEFAULT=YES
    shift # past argument with no value
    ;;

    *)
    # unknown option
    echo -e "(EE) Error at '$i'. Invalid arguments. Please see available arguments below \n\n"
    usage;
    exit 1
    ;;
esac
done

# main method
set_requested_fans_speed

