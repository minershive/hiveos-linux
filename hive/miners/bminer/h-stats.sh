#!/usr/bin/env bash

#@see https://www.bminer.me/references/
stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:1880/api/status`
if [[ $? -ne 0 || -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner from localhost:1880${NOCOLOR}"
else
	#fucking bminer sorts it's keys as numerics, not natual, e.g. "1", "10", "11", "2", fix that with sed hack by replacing "1":{ with "01":{
	stats_raw=$(echo "$stats_raw" | sed -E 's/"([0-9])":\s*\{/"0\1":\{/g' | jq -c --sort-keys .)

	khs=`echo $stats_raw | jq '.miners[].solver.solution_rate' | awk '{s+=$1} END {print s/1000}'`
	##bminer did not report fans and uptime before 5.5.0
	##local uptime=$(( `date +%s` - $(stat -c%X /proc/`pidof bminer | awk '{print $1}'`) )) #in seconds
	##local temp=$(jq -c "[.temp$nvidia_indexes_array]" <<< $gpu_stats)
	##local fan=$(jq -c "[.fan$nvidia_indexes_array]" <<< $gpu_stats)

	local uptime=$(( `date +%s` - $(jq '.start_time' <<< "$stats_raw") ))
	#local temp=$(jq -c '[.miners[].device.temperature]' <<< "$stats_raw")
	#local fan=$(jq -c '[.miners[].device.fan_speed]' <<< "$stats_raw")
	#local hs=$(jq -c "[.miners[].solver.solution_rate]" <<< "$stats_raw")
	#stats=$(jq --argjson fan "$fan" --arg uptime "$uptime" '{hs: [.miners[].solver.solution_rate], temp: [.miners[].device.temperature], $fan, $uptime}' <<< $stats_raw)
	#--argjson hs "$hs" --argjson temp "$temp" --argjson fan "$fan"
	stats=$(jq -c --arg uptime "$uptime" \
		'{hs: [.miners[].solver.solution_rate],
				temp: [.miners[].device.temperature], fan: [.miners[].device.fan_speed], $uptime,
				ar: [.stratum.accepted_shares, .stratum.rejected_shares]}' <<< "$stats_raw")
fi
