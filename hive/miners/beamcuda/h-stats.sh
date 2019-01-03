#!/usr/bin/env bash

#######################
# Functions
#######################

get_cards_hashes(){
#20:18:28 [Info ]: GPU:0: A:0/R:0, t:39C P:0W fan:29% 3.6/3.32 Sol/s
#20:18:28 [Info ]: GPU:1: A:0/R:0, t:40C P:0W fan:29% 2.9/3.32 Sol/s
  hs=''; local t_hs=0
  temp=''; local t_temp=0
  fan=''; local t_fan=0
  local i=0
  for (( i=0; i < ${GPU_COUNT_NVIDIA}; i++ )); do
    t_temp=`cat $log_name | tail -n 50 | grep GPU:$i | tail -n 1 | cut -f 6 -d " " -s`; t_temp=`echo ${t_temp#t:}`; t_temp=`echo ${t_temp%C}`
    temp+=\"$t_temp\"" "
    t_fan=`cat $log_name | tail -n 50 | grep GPU:$i | tail -n 1 | cut -f 8 -d " " -s`; t_fan=`echo ${t_fan#fan:}`; t_fan=`echo ${t_fan%\%}`
    fan+=\"$t_fan\"" "
    t_hs=`cat $log_name | tail -n 50 | grep GPU:$i | tail -n 1 | cut -f 9 -d " " -s`; t_hs=`echo ${t_hs/\//" "} | cut -f 2 -d " " -s`
    hs+=\"$t_hs\"" "
  done
}


get_total_hashes(){
#20:18:28 [Info ]: Total: A:0/R:0 6.5/6.63 Sol/s (3.2/3.17 H/s)
  khs=0
  ac=`cat $log_name | tail -n 50 | grep Total | tail -n 1 | cut -f 5 -d " " -s`; ac=`echo ${ac/\//" "} | cut -f 1 -d " " -s`; ac=${ac#A:}
  rj=`cat $log_name | tail -n 50 | grep Total | tail -n 1 | cut -f 5 -d " " -s`; rj=`echo ${rj/\//" "} | cut -f 2 -d " " -s`; rj=${rj#R:}
  khs=`cat $log_name | tail -n 50 | grep Total | tail -n 1 | cut -f 6 -d " " -s`; khs=`echo ${khs/\//" "} | cut -f 2 -d " " -s`; khs=`echo $khs | awk '{ printf($1/1000) }'`
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

local temp=
local fan=
local ac=0
local rj=0

[[ -z $GPU_COUNT_NVIDIA ]] && GPU_COUNT_NVIDIA=`gpu-detect NVIDIA`

# Calc log freshness
local diffTime=$(get_log_time_diff)
local maxDelay=120

# echo $diffTime

local algo="equihash 150/5"

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
        --argjson temp "`echo ${temp[@]} | tr " " "\n" | jq -cs '.'`" \
        --argjson fan "`echo ${fan[@]} | tr " " "\n" | jq -cs '.'`" \
        --arg ac "$ac" --arg rj "$rj" \
        --arg uptime "$uptime" \
        --arg algo "$algo" \
				--arg ver "$ver" \
        '{$hs, $hs_units, $temp, $fan, $uptime, $algo, ar: [$ac, $rj], $ver}')
else
  stats=""
  khs=0
fi

# debug output
##echo temp:  $temp
##echo fan:   $fan
#echo stats: $statsOD
#echo khs:   $khs
