#!/usr/bin/env bash

#######################
# Functions
#######################

get_hashes(){
  #[21:09:27][0x00007f30a093c740] .[33mSpeed [15 sec]: 0 MH/s, .[0m
  hs=''
  local i=0
  local t_temp=`cpu-temp`
  khs=`cat $log_name | tail -n 100 | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | grep "Speed \[" | tail -n 1 | awk '{ printf("%.6f", $5*1000) }'`
  local t_hs=`echo "$khs / $threads" | bc`
  for (( i = 0; i < $threads; i++ )); do
    hs+="$t_hs "
    a_temp+="$t_temp "
    a_fan+="0 "
    a_bus+="null "
  done
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

get_shares(){
  #[21:18:40][0x00007f309f87a700] stratum | .[32mAccepted share #4.[0m
  acc=`cat ${MINER_LOG_BASENAME}.log | tail -n 100 | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | grep "Accepted share #" | tail -n 1 | awk '{ print $6}' | tr -d "#"`
  [[ -z $acc ]] && acc=0

  rej=`cat ${MINER_LOG_BASENAME}.log | grep -c "Rejected share #"`
  [[ -z $rej ]] && rej=0
  [[ $acc -gt 3 ]] && acc=`echo "$acc - 3 - $rej" | bc`
}

#######################
# MAIN script body
#######################

local log_name="$MINER_LOG_BASENAME.log"
local ver=`miner_ver`
local conf_name="/run/hive/miners/$MINER_NAME/$MINER_NAME.conf"
local algo="verushash"
a_temp=
a_fan=
a_bus=

# Calc log freshness
local diffTime=$(get_log_time_diff)
local maxDelay=120

# If log is fresh the calc miner stats or set to null if not
if [ "$diffTime" -lt "$maxDelay" ]; then
  local uptime=$(get_miner_uptime) # miner uptime

  [[ "$uptime" -lt 60 ]] && head -n 150 ${MINER_LOG_BASENAME}.log > ${MINER_LOG_BASENAME}_head.log

  local threads=`cat ${MINER_LOG_BASENAME}_head.log | grep -c "Starting thread #"`

  get_hashes
  local hs_units='khs' # hashes utits
  hs=`echo ${hs[@]} | tr " " "\n" | jq -cs '.'`
  a_temp=`echo ${a_temp[@]} | tr " " "\n" | jq -cs '.'`
  a_fan=`echo ${a_fan[@]} | tr " " "\n" | jq -cs '.'`
  a_bus=`echo ${a_bus[@]} | tr " " "\n" | jq -cs '.'`

  acc=0
  rej=0
  get_shares

# make JSON
  stats=$(jq -nc \
        --argjson hs "$hs" \
        --arg hs_units "$hs_units" \
        --argjson temp "$a_temp" \
        --argjson fan "$a_fan" \
        --arg uptime "$uptime" \
        --arg acc "$acc" \
        --arg rej "$rej" \
        --arg algo "$algo" \
        --argjson bus_numbers "$a_bus" \
        --arg ver "$ver" \
        '{$hs, $hs_units, $temp, $fan, ar: [$acc, $rej], $uptime, $algo, $bus_numbers, $ver}')
else
  stats=""
  khs=0
fi

# debug output
##echo temp:  $temp
##echo fan:   $fan
#echo stats: $stats
#echo khs:   $khs
