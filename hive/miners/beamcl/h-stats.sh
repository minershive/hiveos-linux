#!/usr/bin/env bash

#######################
# Functions
#######################

get_cards_hashes(){
  #Performance: 2.27 sol/s 7.40 sol/s 7.80 sol/s 9.47 sol/s.
  hs=''
  khs=0
  local i=0; local a=0
  local perf=`cat $log_name | tail -n 100 | grep "Performance:" | tail -n 1`
  for t_hs in $perf; do
    let "i++"
    let a=$i%2
    [[ $a -eq 1 ]] && continue
    hs+=\"$t_hs\"" "
    khs=`echo $khs $t_hs | awk '{ printf("%.6f", $1 + $2/1000) }'`
  done
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
local conf_name="/hive/miners/$MINER_NAME/$ver/$MINER_NAME.conf"

local temp=$(jq '.temp' <<< $gpu_stats)
local fan=$(jq '.fan' <<< $gpu_stats)
cat $conf_name | grep -q "\-\-enable-cpu"
if [[ $? -eq 0 ]]; then
  [[ $cpu_indexes_array != '[]' ]] && #remove Internal Gpus
    temp=$(jq -c "del(.$cpu_indexes_array)" <<< $temp) &&
    fan=$(jq -c "del(.$cpu_indexes_array)" <<< $fan)
fi

# Calc log freshness
local diffTime=$(get_log_time_diff)
local maxDelay=120

# echo $diffTime

local algo="equihash 150/5"

# If log is fresh the calc miner stats or set to null if not
if [ "$diffTime" -lt "$maxDelay" ]; then
  get_cards_hashes # hashes array
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
##echo temp:  $temp
##echo fan:   $fan
#echo stats: $statsOD
#echo khs:   $khs
