#!/usr/bin/env bash
source /etc/environment
. colors

gpu_detect_json=`cat /run/hive/gpu-detect.json`
HIVE_GPU_STATS_LOG="/run/hive/gpu-stats.json"

export DISPLAY=":0"

NS='/usr/bin/nvidia-settings'
AUTOFAN_LOG="/var/log/hive-autofan.log"

#пути к файлам конфигурации
RIG_CONF="/hive-config/rig.conf"
CONF_FILE="/hive-config/autofan.conf"

MIN_COEF=80
MAX_COEF=110
MIN_FAN=40
TARGET_TEMP=
CRITICAL_TEMP=75
NO_AMD=0
#CHANGE_COEF_FLAG=


[ ! -f $CONF_FILE ] && echo -e "${RED}No config $CONF_FILE${NOCOLOR}" && exit
. $CONF_FILE

MIN_TEMP=$(( TARGET_TEMP-5 ))

# TODO this block must be refactored to library functions
amd_indexes_query='[ . | to_entries[] | select(.value.brand == "amd") | .key ]'
amd_indexes_array=`echo "$gpu_detect_json" | jq -r "$amd_indexes_query | .[]"`
amd_cards_number=`echo "$gpu_detect_json" | jq -c "$amd_indexes_query | length"`

nvidia_indexes_query='[ . | to_entries[] | select(.value.brand == "nvidia") | .key ]'
nvidia_indexes_array=`echo "$gpu_detect_json" | jq -r "$nvidia_indexes_query| .[]"`
nvidia_cards_number=`echo "$gpu_detect_json" | jq -c "$nvidia_indexes_query | length"`

# TODO cpus maybe required to use autofans too
#cpu_indexes_query='[ . | to_entries[] | select(.value.brand == "cpu") | .key ]'
#cpu_indexes_array=`echo "$gpu_detect_json" | jq -r "$cpu_indexes_query"`
#cpu_cores_number=`echo "$gpu_detect_json" | jq -c "$cpu_indexes_query | length"`

declare -a card_bus_ids_array=(`echo "$gpu_detect_json" | jq -r '[ . | to_entries[] | select(.value) | .value.busid ] | .[]'`)
# TODO There is must be the way to remove space or use the whole value inside the quotes
#declare -a card_names_array=(`echo "$gpu_detect_json" | jq '[ . | to_entries[] | select(.value) | .value.name ] | .[]'`)

###
# Log write
function echo2 {
	echo -e "$1" > /dev/tty1
	echo -e "$1" >> $AUTOFAN_LOG
    echo -e "$1"
}

check_gpu () {

if [[ $nvidia_indexes_array == '[]' && $amd_indexes_array == '[]' ]]; then
    echo2 "No one ${RED}AMD${NOCOLOR} or ${GREEN}NVIDIA${NOCOLOR} cards found"
    exit 1
fi
[[ $nvidia_cards_number > 0 ]] && echo2 "You have ${GREEN}NVIDIA${NOCOLOR} GPU's: $nvidia_cards_number" && nvidia-smi -pm 1 > /dev/null 2>&1 && $NS -a GPUPowerMizerMode=1 > /dev/null 2>&1
[[ $amd_cards_number > 0 ]] && echo2 "You have ${RED}AMD${NOCOLOR} GPU's: $amd_cards_number" 
echo2 "AUTOFAN CURRENT SETTINGS:\n  MIN_TEMP=$MIN_TEMP\n  TARGET_TEMP=$TARGET_TEMP\n  CRITICAL_TEMP=$CRITICAL_TEMP"

}

