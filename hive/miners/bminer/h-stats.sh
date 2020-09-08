#!/usr/bin/env bash

. /hive-config/wallet.conf

	#@see https://www.bminer.me/references/
	stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:${MINER_API_PORT}/api/status`
	if [[ $? -ne 0 || -z $stats_raw ]]; then
		echo -e "${YELLOW}Failed to read $miner from 127.0.0.1:{$MINER_API_PORT}${NOCOLOR}"
	else
		#fucking bminer sorts it's keys as numerics, not natual, e.g. "1", "10", "11", "2", fix that with sed hack by replacing "1": with "01":
		stats_raw=$(echo "$stats_raw" | sed -E 's/"([0-9])":\s*\{/"0\1":\{/g' | jq -c --sort-keys .) #"

		khs=`echo $stats_raw | jq '.miners[].solver.solution_rate' | awk '{s+=$1} END {printf("%.4f",s/1000)}'` #"

		local uptime=$(( `date +%s` - $(jq '.start_time' <<< "$stats_raw") ))
		local hs_units="hs"
		[[ -z $BMINER_ALGO ]] && BMINER_ALGO="stratum"

		local dev_numbers=$(echo $stats_raw | jq -r '[ .miners | to_entries[] | select(.value) | .key|tonumber ]') #'
		local bus_numbers=$(echo $gpu_detect_json | jq -r ".$dev_numbers.busid" |  awk '{printf("%d\n", "0x"$1)}' | jq -cs '.') #'

		devices_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:${MINER_API_PORT}/api/v1/status/solver`
		#fucking bminer sorts it's keys as numerics, not natual, e.g. "1", "10", "11", "2", fix that with sed hack by replacing "1": with "01" once again:
		devices_raw=$(echo "$devices_raw" | sed -E 's/"([0-9])":\s*\{/"0\1":\{/g' | jq -c --sort-keys .) #"

		local hs2=`echo $devices_raw | jq -r .devices[].solvers[1].speed_info.hash_rate`
		local hs_units2="hs"
		khs2=`echo "$hs2" | awk '{s+=$1} END {print s/1000}'` #"

		if [[ ! -z $BMINER_URL2 ]]; then
			#dual mode
			stratum_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:${MINER_API_PORT}/api/v1/status/stratum`
			#fucking bminer sorts it's keys as numerics, not natual, e.g. "1", "10", "11", "2", fix that with sed hack by replacing "1": with "01" once again
			stratum_raw=$(echo "$stratum_raw" | sed -E 's/"([0-9])":\s*\{/"0\1":\{/g' | jq -c --sort-keys .) #"
			local ac2=$(jq '.stratums.'${BMINER_ALGO2}'.accepted_shares' <<< "$stratum_raw")
			local rj2=$(jq '.stratums.'${BMINER_ALGO2}'.rejected_shares' <<< "$stratum_raw")

			stats=$(jq -c --arg uptime "$uptime" \
						--arg algo "$BMINER_ALGO" \
						--arg hs_units "$hs_units" \
						--arg algo2 "$BMINER_ALGO2" \
						--arg hs_units2 "$hs_units2" \
						--arg ac2 "$ac2" --arg rj2 "$rj2" \
						--argjson hs2 "`echo ${hs2[@]} | tr " " "\n" | jq -cs '.'`" \
						--arg total_khs "$khs" \
						--arg total_khs2 "$khs2" \
						--argjson bus_numbers "$bus_numbers" --argjson bus_numbers2 "$bus_numbers" \
						'{$total_khs, hs: [.miners[].solver.solution_rate], $hs_units,
							temp: [.miners[].device.temperature], fan: [.miners[].device.fan_speed], $uptime, $algo,
							ar: [.stratum.accepted_shares, .stratum.rejected_shares], $bus_numbers,
							$total_khs2, $hs2, $hs_units2, $algo2, ar2: [$ac2, $rj2], $bus_numbers2,
							ver: .version}' <<< "$stats_raw")
		else
			#single mode
			stats=$(jq -c --arg uptime "$uptime" \
						--arg algo "$BMINER_ALGO" \
						--arg hs_units "$hs_units" \
						--arg total_khs "$khs" \
						--argjson bus_numbers "$bus_numbers" \
						'{$total_khs, hs: [.miners[].solver.solution_rate], $hs_units,
							temp: [.miners[].device.temperature], fan: [.miners[].device.fan_speed], $uptime, $algo,
							ar: [.stratum.accepted_shares, .stratum.rejected_shares], $bus_numbers,
							ver: .version}' <<< "$stats_raw")
		fi

	fi

	[[ -z $khs ]] && khs=0
	[[ -z $stats ]] && stats="null"
