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
# для регулирования амд установить переменную NO_AMD. если 0, то регулируем амд. проверка в функцию регулировки
				
#constant
MIN_COEF=80
MAX_COEF=110

#из конфига
MIN_FAN=40 
TARGET_TEMP=
CRITICAL_TEMP=75
NO_AMD=0

#включаем конфиг
[ ! -f $CONF_FILE ] && echo "No config $CONF_FILE" && exit 
. $CONF_FILE


MIN_TEMP=$(( TARGET_TEMP-5 ))
###########
echo -e " MIN_TEMP=$MIN_TEMP\n TARGET_TEMP=$TARGET_TEMP\n CRITICAL_TEMP=$CRITICAL_TEMP"

# TODO this block must be refactored to library functions
#gpu_detect_json=`gpu-detect listjson`
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
# TODO This must be refactored to lib-function
function echo2 {
	echo -e "$1" > /dev/tty1
	echo -e "$1" >> $AUTOFAN_LOG
    # TODO this line maybe getting troubles
    # look at get_fan_speed for example
    # echo -e "$1"
}


if [[ $nvidia_indexes_array == '[]' && $amd_indexes_array == '[]' ]]; then
    echo2 "No one ${RED}AMD${NOCOLOR} or ${GREEN}NVIDIA${NOCOLOR} cards found"
    exit 1
fi

#if (( $nvidia_cards_number > 0 )); then
#  echo2 "You have ${GREEN}NVIDIA${NOCOLOR} GPU's: $nvidia_cards_number"
#  nvidia-smi -pm 1 ######## имеет ли смысл, если работает в связке с nvidia-oc?
#  $NS -a GPUPowerMizerMode=1 # аналогично, что и выше
#fi 
#
[[ $nvidia_cards_number > 0 ]] && echo2 "You have ${GREEN}NVIDIA${NOCOLOR} GPU's: $nvidia_cards_number" && nvidia-smi -pm 1 && $NS -a GPUPowerMizerMode=1

#if (( $amd_cards_number > 0 )); then
#  echo2 "You have ${RED}AMD${NOCOLOR} GPU's: $amd_cards_number"
#fi 
#
[[ $amd_cards_number > 0 ]] && echo2 "You have ${RED}AMD${NOCOLOR} GPU's: $amd_cards_number" 

				# Default settings
				#mode_default="auto"
				#mode=$mode_default #for del?

				# Probably Nvidia and AMD will have different default settings
				#targettemp_default=65
				#targettemp=$targettemp_default
				#mintemp_default=10
				#mintemp=$mintemp_default
				#maxtemp_default=79
				#maxtemp=$maxtemp_default

				#fanpercent_default="80"
				#fanpercent=$fanpercent_default
				#fan_change_step_default="5"
				#fan_change_step=$fan_change_step_default
				


#usage ()
#{
#   echo "⚞ HIVE-GPU-AUTOFANS ⚟"
#    echo
#    echo "usage: $0 -m=(auto|constant) [-t=TEMP] [-mt=TEMP] [-Mt=TEMP] [-s=SPEED] [-c=STEP]"
#    echo
#    echo "Description:"
#    echo "  -m|--mode        coolers adjustment (default: $mode_default)"
#    echo "      auto            (recommended) automatic coolers adjustment. By default it holds ${targettemp_default}C but you may change this through '-t'"
#    echo "      constant         constant coolers speed. Set the value via '-s'"
#    echo
#    echo "  -t|--gputemp     target temperature (default: ${targettemp_default}℃)"
#    echo "      TEMP            integer value. Temperature in Celsius"
#    echo
#    echo "  -mt|--mintemp    minimal temperature (cannot be lower than $mintemp_default ℃)"
#    echo "      TEMP            integer value. Temperature in Celsius"
#    echo
#    echo "  -Mt|--maxtemp    maximal temperature when the miner will stopped (default: $maxtemp_default ℃)"
#    echo "      TEMP            integer value. Temperature in Celsius"
#    echo
#    echo "  -s|--fanspeed    fans speed (default: $fanpercent_default%)"
#    echo "      SPEED           integer value. Speed in percents"
#    echo
#    echo "  -c|--changestep  fans speed change step (default: $fan_change_step_default%)"
#    echo "      STEP           integer value. Speed in percents"
#    exit
#}

