#!/usr/bin/env bash

	#@see https://www.bminer.me/references/
	stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://${MINER_API_HOST}:${MINER_API_PORT}/api/status`
	if [[ $? -ne 0 || -z $stats_raw ]]; then
		echo -e "${YELLOW}Failed to read $miner from ${MINER_API_HOST}:{$MINER_API_PORT}${NOCOLOR}"
	else
	#fucking bminer sorts it's keys as numerics, not natual, e.g. "1", "10", "11", "2", fix that with sed hack by replacing "1": with "01":
	stats_raw=$(echo "$stats_raw" | sed -E 's/"([0-9])":\s*\{/"0\1":\{/g' | jq -c --sort-keys .) #"

	khs=`echo $stats_raw | jq '.miners[].solver.solution_rate' | awk '{s+=$1} END {print s/1000}'` #"

	local uptime=$(( `date +%s` - $(jq '.start_time' <<< "$stats_raw") ))
	local hs_units="hs"
	[[ -z $BMINER_ALGO ]] && BMINER_ALGO="ethash"
	
	local bus_numbers=$(echo $stats_raw | jq -r '[ .miners | to_entries[] | select(.value) | .key|tonumber ]')
	
	stats=$(jq -c --arg uptime "$uptime" \
				--arg algo "$BMINER_ALGO" \
				--arg hs_units "$hs_units" \
				--argjson hs "`echo ${hs[@]} | tr " " "\n" | jq -cs '.'`" \
				--argjson bus_numbers "$bus_numbers" \
				'{hs: [.miners[].solver.solution_rate], $hs_units,
						temp: [.miners[].device.temperature], fan: [.miners[].device.fan_speed], $uptime, $algo,
						ar: [.stratum.accepted_shares, .stratum.rejected_shares], $bus_numbers}' <<< "$stats_raw")
	fi

	[[ -z $khs ]] && khs=0
	[[ -z $stats ]] && stats="null"
