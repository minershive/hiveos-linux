#!/usr/bin/env bash
source /etc/environment

export DISPLAY=":0"

NS='/usr/bin/nvidia-settings'

# TODO remove this after debugging

amd_indexes_array=`echo "$HIVE_GPU_DETECT_JSON" | jq -c '[ . | to_entries[] | select(.value.brand == "amd") | .key ]'`
nvidia_indexes_array=`echo "$HIVE_GPU_DETECT_JSON" | jq -c '[ . | to_entries[] | select(.value.brand == "nvidia") | .key ]'`
cpu_indexes_array=`echo "$HIVE_GPU_DETECT_JSON" | jq -c '[ . | to_entries[] | select(.value.brand == "cpu") | .key ]'`

# TODO get this from $HIVE_GPU_STATS
echo $nvidia_indexes_array
echo $amd_indexes_array
echo $cpu_indexes_array
# TODO parse it from variables above
NUM_NVIDIA_CARDS=`nvidia-smi -L | wc -l`
NUM_AMD_CARDS=`nvidia-smi -L | wc -l`

if [[ $nvidia_indexes_array == '[]' && $amd_indexes_array == '[]' ]]; then
    echo -e "No ${RED}AMD${NOCOLOR} or ${GREEN}NVIDIA${NOCOLOR} found"
    exit 1
fi

if (( $NUM_NVIDIA_CARDS > 0 )); then
  echo "You have $NUM_NVIDIA_CARDS Nvidia GPU's"
fi
if (( $NUM_AMD_CARDS > 0 )); then
  echo "You have $NUM_AMD_CARDS AMD GPU's"
fi

exit 1
nvidia-smi -pm 1
$NS -a GPUPowerMizerMode=1

# Default settings
mode="auto"
targettemp="60"
fanpercent="80"


usage ()
{
    echo "⚞ HIVE-GPU-AUTOFANS ⚟"
    echo
    echo "usage: $0 -m (auto|constant) [-t] [-s]"
    echo
    echo "Description:"
    echo "  -m   coolers adjustment: auto, constant"
    echo "     auto        (recommended) automatic coolers adjustment. By default it holds 65C but you may change this through '-t'"
    echo "     constant    constant coolers speed. Set the value via '-s'"
    echo
    echo "  -t   target temperature"
    echo "  -m   minimal temperature (cannot be lower than 10%)"
    echo "  -M   maximal temperature when the miner will stopped"
    echo
    echo "  -s   fans speed. Default value: 80%"
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

<-----
for i in "$@"
do
case $i in
    -m=*|--mode=*)
    MODE="${i#*=}"
    shift # past argument=value
    ;;
    -s=*|--fanspeed=*)
    FANSPEED="${i#*=}"
    shift # past argument=value
    ;;
    -t=*|--gputemp=*)
    GPUTEMP="${i#*=}"
    shift # past argument=value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument with no value
    ;;
    *)
          # unknown option
    ;;
esac
done
if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 $1
fi
----->

if [[ -z "$1" ]]; then
    echo "(EE) Error: invalid arguments"
    echo
    usage;
    exit 1;
fi

while [ -n "$1" ]; do
	case $1 in
	 	-m) mode="$2"; shift ;;
		-s) fanpercent=$2; break ;;
		-t) targettemp=$2; break ;;
		*) usage; exit 1 ;;
	esac
	shift
done

# main method
set_requested_fans_speed

exit;