get_fan_speed () {
    local temperature=$1
    local temperature_previous=$2
    local gpu_fan_speed=$3
    local gpu_bus_id=$4
    local gpu_card_name=$5 

	if [[ $temperature -lt $MIN_TEMP ]]; then
	 [[ $CHANGE_COEF_FLAG -ne 1 ]] && CHANGE_COEF_FLAG=0
	 target_fan_speed=$(($temperature * ($MIN_COEF-($MIN_TEMP - $temperature) * 2)/100))
	[[ $target_fan_speed -le $MIN_FAN ]] && target_fan_speed=$MIN_FAN
	echo2 "${BLUE}GPU[$gpu_bus_id]: $temperature°C -> Fan speed was set to $target_fan_speed%${NOCOLOR}"

	elif [[ $temperature -ge $MIN_TEMP  &&  $temperature -le $TARGET_TEMP ]]; then
		target_fan_speed=$((  $temperature *(($temperature - $MIN_TEMP) * 4 + $MIN_COEF)/100 ))
					if [[ -n $temperature_previous && $(( $temperature+1 )) -eq $temperature_previous && $TARGET_TEMP -ge $temperature_previous ]]; then
								target_fan_speed=$(( $gpu_fan_speed-1 )) 
					elif [[ -n $temperature_previous && $temperature -eq $temperature_previous ]]; then
							target_fan_speed=$gpu_fan_speed
					fi	
		echo2 "GPU[$gpu_bus_id]: $temperature°C -> Fan speed was set to $target_fan_speed%"

	elif [[ $temperature -gt $TARGET_TEMP ]]; then
	 CHANGE_COEF_FLAG=1	
	 target_fan_speed=$(( $temperature *(($temperature - $TARGET_TEMP) * 4 + $MAX_COEF)/100 ))
	 echo2 "${RED}GPU[$gpu_bus_id]: $temperature°C -> Fan speed was set to $target_fan_speed%${NOCOLOR}"
		
	fi
	 [[ $target_fan_speed -gt 100 ]] && target_fan_speed=100  && echo2 "${RED}GPU[$gpu_card_name, $gpu_bus_id]: WARNING: Maximum fan speed!${NOCOLOR}"
    #echo $target_fan_speed
}

###
# What we must to do if temperature reached some limits
event_by_temperature() {

	if [[ ! `screen -ls | grep "miner"` ]]; then  
								local gpu_temp_all
								for gpu_temp_all in ${temperatures_array[@]}
								do 
									if [[ $gpu_temp_all > $MIN_TEMP ]]; then 
											AUTOFAN_MINER=$AUTOFAN_MINER && break
    								else AUTOFAN_MINER="miner-start"
									fi
								done
	fi
	 [[ $1 -ge $CRITICAL_TEMP ]] && AUTOFAN_MINER="miner-stop" 
}

event_by_temp_limit () {

if [[ $CHANGE_COEF_FLAG == 0  ]]; then
        if [[ `screen -ls | grep "miner"` ]]; then
			if [[  $MIN_COEF > 70 ]]; then
				MIN_COEF=$(( $MIN_COEF-1 )) 
				MAX_COEF=$(( $MAX_COEF-1 ))
				echo2 "${CYAN}  MIN_COEF was set to $MIN_COEF\n  MAX_COEF was set to $MAX_COEF${NOCOLOR}"
			fi
		fi
elif [[ $CHANGE_COEF_FLAG == 1 ]]; then
 [[  $MIN_COEF -lt 90 ]] && MIN_COEF=$(( $MIN_COEF+2 )) && MAX_COEF=$(( $MAX_COEF+2 )) && echo2 "${CYAN}  MIN_COEF was set to $MIN_COEF\n  MAX_COEF was set to $MAX_COEF${NOCOLOR}"
fi
CHANGE_COEF_FLAG=
}


action_by_event() {
	. $RIG_CONF
    case $AUTOFAN_MINER in
        "miner-start")
		 [[ ! `screen -ls | grep "miner"` ]] && miner start && echo2 "${GREEN}Miner started ${NOCOLOR}"
		 [[ $WD_ENABLED==1 ]] && wd start
        ;;
        "miner-stop")
         [[ `screen -ls | grep "miner"` ]] && miner stop && wd stop && echo2 "${RED}Miner stopped ${NOCOLOR}"
        ;;
    esac
	AUTOFAN_MINER=
}


