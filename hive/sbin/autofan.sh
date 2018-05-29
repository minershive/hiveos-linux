#!/usr/bin/env bash
source /etc/environment
. colors

export DISPLAY=":0"

NS='/usr/bin/nvidia-settings'

# TODO this block must be refactored to library functions

amd_indexes_query='[ . | to_entries[] | select(.value.brand == "amd") | .key ]'
amd_indexes_array=`echo "$HIVE_GPU_DETECT_JSON" | jq -c "$amd_indexes_query"`
amd_cards_number=`echo "$HIVE_GPU_DETECT_JSON" | jq -c "$amd_indexes_query | length"`

nvidia_indexes_query='[ . | to_entries[] | select(.value.brand == "nvidia") | .key ]'
nvidia_indexes_array=`echo "$HIVE_GPU_DETECT_JSON" | jq -c "$nvidia_indexes_query"`
nvidia_cards_number=`echo "$HIVE_GPU_DETECT_JSON" | jq -c "$nvidia_indexes_query | length"`

cpu_indexes_query='[ . | to_entries[] | select(.value.brand == "cpu") | .key ]'
cpu_indexes_array=`echo "$HIVE_GPU_DETECT_JSON" | jq -c "$cpu_indexes_query"`
cpu_cores_number=`echo "$HIVE_GPU_DETECT_JSON" | jq -c "$cpu_indexes_query | length"`

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

targettemp_default="60"
targettemp=$targettemp_default

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
    echo "  -m             minimal temperature (cannot be lower than 10%)"
    echo "  -M             maximal temperature when the miner will stopped"
    echo
    echo "  -s|--fanspeed  fans speed (default: $fanpercent_default%)"
    echo "      SPEED           integer value. Speed in percents"
    exit
}


# TODO get list from `gpu-detect`
nvidia_auto_fan_control ()
{
    for ((i=0; i<$NUM_NVIDIA_CARDS;i++))
    {
        GPU_TEMP=`nvidia-smi -i $i --query-gpu=temperature.gpu --format=csv,noheader`
        FAN_SPEED=`nvidia-smi -i $i --query-gpu=fan.speed --format=csv,noheader,nounits`
        if (($GPU_TEMP < (( $targettemp - 10)) )); then
            let "TARGET_FAN_SPEED = GPU_TEMP"
            (($GPU_TEMP!=$FAN_SPEED)) && $NS -a [gpu:$i]/GPUFanControlState=1 -a [fan-$i]/GPUTargetFanSpeed=$TARGET_FAN_SPEED > /dev/null 2>&1
        else
            if (($GPU_TEMP < $targettemp)); then
                let "TARGET_FAN_SPEED = GPU_TEMP + 10"
                (($TARGET_FAN_SPEED != $FAN_SPEED)) && $NS -a [gpu:$i]/GPUFanControlState=1 -a [fan-$i]/GPUTargetFanSpeed=$TARGET_FAN_SPEED > /dev/null 2>&1
            else
                let "TARGET_FAN_SPEED = GPU_TEMP + 30"
                if (($TARGET_FAN_SPEED > 100)); then
                    TARGET_FAN_SPEED=100
                fi
                (($TARGET_FAN_SPEED != $FAN_SPEED)) && $NS -a [gpu:$i]/GPUFanControlState=1 -a [fan-$i]/GPUTargetFanSpeed=$TARGET_FAN_SPEED > /dev/null 2>&1
            fi
        fi
        echo "GPU:$i T=$GPU_TEMP FAN=$TARGET_FAN_SPEED%"
    }
}

# TODO get list from `gpu-detect`
amd_auto_fan_control ()
{
    for ((i=0; i<$NUM_AMD_CARDS;i++))
    {
        # TODO set speed from wolfamdctrl (look at the gpu-fans-find)
        echo "GPU:$i T=$GPU_TEMP FAN=$TARGET_FAN_SPEED%"
    }
}

auto_fan_control() {
	while true;	do
        nvidia_auto_fan_control;
        amd_auto_fan_control;
		sleep 10
	done
}

set_constant_fan_speeds ()
{
	for ((i=0; i<$NUM_CARDS;i++))
	{
		# TODO split by videocard vendors
		$NS -a [gpu:$i]/GPUFanControlState=1 -a [fan-$i]/GPUTargetFanSpeed=$fanpercent > /dev/null 2>&1
		echo "GPU:$i FAN=$fanpercent%"
	}
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
echo -e "[DEBUG] i = $i\n"
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

exit;