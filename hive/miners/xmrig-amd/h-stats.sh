#!/usr/bin/env bash

stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:$MINER_API_PORT/api.json`
if [[ $? -ne 0 || -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner from localhost:${MINER_API_PORT}${NOCOLOR}"
else
	[[ -z $XMRIG_AMD_ALGO ]] && XMRIG_AMD_ALGO="cryptonight"

	khs=`echo $stats_raw | jq -r '.hashrate.total[0]' | awk '{print $1/1000}'`
	local temp=$(jq '.temp' <<< $gpu_stats)
	local fan=$(jq '.fan' <<< $gpu_stats)
	local ac=$(jq '.results.shares_good' <<< "$stats_raw")
	local rj=$(( $(jq '.results.shares_total' <<< "$stats_raw") - $ac ))
	stats=$(jq --argjson temp "$temp" --argjson fan "$fan" --arg ac "$ac" --arg rj "$rj" --arg algo "$XMRIG_AMD_ALGO" \
		'{hs: [.hashrate.threads[][0]], $algo, $temp, $fan, uptime: .connection.uptime, ar: [$ac, $rj]}' <<< "$stats_raw")
fi

	[[ -z $khs ]] && khs=0
	[[ -z $stats ]] && stats="null"
