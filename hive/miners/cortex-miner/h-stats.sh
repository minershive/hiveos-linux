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
  for (( i = 0; i < $gpu_count; i++ )); do
    #2019/09/10 01:45:49 GPU0 GPS=0.4430, hash rate=Inf, find solutions: 0, fan=0%, t=55C
    t_str=`cat $log_name | tail -n 100 | grep "GPU$i GPS=" | tail -1`
    if [[ ! -z $t_str ]]; then
      t_hs=`echo $t_str | egrep -o 'GPS=([0-9\.])+' | cut -d "=" -f 2`
      hs+="$t_hs "
      t_fan=`echo $t_str | egrep -o 'fan=([0-9])+%' | egrep -o '([0-9])+'`
      fan+="$t_fan "
      t_temp=`echo $t_str | egrep -o 't=([0-9])+C' | egrep -o '([0-9])+'`
      temp="$t_temp "
    else
      hs+="0 "
      fan+="0 "
      temp+="0 "
    fi
    khs=`echo $khs $t_hs | awk '{ printf("%.6f", $1 + $2/1000) }'`
  done
}

get_solutions(){
  local t_str=
  #2019/09/10 01:45:49 find total solutions : 0, share accpeted : 0, share rejected : 0
  t_str=`cat $log_name | tail -n 100 | grep "find total solutions : " | tail -1`
  if [[ ! -z $t_str ]]; then
    acc=`echo $t_str | egrep -o 'share accpeted : ([0-9])+' | egrep -o '([0-9])+'`
    rej=`echo $t_str | egrep -o 'share rejected : ([0-9])+' | egrep -o '([0-9])+'`
  fi
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

local log_name="/var/log/miner/cortex-miner/cortex-miner.log"
local ver=`miner_ver`

local conf_name="/run/hive/miners/$MINER_NAME/$MINER_NAME.conf"

#array of user selected GPUS
gpu_indexes_array=`cat $conf_name | egrep -o '*-devices=([0-9\,])+' | cut -d "=" -f 2`
gpu_count=echo $gpu_indexes_array | tr ',' ' ' | wc -w

khs=0
hs=''
acc=0
rej=0

# Calc log freshness
local diffTime=`get_log_time_diff`
local maxDelay=120

local algo="eaglesong"

# If log is fresh the calc miner stats or set to null if not
if [ "$diffTime" -lt "$maxDelay" ]; then
  get_cards_hashes
  get_solutions
  local hs_units='hs' # hashes utits
  local uptime=`get_miner_uptime $conf_name` # miner uptime

# make JSON
  stats=$(jq -nc \
        --argjson hs "`echo ${hs[@]} | tr " " "\n" | jq -cs '.'`" \
        --arg hs_units "$hs_units" \
        --argjson temp "`echo ${temp[@]} | tr " " "\n" | jq -cs '.'`" \
        --argjson fan "`echo ${fan[@]} | tr " " "\n" | jq -cs '.'`" \
        --arg uptime "$uptime" \
        --argjson ar "$acc_rej" \
        --arg algo "$algo" \
        --arg ver "$ver" \
        '{$hs, $hs_units, $ar, $temp, $fan, $uptime, $algo, $ver}')
else
  stats=""
  khs=0
fi

# debug output
##echo temp:  $temp
##echo fan:   $fan
#echo stats: $stats
#echo khs:   $khs
