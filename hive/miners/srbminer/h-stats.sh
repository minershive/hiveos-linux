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
  dpkg --compare-versions "`jq -r '.miner_version' <<< \"$stats_raw\"`" "gt" "0.4.7"; [[ $? -eq "0" ]] && local ver=1 || local ver=0;

  (($ver)) && local dev_numbers=`echo $stats_raw | jq -r '.algorithms[0].hashrate.gpu | to_entries[] | select(.key | contains("gpu")) | .key' | tr -d 'gpu' | jq -cs '.'` ||
              local dev_numbers=`echo $stats_raw | jq -r '.gpu_devices[].device_id' | jq -cs '.'`
  if [[ $dev_numbers != '[]' ]]; then
    local gpu_fan=; local gpu_temp=;
    (($ver)) && local gpu_hs=`echo $stats_raw | jq -r '.algorithms[0].hashrate.gpu | to_entries[] | select(.key | contains("gpu")) | .value' | jq -cs '.'` ||
                local gpu_hs=`echo $stats_raw | jq -r '.gpu_hashrate[] | to_entries | .'$dev_numbers'.value' | jq -cs '.'`
    local gpu_bus_numbers=`echo $stats_raw | jq -r '.gpu_devices'$dev_numbers'.bus_id' | jq -cs '.'`
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
    gpu_fan=`echo ${gpu_fan[@]} | jq -cs '.'`
    gpu_temp=`echo ${gpu_temp[@]} | jq -cs '.'`
  fi

  (($ver)) && local cpu_threads=`echo $stats_raw | jq '.algorithms[0].hashrate.cpu | to_entries[] | select(.key | contains("thread")) | .key' | wc -l` ||
              local cpu_threads=`echo $stats_raw | jq -r '.cpu_threads'`
  if [[ $cpu_threads -gt 0 ]]; then
    (($ver)) && cpu_hs=`echo $stats_raw | jq -r '.algorithms[0].hashrate.cpu | to_entries | .[]|select(.key | contains("thread")) | .value' | jq -cs '.'` ||
                cpu_hs=`echo $stats_raw | jq -r '.cpu_hashrate[] | to_entries | .[]|select(.key | contains("thread")) | .value' | jq -cs '.'`
    cpu_bus_numbers=`get_cpu_bus_numbers $cpu_threads`
    cpu_fan=`get_cpu_fans $cpu_threads`
    cpu_temp=`get_cpu_temps $cpu_threads`
  fi
  local hs=`jq -sc '.[0] + .[1]' <<< "$gpu_hs $cpu_hs"`
  local bus_numbers=`jq -sc '.[0] + .[1]' <<< "$gpu_bus_numbers $cpu_bus_numbers"`
  local temp=`jq -sc '.[0] + .[1]' <<< "$gpu_temp $cpu_temp"`
  local fan=`jq -sc '.[0] + .[1]' <<< "$gpu_fan $cpu_fan"`
  if (($ver)); then
    local algo=`echo $stats_raw | jq -r '.algorithms[0].name'`
    local ac=`echo $stats_raw | jq -r '.algorithms[0].shares.accepted'`
    local rj=`echo $stats_raw | jq -r '.algorithms[0].shares.rejected'`
    khs=`echo $stats_raw | jq -r '.algorithms[0].hashrate.now' | awk '{print $1/1000}'`
  else
    local algo=`echo $stats_raw | jq -r '.algorithm'`
    local ac=`echo $stats_raw | jq -r '.shares.accepted'`
    local rj=`echo $stats_raw | jq -r '.shares.rejected'`
    khs=`echo $stats_raw | jq -r '.hashrate_total_now' | awk '{print $1/1000}'`
  fi

  if [[ `echo $stats_raw | jq -r '.algorithms | length'` -gt 1 ]]; then
    local dev_numbers2=`echo $stats_raw | jq -r '.algorithms[1].hashrate.gpu | to_entries[] | select(.key | contains("gpu")) | .key' | tr -d 'gpu' | jq -cs '.'`
    if [[ $dev_numbers2 != '[]' ]]; then
      local gpu_fan2=; local gpu_temp2=;
      local gpu_hs2=`echo $stats_raw | jq -r '.algorithms[1].hashrate.gpu | to_entries[] | select(.key | contains("gpu")) | .value' | jq -cs '.'`
      local gpu_bus_numbers2=`echo $stats_raw | jq -r '.gpu_devices'$dev_numbers'.bus_id' | jq -cs '.'`
      local miner_bus_ids_array=(`echo "$gpu_bus_numbers2" | jq -r '.[]'`)
      for ((i = 0; i < ${#miner_bus_ids_array[@]}; i++)); do
        for ((j = 0; j < ${#all_bus_ids_array[@]}; j++)); do
          if [[ "$(( 0x${all_bus_ids_array[$j]} ))" -eq "${miner_bus_ids_array[$i]}" ]]; then
            gpu_fan2+=$(jq .[$j] <<< $t_fan)" "
            gpu_temp2+=$(jq .[$j] <<< $t_temp)" "
          fi
        done
      done
      gpu_fan2=`echo ${gpu_fan2[@]} | jq -cs '.'`
      gpu_temp2=`echo ${gpu_temp2[@]} | jq -cs '.'`
    fi

    local cpu_threads2=`echo $stats_raw | jq '.algorithms[1].hashrate.cpu | to_entries[] | select(.key | contains("thread")) | .key' | wc -l`
    if [[ $cpu_threads2 -gt 0 ]]; then
      cpu_hs2=`echo $stats_raw | jq -r '.algorithms[1].hashrate.cpu | to_entries | .[]|select(.key | contains("thread")) | .value' | jq -cs '.'`
      cpu_bus_numbers2=`get_cpu_bus_numbers $cpu_threads2`
      cpu_fan2=`get_cpu_fans $cpu_threads2`
      cpu_temp2=`get_cpu_temps $cpu_threads2`
    fi
    local hs2=`jq -sc '.[0] + .[1]' <<< "$gpu_hs2 $cpu_hs2"`
    local bus_numbers2=`jq -sc '.[0] + .[1]' <<< "$gpu_bus_numbers2 $cpu_bus_numbers2"`
    local temp2=`jq -sc '.[0] + .[1]' <<< "$gpu_temp2 $cpu_temp2"`
    local fan2=`jq -sc '.[0] + .[1]' <<< "$gpu_fan2 $cpu_fan2"`
    local algo2=`echo $stats_raw | jq -r '.algorithms[1].name'`
    local ac2=`echo $stats_raw | jq -r '.algorithms[1].shares.accepted'`
    local rj2=`echo $stats_raw | jq -r '.algorithms[1].shares.rejected'`

    khs2=`echo $stats_raw | jq -r '.algorithms[1].hashrate.now' | awk '{print $1/1000}'`

    stats=`jq \
            --arg total_khs "$khs" \
            --argjson hs "$hs" \
            --arg hs_units "hs" \
            --argjson temp "$temp" \
            --argjson fan "$fan" \
            --argjson bus_numbers "$bus_numbers" \
            --arg algo "$algo" \
            --arg total_khs2 "$khs2" \
            --argjson hs2 "$hs2" \
            --arg hs_units2 "hs" \
            --argjson temp2 "$temp2" \
            --argjson fan2 "$fan2" \
            --argjson bus_numbers2 "$bus_numbers2" \
            --arg algo2 "$algo2" \
           '{$total_khs, $hs, $hs_units, $temp, $fan, ar: ['$ac', '$rj'], $algo, $bus_numbers,
             $total_khs2, $hs2, $hs_units2, $temp2, $fan2, ar2: ['$ac2', '$rj2'], $algo2, $bus_numbers2,
             uptime: .mining_time, ver: .miner_version}' <<< "$stats_raw"`
  else
    stats=`jq \
            --arg total_khs "$khs" \
            --argjson hs "$hs" \
            --arg hs_units "hs" \
            --argjson temp "$temp" \
            --argjson fan "$fan" \
            --argjson bus_numbers "$bus_numbers" \
            --arg algo "$algo" \
           '{$total_khs, $hs, $hs_units, $temp, $fan, ar: ['$ac', '$rj'],
            uptime: .mining_time, $algo, $bus_numbers, ver: .miner_version}' <<< "$stats_raw"`
  fi
fi

[[ -z $khs ]] && khs=0
[[ -z $stats ]] && stats="null"