###
# Getting fan speed
# (required) temperature - current GPU chipset temperature
# (required) gpu_fan_speed - current card's fan speed in percents
#
# Result:
# The speed of fan in percents


get_fan_speed () {
    local temperature=$1
    local temperature_previous=$2
    local gpu_fan_speed=$3
    local gpu_bus_id=$4
    local gpu_card_name=$5 
#    local target_fan_speed=$fanpercent_default
#
#    if (( $temperature < $targettemp - 2 )); then
#        # no reasons to change fan speed
#
#        target_fan_speed=$gpu_fan_speed
#    else
#        # this action is going in a period from ($targettemp - 2) to ($targettemp + 2)
#        if (( $temperature >= $targettemp - 2 && $temperature <= $targettemp + 2 )); then
#            target_fan_speed=$(( $gpu_fan_speed + $fan_change_step ))
#            echo2 "GPU[$gpu_bus_id]'s temperature(~ $temperature ℃) nearby target temperature ($targettemp ℃). Fan speed raised to $target_fan_speed%"
#        else
#            if (( $temperature > $targettemp + 2 )); then
#                target_fan_speed=$(( $gpu_fan_speed + 2 * $fan_change_step ))
#                echo2 "GPU[$gpu_bus_id]'s temperature(~ $temperature ℃) greater than target temperature($targettemp ℃). Fan speed raised to $target_fan_speed%"
#            fi
#        fi
#        if (( $temperature > $maxtemp )); then
#            target_fan_speed=$(( $gpu_fan_speed + 3 * $fan_change_step ))
#            echo2 "GPU[$gpu_bus_id]'s temperature(~ $temperature ℃) greater than maximum temperature($maxtemp ℃). Fan speed raised to $target_fan_speed%"
#        fi
#    fi
#    if (($target_fan_speed > 100)); then
#        target_fan_speed=100
#        echo2 "${RED}GPU[$gpu_card_name, $gpu_bus_id]'s fan speed now $target_fan_speed%${NOCOLOR}"
#    fi
#    if (( $temperature < $temperature_previous )); then 
#        target_fan_speed=$(( $gpu_fan_speed - $fan_change_step/2 ))
#        echo2 "GPU[$gpu_bus_id]'s temperature(~ $temperature) less than previous value ($temperature_previous). Fan speed decreased to $target_fan_speed%"
#    fi

	#ниже диапазона
	if [[ $temperature -lt $MIN_TEMP ]]; then
	##проверка условия майнер-старт в функции event_by_temperature
	#снижение коэффициентов (ввести функцию event_by_temp_limit)
	 [[ CHANGE_COEF_FLAG != 1 ]] && CHANGE_COEF_FLAG=0 #DOWN. не снижается, если одна из карт достигла макс температуры.
	 target_fan_speed=$(($temperature * ($MIN_COEF-($MIN_TEMP - $temperature) * 2)/100))
	#лимит вентиляторов
	[[ $target_fan_speed -le $MIN_FAN ]] && target_fan_speed=$MIN_FAN
	echo2 "GPU[$gpu_bus_id]'s temperature(~ $temperature ℃). Fan speed raised to $target_fan_speed%"
	
	#
	#в диапазоне
	elif [[ $temperature -ge $MIN_TEMP  &&  $temperature -le $TARGET_TEMP ]]; then
		target_fan_speed=$((  $temperature *(($temperature - $MIN_TEMP) * 4 + $MIN_COEF)/100 ))
	#				если темп снизилась на градус, снижаем кулер на 1%
					if [[ -n $temperature_previous && $(( $temperature+1 )) -eq $temperature_previous && $TARGET_TEMP -ge $temperature_previous ]]; then
								target_fan_speed=$(( $gpu_fan_speed-1 )) 
								echo2 "GPU[$gpu_bus_id]'s temperature(~ $temperature ℃). Fan speed raised to $target_fan_speed%"
								
	#				иначе, если не изменилась - кулер без измененний
					elif [[ -n $temperature_previous && $temperature -eq $temperature_previous ]]; then
							target_fan_speed=$gpu_fan_speed
							echo2 "GPU[$gpu_bus_id]'s temperature(~ $temperature ℃). Fan speed still $target_fan_speed%"
							
					fi	
	#
	#выше диапазона
	elif [[ $temperature -gt $TARGET_TEMP ]]; then
	#проверка условия майнер-стоп в функции event_by_temperature()
	#увеличение коэффициентов (event_by_temp_limit)
	 CHANGE_COEF_FLAG=1	#UP
	 target_fan_speed=$(( $temperature *(($temperature - $TARGET_TEMP) * 4 + $MAX_COEF)/100 ))
	echo2 "GPU[$gpu_bus_id]'s temperature(~ $temperature ℃). Fan speed raised to $target_fan_speed%"
	
	fi
	 [[ $target_fan_speed -gt 100 ]] && target_fan_speed=100 && echo2 "${RED}GPU[$gpu_card_name, $gpu_bus_id]'s fan speed now $target_fan_speed%${NOCOLOR}"
    echo $target_fan_speed
}

