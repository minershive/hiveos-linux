#!/usr/bin/env bash

get_miner_uptime(){
  local a=0
  let a=`date +%s`-`stat --format='%Y' /run/hive/miners/noncerpro-opencl/miner.conf`
  echo $a
}

stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:${MINER_API_PORT}/api`
if [[ $? -ne 0 || -z $stats_raw ]]; then
  echo -e "${YELLOW}Failed to read $miner from ${WEB_HOST}:{$WEB_PORT}${NOCOLOR}"
else
  khs=`echo $stats_raw | jq -r '.totalHashrate' | awk '{s+=$1} END {print s/1000}'` #"
  local ac=$(jq -r '.totalShares - .invalidShares' <<< "$stats_raw")
  local inv=$(jq -r '.invalidShares' <<< "$stats_raw")

  local uptime=`get_miner_uptime`
  local algo="argon2d-nim"

  local temp=$(jq "[.temp$amd_indexes_array]" <<< $gpu_stats)
  local fan=$(jq "[.fan$amd_indexes_array]" <<< $gpu_stats)

  stats=$(jq --arg ac "$ac" --arg inv "$inv" \
         --arg algo "$algo" \
         --arg ver `miner_ver` --arg uptime "$uptime" \
         --argjson fan "$fan" --argjson temp "$temp" \
        '{hs: [.devices[].hashrate], hs_units: "hs", $algo, $temp,
        $fan, $uptime, ar: [$ac, 0, $inv], $ver}' <<< "$stats_raw")
fi

  [[ -z $khs ]] && khs=0
  [[ -z $stats ]] && stats="null"
