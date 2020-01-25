#!/usr/bin/env bash

get_cpu_temps () {
  local t_core=`cpu-temp`
  local i=0
  local l_num_cores=$1
  local l_temp=
  for (( i=0; i < ${l_num_cores}; i++ )); do
    l_temp+="$t_core "
  done
  echo ${l_temp[@]} | tr " " "\n" | jq -cs '.'
}

get_cpu_fans () {
  local t_fan=0
  local i=0
  local l_num_cores=$1
  local l_fan=
  for (( i=0; i < ${l_num_cores}; i++ )); do
    l_fan+="$t_fan "
  done
  echo ${l_fan[@]} | tr " " "\n" | jq -cs '.'
}

get_cpu_bus_numbers () {
  local i=0
  local l_num_cores=$1
  local l_numbers=
  for (( i=0; i < ${l_num_cores}; i++ )); do
    l_numbers+="null "
  done
  echo ${l_numbers[@]} | tr " " "\n" | jq -cs '.'
}

local gpu_hs=[]; local cpu_hs=[]
local gpu_bus_numbers=[]; local cpu_bus_numbers=[]
local gpu_fan=[]; local cpu_fan=[]; local t_fan=$(jq '.fan' <<< $gpu_stats)
local gpu_temp=[]; local cpu_temp=[]; local t_temp=$(jq '.temp' <<< $gpu_stats)
local ver=`miner_ver`
stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:$MINER_API_PORT`
#echo $stats_raw | jq .
if [[ $? -ne 0 || -z $stats_raw ]]; then
  echo -e "${YELLOW}Failed to read $miner from localhost:$MINER_API_PORT${NOCOLOR}"
else
  if [[ `echo $stats_raw | jq -r '.gpu_threads'` -gt 0 ]]; then
    gpu_fan=; gpu_temp=;
    local device_ids=`echo $stats_raw | jq -r '.gpu_devices[].device_id' | jq -sc '.'`
    gpu_hs=`echo $stats_raw | jq '.gpu_hashrate[] | to_entries | .'$device_ids'.value' | jq -sc '.'`
    gpu_bus_numbers=`echo $stats_raw | jq -r '.gpu_devices[].bus_id' | jq -sc '.'`
    local all_bus_ids_array=(`echo "$gpu_detect_json" | jq -r '[ . | to_entries[] | select(.value) | .value.busid [0:2] ] | .[]'`)
    local miner_bus_ids_array=(`echo "$gpu_bus_numbers" | jq -r '.[]'`)
    for ((i = 0; i < ${#miner_bus_ids_array[@]}; i++)); do
      for ((j = 0; j < ${#all_bus_ids_array[@]}; j++)); do
        if [[ "$(( 0x${all_bus_ids_array[$j]} ))" -eq "${miner_bus_ids_array[$i]}" ]]; then
          gpu_fan+=$(jq .[$j] <<< $t_fan)" "
          gpu_temp+=$(jq .[$j] <<< $t_temp)" "
        fi
      done
    done
    gpu_fan=`echo ${gpu_fan[@]} | jq -sc '.'`
    gpu_temp=`echo ${gpu_temp[@]} | jq -sc '.'`
  fi
  local cpu_threads=`echo $stats_raw | jq -r '.cpu_threads'`
  if [[ $cpu_threads -gt 0 ]]; then
    cpu_hs=`echo $stats_raw | jq -r '.cpu_hashrate[] | to_entries | .[]|select(.key | contains("thread")) | .value' | jq -cs '.'`
    cpu_bus_numbers=`get_cpu_bus_numbers $cpu_threads`
    cpu_fan=`get_cpu_fans $cpu_threads`
    cpu_temp=`get_cpu_temps $cpu_threads`
  fi
  local hs=`jq -sc '.[0] + .[1]' <<< "$gpu_hs $cpu_hs"`
  local bus_numbers=`jq -sc '.[0] + .[1]' <<< "$gpu_bus_numbers $cpu_bus_numbers"`
  local temp=`jq -sc '.[0] + .[1]' <<< "$gpu_temp $cpu_temp"`
  local fan=`jq -sc '.[0] + .[1]' <<< "$gpu_fan $cpu_fan"`

  khs=`echo $stats_raw | jq -r '.hashrate_total_now' | awk '{print $1/1000}'`
  stats=`jq --arg ac "$ac" --arg rj "$rj" \
            --argjson hs "$hs" \
            --argjson temp "$temp" \
            --argjson fan "$fan" \
            --argjson bus_numbers "$bus_numbers" \
           '{$hs, $temp, $fan, ar: [.shares.accepted, .shares.rejected],
            uptime: .mining_time, algo: .algorithm, $bus_numbers, ver: .miner_version}' <<< "$stats_raw"`
fi

[[ -z $khs ]] && khs=0
[[ -z $stats ]] && stats="null"
