#!/usr/bin/env bash

stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:${MINER_API_PORT}/api/v1`
if [[ $? -ne 0 || -z $stats_raw ]]; then
  echo -e "${YELLOW}Failed to read $miner from 127.0.0.1:{$MINER_API_PORT}${NOCOLOR}"
else
  khs=`echo $stats_raw | jq '.miner[0].devices[].ae_hash' | awk '{s+=$1} END {print s/1000}'`

  local uptime=$(( `date +%s` - $(jq '.miner[0].start_time' <<< "$stats_raw") ))
  local bus_numbers=`echo $stats_raw | jq -r ".miner[0].devices[].pci" | cut -f 1 -d ':' | jq -sc .`

  stats=$(jq -c --arg uptime "$uptime" \
          --arg algo "cuckoo" \
          --arg hs_units "hs" \
          --argjson bus_numbers "$bus_numbers" \
          --arg ver "$(miner_ver)" \
          '{hs: [.miner[0].devices[].ae_hash], $hs_units,
            temp: [.miner[0].devices[].temp], fan: [.miner[0].devices[].fan], $uptime, $algo,
            ar: [.miner[0].ae_accept, .miner[0].ae_rejected], $ver}' <<< "$stats_raw")
fi

[[ -z $khs ]] && khs=0
[[ -z $stats ]] && stats="null"
