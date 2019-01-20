#!/usr/bin/env bash

#######################
# Functions
#######################

get_cards_hashes(){
#Jan 07 13:01:38.090 DEBG Mining: Plugin 0 - Device 0 (GeForce GTX 1080 Ti) at Cuck(at)oo29 - Status: OK : Last Graph time: 0.206706559s; Graphs per second: 4.838 - Total Attempts: 760
  hs=''; local t_hs=0
  local i=0
  for (( i=0; i < ${GPU_COUNT}; i++ )); do
    t_hs=`cat $log_name | tail -n 50 | grep "DEBG Mining:" | grep "Device $i" | tail -n 1`
    t_hs=`echo ${t_hs#*" Graphs per second: "} | cut -d " " -f 1`
    hs+=\"$t_hs\"" "
  done
}


get_total_hashes(){
#Jan 07 13:01:38.090 INFO Mining: Cuck(at)oo at 4.837775854030834 gps (graphs per second)
  khs=0
  khs=`cat $log_name | tail -n 50 | grep "INFO Mining: Cuck(at)oo at" | tail -n 1 | cut -f 8 -d " " -s | awk '{ printf($1/1000) }'`
}

get_miner_uptime(){
  local a=0
  let a=`stat --format='%Y' $log_name`-`stat --format='%Y' $conf_name`
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


local log_name="$MINER_LOG_BASENAME.log"
local ver=`miner_ver`
local conf_name="/hive/miners/$MINER_NAME/$ver/grin-miner.toml"

local temp=$(jq '.temp' <<< $gpu_stats)
local fan=$(jq '.fan' <<< $gpu_stats)

[[ $cpu_indexes_array != '[]' ]] && #remove Internal Gpus
  temp=$(jq -c "del(.$cpu_indexes_array)" <<< $temp) &&
  fan=$(jq -c "del(.$cpu_indexes_array)" <<< $fan)

GPU_COUNT=`echo $(gpu-detect AMD) $(gpu-detect NVIDIA) | awk '{ printf($1 + $2) }'`

# Calc log freshness
local diffTime=$(get_log_time_diff)
local maxDelay=120

# echo $diffTime

local algo="cuckoo"

# If log is fresh the calc miner stats or set to null if not
if [ "$diffTime" -lt "$maxDelay" ]; then
  get_cards_hashes # hashes, temp, fan array
  get_total_hashes # total hashes, accepted, rejected
  local hs_units='hs' # hashes utits
  local uptime=$(get_miner_uptime) # miner uptime

# make JSON
#--argjson hs "`echo ${hs[@]} | tr " " "\n" | jq -cs '.'`" \
  stats=$(jq -nc \
        --argjson hs "`echo ${hs[@]} | tr " " "\n" | jq -cs '.'`" \
        --arg hs_units "$hs_units" \
        --argjson temp "$temp" \
        --argjson fan "$fan" \
        --arg uptime "$uptime" \
        --arg algo "$algo" \
        --arg ver "$ver" \
        '{$hs, $hs_units, $temp, $fan, $uptime, $algo, $ver}')
else
  stats=""
  khs=0
fi

# debug output
#echo temp:  $temp
#echo fan:   $fan
#echo stats: $stats
#echo khs:   $khs
