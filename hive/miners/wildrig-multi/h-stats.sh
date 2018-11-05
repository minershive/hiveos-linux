#!/usr/bin/env bash

stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:${MINER_API_PORT}`

if [[ $? -ne 0 || -z $stats_raw ]]; then
    echo -e "${YELLOW}Failed to read $miner from localhost:${MINER_API_PORT}${NOCOLOR}"
    khs=0
    stats=''
else
    local fan=$(jq -c "[.fan$amd_indexes_array]" <<< $gpu_stats)
    local temp=$(jq -c "[.temp$amd_indexes_array]" <<< $gpu_stats)
    khs=`echo $stats_raw | jq -r '.hashrate.total[0]/1000'`
    stats=$(jq  --argjson temp "$temp" \
		--argjson fan  "$fan"  \
		'{hs: [.hashrate.threads[][0]], hs_units: "hs", $temp, $fan, uptime: .uptime, ar: [.results.shares_good, .results.shares_total - .results.shares_good], algo: .algo}' <<< $stats_raw)
fi

#echo $khs
#echo $stats