###
# What we must to do if temperature reached some limits
event_by_temperature() {
    #local temperature=$1
    #AUTOFAN_MINER="miner-start" 
	
	# все ли карты остыли? 
	# цикл проверки 
	if [[ ! `screen -ls | grep "miner"` ]]; then   #если майнер не запущен
								local gpu_temp_all
								for gpu_temp_all in ${temperatures_array[@]} #берем температуру каждой карты из массива
								do 
									if [[ $gpu_temp_all > $MIN_TEMP ]]; then  #и проверяем остыла до нижнего предела или нет
											AUTOFAN_MINER=$AUTOFAN_MINER && break #если какая то карта не остыла - выходим из проверки с сохранением переменной
    								else AUTOFAN_MINER="miner-start" #если остыли все, запускаем майнер
									fi
								done
	fi
	# 
    #if (( $temperature >= $maxtemp )); then
    #    AUTOFAN_MINER="miner-stop"
    #fi
	
	#new code
	 [[ $1 -ge $CRITICAL_TEMP ]] && AUTOFAN_MINER="miner-stop" 
	# 
}

event_by_temp_limit () {
if [[ $CHANGE_COEF_FLAG==0 ]]; then
        [[ `screen -ls miner | grep "miner"` ]] && [[  $MIN_COEF > 70 ]] && MIN_COEF=$(( $MIN_COEF-1 )) && MAX_COEF=$(( $MAX_COEF-1 )) && 
						echo2 "MIN_COEF raised to $MIN_COEF. MAX_COEF raised to $MAX_COEF."
else [[  $MIN_COEF -lt 90 ]] && MIN_COEF=$(( $MIN_COEF+2 )) && MAX_COEF=$(( $MAX_COEF+2 )) && echo2 "MIN_COEF raised to $MIN_COEF. MAX_COEF raised to $MAX_COEF."
fi
CHANGE_COEF_FLAG=
}


action_by_event() {
	. $RIG_CONF
    case $AUTOFAN_MINER in
        "miner-start")
        #local miners_started=`screen -ls | grep miner | wc -l`
        #if (( $miners_started <1 )); then 
        #    miner start
			
        #fi
		#new code
		#
		 [[ ! `screen -ls | grep "miner"` ]] && miner start && echo2 "Miner started."
		 [[ $WD_ENABLED==1 ]] && wd start
        ;;

        "miner-stop")
         [[ `screen -ls | grep "miner"` ]] && miner stop && wd stop && echo2 "Miner stopped."
		#disable watchdog too иначе запустит майнер
		
        ;;
    esac
	#обнуляем значение после выполнения условия
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
#        echo -e "GPU:$index T=$gpu_temperature FAN=$gpu_fan_speed%"
        local TARGET_FAN_SPEED=$(get_fan_speed $gpu_temperature $gpu_temperature_previous $gpu_fan_speed $card_bus_id $card_name)
        args+=" -a [gpu:$index]/GPUFanControlState=1 -a [fan-$index]/GPUTargetFanSpeed=$TARGET_FAN_SPEED"
    done
    $NS $args > /dev/null 2>&1
    action_by_event

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
#        echo -e "GPU:$index Card name:$card_name Bus ID: $card_bus_id T=$gpu_temperature FAN=$gpu_fan_speed%"
        local TARGET_FAN_SPEED=$(get_fan_speed $gpu_temperature $gpu_temperature_previous $gpu_fan_speed $card_bus_id $card_name)
        wolfamdctrl -i $index --set-fanspeed $TARGET_FAN_SPEED 1>/dev/null
    done
    action_by_event

}

