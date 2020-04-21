#!/usr/bin/env bash

#######################
# Functions
#######################

#. /hive-config/wallet.conf

get_hashes(){
  hs=''
  khs=0
  local t_hs=0
  local tcore=`cpu-temp`
  #get gpus hashes
  #Total 5.97 MH/s [cpu0 0.74, cpu1 0.71, cpu2 0.74, cpu3 0.77, cpu4 0.71, cpu5 0.77, cpu6 0.77, cpu7 0.74] 5 shares
  local t_stat=`cat $log_name | tail -n 50 | grep "Total" | tail -1`
  khs=`echo $t_stat | cut -d " " -f 2 | awk '{ printf("%.6f", $1*1000) }'`
  for (( t_cpu=0; t_cpu < $cpu_count; t_cpu++ )); do
    t_hs=`cat $log_name | tr " " "\n" | grep -A 1 "cpu$t_cpu" | tail -1 | tr -d ',]'`
    hs+="$t_hs "
    bus_numbers+="null "
    l_temp+="$tcore "
  done
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
local log_name="$MINER_LOG_BASENAME.log"
local ver=`miner_ver`

bus_numbers=
l_temp=

local conf_name="/run/hive/miners/$MINER_NAME/$MINER_NAME.conf"

cpu_count=`cat $conf_name | tr " " "\n" | grep '\-\-cpu=' | cut -d "=" -f 2`

# Calc log freshness
local diffTime=`get_log_time_diff`
local maxDelay=120

# echo $diffTime

local algo="verushash"

# If log is fresh the calc miner stats or set to null if not
if [ "$diffTime" -lt "$maxDelay" ]; then
  get_hashes # hashes array
  local hs_units='mhs' # hashes utits
  local uptime=`get_miner_uptime $conf_name` # miner uptime
  #Total 5.97 MH/s [cpu0 0.74, cpu1 0.71, cpu2 0.74, cpu3 0.77, cpu4 0.71, cpu5 0.77, cpu6 0.77, cpu7 0.74] 5 shares
  local acc=`cat $log_name | tail -n 50 | grep "Total" | tail -1 | tr " " "\n" | grep -B 1 "shares" | head -1`
  [[ -z $acc ]] && acc=0

  stats=$(jq -nc \
        --argjson hs "`echo ${hs[@]} | tr " " "\n" | jq -cs '.'`" \
        --arg hs_units "$hs_units" \
        --argjson temp "`echo ${l_temp[@]} | tr " " "\n" | jq -cs '.'`" \
        --arg uptime "$uptime" \
        --arg acc "$acc" \
        --arg algo "$algo" \
        --arg ver "$ver" \
        --argjson bus_numbers "`echo ${bus_numbers[@]} | tr " " "\n" | jq -cs '.'`" \
       '{$hs, $hs_units, ar: [$acc,0], $temp, $uptime, $algo, $bus_numbers, $ver}')
else
  stats=""
  khs=0
fi

# debug output
#echo temp:   $l_temp
#echo stats:  $stats
#echo khs:    $khs
#echo hs:     $hs
#echo uptime: $uptime
#echo algo:   $algo
#echo ver:    $ver
#echo acc:    $acc
#echo bus_n:  $bus_numbers

