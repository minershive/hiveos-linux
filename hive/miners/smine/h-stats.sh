#!/usr/bin/env bash

#######################
# Functions
#######################

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

local log_name="/var/log/miner/smine/smine.log"
local ver=`miner_ver`

local conf_name="/run/hive/miners/$MINER_NAME/$MINER_NAME.conf"

##array of user selected GPUS
#gpu_indexes_array=`cat $conf_name | egrep -o '*-device\ ([0-9\,])+' | awk '{print "["$2"]"}'`

local temp="[]"
local fan="[]"

local temp=`jq -c "[.temp$amd_indexes_array]" <<< $gpu_stats`
local fan=`jq -c "[.fan$amd_indexes_array]" <<< $gpu_stats`

#if [[ ! -z $gpu_indexes_array ]]; then
#  temp=`jq -c "[.$gpu_indexes_array]" <<< $temp`
#  fan=`jq -c "[.$gpu_indexes_array]" <<< $fan`
#fi

# Calc log freshness
local diffTime=`get_log_time_diff`
local maxDelay=120

local algo="eaglesong"

# If log is fresh the calc miner stats or set to null if not
if [ "$diffTime" -lt "$maxDelay" ]; then
  #INFO : 2019/09/06 22:11:00.736198 Hash Rate (MH/s):  15.94 15.94 15.94 13.70 14.26
  hs=`cat $log_name | grep "Hash Rate (MH/s):" | tail -1 | cut -c 54- | tr ' ' ','`
  khs=`echo "($hs)*1000" | tr ',' '+' | bc`
  hs="[$hs]"
  local hs_units='mhs' # hashes utits
  local uptime=`get_miner_uptime $conf_name` # miner uptime
  #INFO : 2019/09/06 22:11:30.736157 Accept/Reject: 4 / 0
  local acc_rej=[`cat $log_name | tail -100 | grep "Accept/Reject"  | tail -1 | cut -c 50- | tr '/' ',' | tr -d " "`]

# make JSON
  stats=$(jq -nc \
        --argjson hs "$hs" \
        --arg hs_units "$hs_units" \
        --argjson temp "$temp" \
        --argjson fan "$fan" \
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
