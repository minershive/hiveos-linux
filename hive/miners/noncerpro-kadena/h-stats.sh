#!/usr/bin/env bash

#######################
# Functions
#######################

get_cards_hashes(){
  local t_hs=0
  local t_fan=0
  local t_temp=0
  local t_str=
  #get gpus hashes
  for (( i = 0; i < $GPU_COUNT_NVIDIA; i++ )); do
    #19-11-18 11:15:22  [^[[32minfo^[[39m] | GPU#0 214.65 MH/s
    t_str=`cat $log_name | tail -n 100 | grep "GPU#$i " | tail -1 | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"`
    if [[ ! -z $t_str ]]; then
      t_hs=`echo $t_str | cut -d " " -f 6`
      hs+="$t_hs "
    else
      hs+="0 "
    fi
  done
  #19-11-18 11:15:22  [^[[32minfo^[[39m] | Total Hashrate: 353.71 MH/s
  khs=`cat $log_name | tail -n 100 | grep " | Total Hashrate: " | tail -1 | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | awk '{ printf($7*1000) }'`
}

get_miner_uptime(){
  local a=0
  let a=`date +%s`-`stat --format='%Y' $1`
  echo $a
}

get_log_time_diff(){
  local a=0
  let a=`date +%s`-`stat --format='%Y' $log_name`
  echo $a
}

#######################
# MAIN script body
#######################

local log_name="/var/log/miner/noncerpro-kadena/noncerpro-kadena.log"
local ver=`miner_ver`

local conf_name="/run/hive/miners/$MINER_NAME/miner.conf"

khs=0
hs=''

local fan=$(jq -c "[.fan$nvidia_indexes_array]" <<< $gpu_stats)
local temp=$(jq -c "[.temp$nvidia_indexes_array]" <<< $gpu_stats)

[[ -z $GPU_COUNT_NVIDIA ]] && GPU_COUNT_NVIDIA=`gpu-detect NVIDIA`

# Calc log freshness
local diffTime=`get_log_time_diff`
local maxDelay=120

local algo="Blake2s_256"

# If log is fresh the calc miner stats or set to null if not
if [ "$diffTime" -lt "$maxDelay" ]; then
  get_cards_hashes
  local hs_units='mhs' # hashes utits
  local uptime=`get_miner_uptime $conf_name` # miner uptime
  local acc=`cat $log_name | grep -c "Submitted block"`
  local rej=0

# make JSON
  stats=$(jq -nc \
        --argjson hs "`echo ${hs[@]} | tr " " "\n" | jq -cs '.'`" \
        --arg hs_units "$hs_units" \
        --argjson temp "$temp" \
        --argjson fan "$fan" \
        --arg uptime "$uptime" \
        --arg algo "$algo" \
        --arg ver "$ver" \
        --arg acc "$acc" --arg rej "$rej"\
        '{$hs, $hs_units, $temp, $fan, $uptime, $algo, "ar": [$acc, $rej], $ver}')
else
  stats=""
  khs=0
fi

# debug output
#echo temp:  $l_temp
#echo fan:   $l_fan
#echo stats: $stats
#echo khs:   $khs
