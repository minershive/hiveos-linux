#!/usr/bin/env bash
stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://localhost:${MINER_API_PORT}/api`
if [[ $? -ne 0  || -z $stats_raw ]]; then
  echo -e "${YELLOW}Failed to read $miner stats from localhost:${MINER_API_PORT}${NOCOLOR}"
else
  algo="argon2d-nim"
  ver=`echo $stats_raw | jq -r '.version' | cut -d " " -f 3-`

  stats=$(jq -c --arg algo "$algo" \
                --arg hs_units "hs" \
                --arg ver "$ver" \
                --argjson gpu_stats "$gpu_stats" \
                '{ total_khs: (.totalHashrate | floor / 1000), hs: (.hashrates | map(. | floor)), hs_units: "hs",
                temp: $gpu_stats.temp, fan: $gpu_stats.fan, uptime, $ver, ar: [.shares - .errors, .errors], $algo}' <<< "$stats_raw")
  khs=$(jq -r '.total_khs' <<< "$stats")
fi

[[ -z $stats ]] && stats="null"
[[ -z $khs ]] && khs=0
