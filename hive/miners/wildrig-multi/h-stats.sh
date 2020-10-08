#!/usr/bin/env bash

stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:${MINER_API_PORT}`

if [[ $? -ne 0 || -z $stats_raw ]]; then
  echo -e "${YELLOW}Failed to read $miner from localhost:${MINER_API_PORT}${NOCOLOR}"
  khs=0
  stats=''
else
  [[ `jq -r ".uptime" <<< $stats_raw` -lt 150 ]] && head -n 150 ${MINER_LOG_BASENAME}.log > ${MINER_LOG_BASENAME}_head.log

  local t_temp=$(jq '.temp' <<< $gpu_stats)
  local t_fan=$(jq '.fan' <<< $gpu_stats)
  local a_fans=
  local a_temp=

  local bus_numbers=`head -50 ${MINER_LOG_BASENAME}_head.log | grep 'busID' | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | cut -d '[' -f 3 | cut -d ' ' -f 2 | cut -d ']' -f 1`
  local all_bus_ids_array=(`echo "$gpu_detect_json" | jq -r '[ . | to_entries[] | select(.value) | .value.busid [0:2] ] | .[]'`)
  for bus_num in $bus_numbers; do
    for ((j = 0; j < ${#all_bus_ids_array[@]}; j++)); do
      if [[ "$(( 0x${all_bus_ids_array[$j]} ))" -eq "$bus_num" ]]; then
        a_fans+=$(jq .[$j] <<< $t_fan)" "
        a_temp+=$(jq .[$j] <<< $t_temp)" "
        break
      fi
    done
  done

  bus_numbers=`echo $bus_numbers | tr ' ' '\n' | jq -cs '.'`
  a_fans=`echo $a_fans | tr ' ' '\n' | jq -cs '.'`
  a_temp=`echo $a_temp | tr ' ' '\n' | jq -cs '.'`

  khs=`echo $stats_raw | jq -r '.hashrate.total[0]/1000'`
  stats=$(jq  --argjson temp "$a_temp" \
              --argjson fan  "$a_fans"  \
              --argjson bus_numbers "$bus_numbers" \
              '{hs: [.hashrate.threads[][0]], hs_units: "hs", $temp, $fan, uptime: .uptime, ar: [.results.shares_good, .results.shares_total - .results.shares_good], $bus_numbers, algo: .algo}' <<< $stats_raw)
fi

#echo $khs
#echo $stats