# TODO merge with amd_auto_fan_control
nvidia_auto_fan_control ()
{
    args=
    for index in ${nvidia_indexes_array[@]}
    do
        # TODO Theese fields maybe moved inside `get_fan_speed` replaced by on nvidia_indexes_array[@] as argument
        local gpu_temperature=${temperatures_array[index]}
        local gpu_temperature_previous=${temperatures_array_previous[index]}
        if [[ -z $gpu_temperature_previous ]]; then gpu_temperature_previous=0; fi
        local gpu_fan_speed=${fans_array[index]}
        # TODO broken, spaces trouble
#        local card_name=${card_names_array[index]}
        local card_name=    
        local card_bus_id=${card_bus_ids_array[index]}
        event_by_temperature $gpu_temperature
        #echo -e "GPU:$index T=$gpu_temperature FAN=$gpu_fan_speed%"
        #local TARGET_FAN_SPEED=$(get_fan_speed $gpu_temperature $gpu_temperature_previous $gpu_fan_speed $card_bus_id $card_name)
		get_fan_speed $gpu_temperature $gpu_temperature_previous $gpu_fan_speed $card_bus_id $card_name
        #args+=" -a [gpu:$index]/GPUFanControlState=1 -a [fan-$index]/GPUTargetFanSpeed=$TARGET_FAN_SPEED"
		args+=" -a [gpu:$index]/GPUFanControlState=1 -a [fan:$index]/GPUTargetFanSpeed=$target_fan_speed"
    done
    $NS $args > /dev/null 2>&1
    #action_by_event
}

amd_auto_fan_control ()
{
    for index in ${amd_indexes_array[@]}
    do
        # TODO Theese fields maybe moved inside `get_fan_speed` replaced by on amd_indexes_array[@] as argument
        local gpu_temperature=${temperatures_array[index]}
        local gpu_temperature_previous=${temperatures_array_previous[index]}
        if [[ -z $gpu_temperature_previous ]]; then gpu_temperature_previous=0; fi
        local gpu_fan_speed=${fans_array[index]}
        # TODO broken, spaces trouble
#        local card_name=${card_names_array[index]}
        local card_name=
        local card_bus_id=${card_bus_ids_array[index]}
        event_by_temperature $gpu_temperature
        #echo -e "GPU:$index Card name:$card_name Bus ID: $card_bus_id T=$gpu_temperature FAN=$gpu_fan_speed%"
        #local TARGET_FAN_SPEED=$(get_fan_speed $gpu_temperature $gpu_temperature_previous $gpu_fan_speed $card_bus_id $card_name)
		get_fan_speed $gpu_temperature $gpu_temperature_previous $gpu_fan_speed $card_bus_id $card_name
        #wolfamdctrl -i $index --set-fanspeed $TARGET_FAN_SPEED 1>/dev/null
		wolfamdctrl -i $index --set-fanspeed $target_fan_speed 1>/dev/null
    done
    #action_by_event
}

auto_fan_control() {

	while true;	do
	. $CONF_FILE
	MIN_TEMP=$(( TARGET_TEMP-5 ))
	echo2 "${GREEN}$(date +"%d/%m/%y %T")${NOCOLOR}"
		if [[ -n $TARGET_TEMP ]]; then 
			declare -a temperatures_array=(`cat $HIVE_GPU_STATS_LOG | tail -1 | jq -r ".temp | .[]"`)
			declare -a fans_array=(`cat $HIVE_GPU_STATS_LOG | tail -1 | jq -r ".fan | .[]"`)
			if (( $nvidia_cards_number > 0 )); then
				nvidia_auto_fan_control
			fi
			if [[ $amd_cards_number > 0 && $NO_AMD == 0 ]]; then #добавлено условие, если NO_AMD
				amd_auto_fan_control
			fi
			declare -a temperatures_array_previous=(${temperatures_array[@]})
			action_by_event
			event_by_temp_limit
		fi
	sleep 30 
	done
}

check_gpu && auto_fan_control

#screen -dmS fancontrol autofan.sh
#screen -x -S fancontrol

########################################
#   With best regards, Steambot33 :)   #
########################################