auto_fan_control() {

	while true;	do
	. $CONF_FILE
	echo2 "$(date +"%d/%m/%y %T")"
		if [[ -n $TARGET_TEMP ]]; then ## проверить есть ли настройки в конфиге, иначе спать
			#declare -a temperatures_array=(`cat $HIVE_GPU_STATS_LOG | tail -1 | jq -r ".params.temp | .[]"`)
			#declare -a fans_array=(`cat $HIVE_GPU_STATS_LOG | tail -1 | jq -r ".params.fan | .[]"`)
			declare -a temperatures_array=(`cat $HIVE_GPU_STATS_LOG | tail -1 | jq -r ".temp | .[]"`)
			declare -a fans_array=(`cat $HIVE_GPU_STATS_LOG | tail -1 | jq -r ".fan | .[]"`)
			if (( $nvidia_cards_number > 0 )); then
			
				nvidia_auto_fan_control
			fi
			if [[ $amd_cards_number > 0 && $NO_AMD == 0 ]]; then #добавлено условие, если NO_AMD
				amd_auto_fan_control
			fi
			declare -a temperatures_array_previous=(${temperatures_array[@]})
			#added
			event_by_temp_limit
		fi
	sleep 30 #10 мало чтобы видеть эффект
	done

}

#set_constant_fan_speeds ()
#{
#функцию упразднить?
#за запуск фиксированных оборотов пусть отвечает nvidia-oc amd-oc-safe
#при изменении настроек ОС пользователем в админке агент применит настройки и автофану ничего не нужно делать
#    if (( $nvidia_cards_number > 0 )); then
#        args=
#        for index in ${nvidia_indexes_array[@]}
#        do
#            args+=" -a [gpu:$index]/GPUFanControlState=1 -a [fan-$index]/GPUTargetFanSpeed=$fanpercent"
#        done
#        $NS $args > /dev/null 2>&1
#    fi
#    if (( $amd_cards_number > 0 )); then
#        for index in ${amd_indexes_array[@]}
#        do
#            wolfamdctrl -i $index --set-fanspeed $fanpercent 1>/dev/null
#        done
#    fi
#}

#set_requested_fans_speed ()
#{
# см. коммент set_constant_fan_speeds
#    echo2 "----- Autofan started -----\n"
#    case $mode in
#        "constant") set_constant_fan_speeds ;;
#        "auto") auto_fan_control ;;
#    esac
#
#}

# Arguments parsing and validating
#if [[ -z "$1" ]]; then
#    echo -e "(EE) Error: invalid arguments. Please see available arguments below \n\n"
#    usage;
#    exit 1;
#fi

# TODO refactor this to function
#for i in "$@"
#do
#case $i in
#    -m=*|--mode=*)
#    mode="${i#*=}"
#    if [[ "auto" != $mode && "constant" != $mode ]]; then
#        echo -e "(EE) The value '$mode' is invalid. Please see available arguments and values below \n\n"
#        usage;
#        exit 1
#    fi
#    shift # past argument=value
#    ;;#
#
#    -s=*|--fanspeed=*)
#    fanpercent="${i#*=}"
#    shift # past argument=value
#    ;;
#
#    -c=*|--changestep=*)
#    fan_change_step="${i#*=}"
#    shift # past argument=value
#    ;;
#
#    -t=*|--gputemp=*)
#    targettemp="${i#*=}"
#    shift # past argument=value
#    ;;
#
#    -mt=*|--mintemp=*)
#    mintemp="${i#*=}"
#    if (( $mintemp < $mintemp_default )); then
#        mintemp=$mintemp_default
#    fi
#    shift # past argument=value
#    ;;
#
#    -Mt=*|--maxtemp=*)
#    maxtemp="${i#*=}"
#    shift # past argument=value
#    ;;
#
#    --default)
#    DEFAULT=YES
#    shift # past argument with no value
#    ;;
#
#    *)
#    # unknown option
#    echo -e "(EE) Error at '$i'. Invalid arguments. Please see available arguments below \n\n"
#    usage;
#    exit 1
#    ;;
#esac
#done

# main method
#set_requested_fans_speed
auto_fan_control
