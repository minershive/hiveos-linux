#!/usr/bin/env bash

get_cpu_temp () {
  local coretemp0=`cat /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp*_input 2>/dev/null`
  [[ ! -z $coretemp0 ]] && #may not work with AMD cpous
    local tcore=$((`cat /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp*_input | head -n 1`/1000)) ||
    tcore=`cat /sys/class/hwmon/hwmon0/temp*_input | head -n 1 | awk '{print $1/1000}'` #maybe we will need to detect AMD cores
  echo $tcore
}

stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:$MINER_API_PORT/api.json`
if [[ $? -ne 0 || -z $stats_raw ]]; then
  echo -e "${YELLOW}Failed to read $miner from localhost:${MINER_API_PORT}${NOCOLOR}"
else
  [[ `echo $stats_raw | jq -r '.connection.uptime'` -lt 60 ]] && head -n 50 ${MINER_LOG_BASENAME}.log > ${MINER_LOG_BASENAME}_head.log
  local cpu_threads=`cat ${MINER_LOG_BASENAME}_head.log | grep "  cpu  READY threads" | awk '{print $6}' | cut -d '/' -f 1`
  local gpu_bus_ids=`cat ${MINER_LOG_BASENAME}_head.log | grep '|..[[:digit:]] |...[[:digit:]] | ' | awk '{ printf $6"\n" }' | cut -d ':' -f 1`
  local all_bus_ids_array=(`echo "$gpu_detect_json" | jq -r '[ . | to_entries[] | select(.value) | .value.busid [0:2] ] | .[]'`)
  local temp=$(jq '.temp' <<< $gpu_stats)
  local fan=$(jq '.fan' <<< $gpu_stats)
  local t_bus_id=
  local bus_id=
  local bus_ids=
  local l_temps=
  local l_fans=
  local cpu_temp=`get_cpu_temp`
  [[ $cpu_temp = "" ]] && cpu_temp=null
  if [[ $cpu_threads -gt 0 ]]; then
    for ((i = 0; i < $cpu_threads; i++)); do
      bus_ids+='null,'
      l_temps+="$cpu_temp,"
      l_fans+='null,'
    done
  fi
  for t_bus_id in $gpu_bus_ids; do
    bus_id=$(( 0x${t_bus_id} ))
    bus_ids+=${bus_id}","
    for ((j = 0; j < ${#all_bus_ids_array[@]}; j++)); do
      if [[ "$(( 0x${all_bus_ids_array[$j]} ))" -eq "$bus_id" ]]; then
        l_temps+=$(jq .[$j] <<< $temp)","
        l_fans+=$(jq .[$j] <<< $fan)","
      fi
    done
  done
  bus_ids="[${bus_ids%%,}]"
  l_temps="[${l_temps%%,}]"
  l_fans="[${l_fans%%,}]"

  khs=`echo $stats_raw | jq -r '.hashrate.total[0]' | awk '{print $1/1000}'`
  local ac=$(jq '.results.shares_good' <<< "$stats_raw")
  local rj=$(( $(jq '.results.shares_total' <<< "$stats_raw") - $ac ))
  stats=$(jq \
         --argjson temp "$l_temps" --argjson fan "$l_fans" \
         --arg ac "$ac" --arg rj "$rj" \
         --arg hs_units "hs" \
         --argjson bus_numbers "$bus_ids" \
    '{hs: [.hashrate.threads[][0]], $hs_units, algo: .algo, $temp, $fan, uptime: .connection.uptime,
      ar: [$ac, $rj], $bus_numbers, ver: .version}' <<< "$stats_raw")
fi

  [[ -z $khs ]] && khs=0
  [[ -z $stats ]] && stats="null"
