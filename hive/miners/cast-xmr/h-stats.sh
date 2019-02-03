#!/usr/bin/env bash

stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:$MINER_API_PORT`
if [[ $? -ne 0 || -z $stats_raw ]]; then
  echo -e "${YELLOW}Failed to read $miner from localhost:${MINER_API_PORT}${NOCOLOR}"
else
  khs=`echo $stats_raw | jq -r '.total_hash_rate' | awk '{print $1/1000000}'`
  local temp=$(jq "[.temp$amd_indexes_array]" <<< $gpu_stats)
  local fan=$(jq "[.fan$amd_indexes_array]" <<< $gpu_stats)


  local ac=$(jq '."shares"."num_accepted"' <<< "$stats_raw")
  local rj=$(jq '."shares"."num_rejected"' <<< "$stats_raw")
  local iv=$(jq '."shares"."num_invalid"' <<< "$stats_raw")

  local hs=`echo $stats_raw | jq -r '.devices[].hash_rate' | awk '{print $1/1000}' | tr ' ' '\n' | jq -cs '.'`

  stats=$(jq --arg ac "$ac" --arg rj "$rj" --arg iv "$iv" \
         --arg algo "$CAST_XMR_ALGO" --argjson hs "$hs" \
         --arg ver `miner_ver` \
         --argjson fan "$fan" \
        '{$hs, hs_units: "hs", $algo, temp: [.devices[].gpu_temperature],
        $fan, uptime: .pool.online,
        ar: [$ac, $rj, $iv], $ver}' <<< "$stats_raw")

fi

  [[ -z $khs ]] && khs=0
  [[ -z $stats ]] && stats="null"

#echo $fan | jq