#!/usr/bin/env bash

#######################
# Functions
#######################


get_cards_hashes(){
  local all_bus_num_array=(`echo "$gpu_detect_json" | jq -r '[ . | to_entries[] | select(.value) | .value.busid [0:2] ] | .[]'`)
  local t_temp=$(jq '.temp' <<< $gpu_stats)
  local t_fan=$(jq '.fan' <<< $gpu_stats)
  a_fan=
  a_temp=
  local failed_gpus=
  for (( i=0; i < `echo $slots | jq length`; i++ )); do
    local slot_id=`echo $slots | jq -r '.['$i'].id'`
    if [[ `echo $slots | jq -r '.['$i'].status'` != "RUNNING" ]]; then
      failed_gpus+=`echo $slots | jq -r '.['$i'].description' | cut -f 2 -d ":"`" "
      ppd=0
    else
      ppd=`echo $queue | jq -r 'to_entries[] | select(.value.slot=="'$slot_id'") | .value.ppd'`
    fi
    t_ac=`echo $queue | jq -r 'to_entries[] | select(.value.slot=="'$slot_id'") | .value.framesdone'`
    [[ -z $t_ac || $t_ac == "null" || $t_ac == "" ]] && t_ac=0

    if [[ `echo $slots | jq -r '.['$i'].description' | cut -f 1 -d ":"` == "gpu" ]]; then
      local gpu_num=`echo $slots | jq -r '.['$i'].description' | cut -f 2 -d ":"`

      local bus_num=`echo $fah_info | jq -c 'to_entries[].value' | grep '"OpenCL Device '$gpu_num'"' | cut -f 2 -d "," | cut -f 3 -d " " | cut -f 2 -d ":"`

      for ((k = 0; k < ${#all_bus_num_array[@]}; k++)); do
        if [[ "$(( 0x${all_bus_num_array[$k]} ))" -eq "$bus_num" ]]; then
          a_fan+=$(jq -r .[$k] <<< $t_fan)" "
          a_temp+=$(jq -r .[$k] <<< $t_temp)" "
          break
        fi
      done
    else
      bus_num=null
      a_fan+="0 "
      a_temp+=`cpu-temp`" "
    fi

    local s_pps=0
    for t_ppd in $ppd; do
      s_pps=`echo "$s_pps + $t_ppd" | bc`
    done
    s_pps=`echo $s_pps | awk '{print $1/86400}'`
    hs+="$s_pps "
    bus_numbers+="$bus_num "
    ac=`echo "$ac + $t_ac" | bc`
    khs=`echo "$khs + $s_pps" | bc`
  done

  [[ ! -z $failed_gpus ]] && echo " Failed GPU(s) #: $failed_gpus" | tee /var/log/failed_gpus

  khs=`echo $khs | awk '{print $1/1000}'`
}

get_miner_uptime(){
  local a=0
  let a=`date +%s`-`stat --format='%Y' $conf_name`
  echo $a
}

get_log_time_diff(){
  local a=0
  let a=`date +%s`-`stat --format='%Y' $log_name`
  echo $a
}

get_stats_json(){
  if [[ $uptime -lt 60 || ! -f $info_name ]]; then
    echo 'info' | nc -w $API_TIMEOUT localhost ${MINER_API_PORT} | tail -n +4 | head -n -2 | jq '.[2]' > $info_name
  else
    [[ -f $info_name && $(stat -c%s "$info_name") -eq 0 ]] && echo 'info' | nc -w $API_TIMEOUT localhost ${MINER_API_PORT} | tail -n +4 | head -n -2 | jq '.[2]' > $info_name
  fi

  slots=`echo 'slot-info' | nc -w $API_TIMEOUT localhost ${MINER_API_PORT} | tail -n +4 | head -n -2 | sed 's/False/"False"/' | sed 's/True/"True/'`
  queue=`echo 'queue-info' | nc -w $API_TIMEOUT localhost ${MINER_API_PORT} | tail -n +4 | head -n -2`
  fah_info=`cat $info_name`
}

#######################
# MAIN script body
#######################

local ver=`miner_ver`
local log_name="$MINER_LOG_BASENAME.log"
local conf_name="${MINER_DIR}/$ver/config.xml"
local slot_name="/tmp/fah_slot_info"
local info_name="/tmp/fah_info"
local queue_name="/tmp/fah_queue"

khs=0
hs=""
bus_numbers=""
ac=0

# Calc log freshness
local diffTime=$(get_log_time_diff)
local maxDelay=320

# If log is fresh the calc miner stats or set to null if not
if [ "$diffTime" -lt "$maxDelay" ]; then
  uptime=$(get_miner_uptime) # miner uptime
  get_stats_json $uptime
  get_cards_hashes # hashes array
  local hs_units='hs' # hashes utits

# make JSON
  stats=$(jq -nc \
        --argjson hs "`echo ${hs[@]} | tr " " "\n" | jq -cs '.'`" \
        --arg hs_units "$hs_units" \
        --argjson temp "`echo ${a_temp[@]} | tr " " "\n" | jq -cs '.'`" \
        --argjson fan "`echo ${a_fan[@]} | tr " " "\n" | jq -cs '.'`" \
        --arg ver "$ver" \
        --argjson bus_numbers "`echo ${bus_numbers[@]} | tr " " "\n" | jq -cs '.'`" \
        --arg ac "$ac" --arg rj "0" \
        --arg algo "antidote" \
        '{$hs, $hs_units, $bus_numbers, $temp, $fan, uptime: '$uptime', ar:[ $ac, $rj], $ver, $algo}')
else
  stats=""
  khs=0
fi

# debug output
#echo hs:  $hs
#echo temp:  $temp
#echo fan:   $fan
#echo stats: $stats
#echo khs:   $khs
#echo uptime: $uptime
