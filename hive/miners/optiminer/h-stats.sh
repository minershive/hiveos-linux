#!/usr/bin/env bash

stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://localhost:52749`
if [[ $? -ne 0 || -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner from localhost:52749${NOCOLOR}"
else
	#optiminer sorts it's keys incorrectly, e.g. "GPU1", "GPU10", "GPU2", fixing that with sed hack by replacing "1":{ with "01":{
	stats_raw=$(echo "$stats_raw" | sed -E 's/"GPU([0-9])"/"GPU0\1"/g' | jq -c --sort-keys .)
	khs=`echo $stats_raw | jq '.solution_rate.Total."60s"' | awk '{print $1/1000}'`
	local uptime=`echo $stats_raw | jq '.uptime'`
	local hs=$(jq -c '[.solution_rate[]."60s"]' <<< "$stats_raw" | sed -E "s/^(\[.*)(,[0-9]+\.[0-9]+)]$/\1]/")
	[[ -z $OPTIMINER_ALGORITHM ]] && OPTIMINER_ALGORITHM="equihash96_5"

	#TODO: check on mixed rig, maybe amd first, then nvidia
	local temp=$(jq '.temp' <<< $gpu_stats)
	local fan=$(jq '.fan' <<< $gpu_stats)
	[[ $cpu_indexes_array != '[]' ]] && #remove Internal Gpus
		temp=$(jq -c "del(.$cpu_indexes_array)" <<< $temp) &&
		fan=$(jq -c "del(.$cpu_indexes_array)" <<< $fan)

	stats=$(jq -nc --arg algo "$OPTIMINER_ALGORITHM" --argjson hs "$hs" --argjson temp "$temp" --argjson fan "$fan" --arg uptime "$uptime" '{$algo, $hs, $temp, $fan, $uptime}')
fi
