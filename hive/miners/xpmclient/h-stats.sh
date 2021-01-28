#!/usr/bin/env bash

#######################
# Functions
#######################

#. /hive-config/wallet.conf

get_hashes(){
  hs=''
  khs=0
  local t_hs=0
  local t_num=0
  local t=0
  for (( t=0; t < $gpu_count; t++ )); do
    [[ $fork =~ "opencl" ]] && t_num=`cat ${log_name}_head | grep INFO | grep "device $t" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | cut -d "|" -f 2 | awk '{print $6}'` || t_num=$t
    if [[ ! -z $t_num ]]; then
      if [[ `cat $log_name | tail -2000 | grep ERR | grep "GPU $t_num" | grep -c "crashed!"` -eq 0 ]]; then #check GPU error
        t_hs=`cat $log_name | tail -2000 | grep INFO | grep "GPU $t_num" | grep "primes=" | tail -1 | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | cut -d "|" -f 2 | awk '{print $8}' | cut -d "=" -f 2 | cut -d "/" -f 1`
      else
        t_hs=0
      fi
      [[ -z $t_hs ]] && t_hs=0
      hs+="$t_hs "
      khs=`echo $khs $t_hs | awk '{ printf("%.6f", $1 + $2/1000) }'`
    else
      hs+="0 "
    fi
  done
}

get_miner_uptime(){
  cat $log_name | tail -2000 | grep INFO | tail -1 | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | cut -d "(" -f 2 | cut -d "." -f 1
}

get_log_time_diff(){
  local a=0
  let a=`date +%s`-`stat --format='%Y' $log_name`
  echo $a
}

get_shares(){
  local t_line=
  acc=0
  rej=0
  t=0
  local line=`cat $log_name | tail -2000 | grep '(ST/INV/DUP)' | tail -1 | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | cut -d ':' -f 4 `
    for t_line in $line; do
      if [[ $t_line =~ "x" ]]; then
        acc=$(($acc + ${t_line%%x}))
      else
        t=`echo $t_line | cut -d "/" -f 2 | cut -d "/" -f 1`
        [[ ! -z $t ]] && rej=$(($rej + $t))
      fi
    done <<< "$line"
}


#######################
# MAIN script body
#######################
local log_name="$MINER_LOG_BASENAME.log"
local ver=`miner_ver`
local fork=`miner_fork`

if [[ $fork =~ "opencl" ]]; then
  devices_indexes_array=$amd_indexes_array
else
  . /hive-config/wallet.conf

  if [[ $XPMCLIENT_USER_CONFIG =~ "devices" ]]; then
    devices_indexes_array=
    while read -r line; do
      [[ -z $line ]] && continue

      if [[ $line =~ "devices" ]]; then
        local devices=`echo ${line%%;} | cut -d "=" -f 2 | jq -r '.[]'`
        i=0
        for d in $devices; do
          if [[ $d -eq 1 ]]; then
            devices_indexes_array+=`echo $nvidia_indexes_array | jq -r ".[$i]"`" "
          fi
          ((i++))
        done
        devices_indexes_array=`echo ${devices_indexes_array[@]} | tr " " "\n" | jq -cs '.'`
      fi
    done <<< "$XPMCLIENT_USER_CONFIG"
  else
    devices_indexes_array=$nvidia_indexes_array
  fi
fi

bus_numbers=`echo $gpu_detect_json | jq -r ".$devices_indexes_array.busid" |  awk '{printf("%d\n", "0x"$1)}' | jq -cs '.'`
temp=`jq -r "[.temp$devices_indexes_array]" <<< $gpu_stats`
fan=`jq -r "[.fan$devices_indexes_array]" <<< $gpu_stats`

gpu_count=`echo $bus_numbers | tr "," " " | wc -w`

# Calc log freshness
local diffTime=`get_log_time_diff`
local maxDelay=120

# echo $diffTime

local algo="prime"

# If log is fresh the calc miner stats or set to null if not
if [ "$diffTime" -lt "$maxDelay" ]; then
  get_hashes # hashes array
  local hs_units='hs' # hashes utits
  local uptime=`get_miner_uptime $conf_name` # miner uptime
  [[ $uptime < 60 ]] && cp $log_name ${log_name}_head
  acc=0
  rej=0
  get_shares
  stats=$(jq -nc \
        --argjson hs "`echo ${hs[@]} | tr " " "\n" | jq -cs '.'`" \
        --arg hs_units "$hs_units" \
        --argjson temp "$temp" \
        --argjson fan "$fan" \
        --arg uptime "$uptime" \
        --arg acc "$acc" --arg rej "$rej" \
        --arg algo "$algo" \
        --arg ver "$ver" \
        --argjson bus_numbers "$bus_numbers" \
       '{$hs, $hs_units, ar: [$acc,$rej], $temp, $fan, $uptime, $algo, $bus_numbers, $ver}')
else
  stats=""
  khs=0
fi

# debug output
#echo temp:   $temp
#echo fan:    $fan
#echo stats:  $stats
#echo khs:    $khs
#echo hs:     $hs
#echo uptime: $uptime
#echo algo:   $algo
#echo ver:    $ver
#echo acc:    $acc
#echo rej:    $rej
#echo bus_n:  $bus_numbers
