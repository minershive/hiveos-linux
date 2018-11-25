#!/usr/bin/env bash


#0000:03:00.0, .result[].busid[5:] trims first 5 chars
#stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://localhost:42000/getstat`
#curl uses http_proxy env var, we don't need it. --noproxy does not work
stats_raw=`echo "GET /getstat" | nc -w $API_TIMEOUT localhost $MINER_API_PORT | tail -n 1`
if [[ $? -ne 0  || -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner stats from localhost:$MINER_API_PORT${NOCOLOR}"
else
	khs=`echo $stats_raw | jq -r '.result[].speed_sps' | awk '{s+=$1} END {print s/1000}'` #sum up and convert to khs
	local ac=$(jq '[.result[].accepted_shares] | add' <<< "$stats_raw")
	local rj=$(jq '[.result[].rejected_shares] | add' <<< "$stats_raw")

	#All fans speed array
	local fan=$(jq -r ".fan | .[]" <<< $gpu_stats)
	#EWBF's busid array
	local bus_id_array=$(jq -r '[.result[].busid[5:7]] | .[]' <<< "$stats_raw")
	local bus_numbers=$(echo "$bus_id_array" | awk '{printf("%d\n", "0x"$1)}' | jq -sc .)
	#All busid array
	local all_bus_ids_array=(`echo "$gpu_detect_json" | jq -r '[ . | to_entries[] | select(.value) | .value.busid [0:2] ] | .[]'`)
	#Formating arrays
	bus_id_array=`sed 's/\n/ /' <<< $bus_id_array`
	fan=`sed 's/\n/ /' <<< $fan`
	IFS=' ' read -r -a bus_id_array <<< "$bus_id_array"
	IFS=' ' read -r -a fan <<< "$fan"
	#busid equality
	local fans_array=
	for ((i = 0; i < ${#all_bus_ids_array[@]}; i++)); do
		for ((j = 0; j < ${#bus_id_array[@]}; j++)); do
			if [[ "$(( 0x${all_bus_ids_array[$i]} ))" -eq "$(( 0x${bus_id_array[$j]} ))" ]]; then
				fans_array+=("${fan[$i]}")
			fi
		done
	done

	local uptime=$(( `date +%s` - $(jq '.result[0].start_time' <<< "$stats_raw") ))
	[[ -z $EWBF_ALGO ]] && EWBF_ALGO="equihash"

#				stats=$(jq -c --arg uptime "$uptime" --arg ac "$ac" --arg rj "$rj" --arg algo "$EWBF_ALGO"  \
#						--argjson fan "`echo "${fans_array[@]}" | jq -s . | jq -c .`" \
#					'{hs: [.result[].speed_sps], temp: [.result[].temperature], $fan,
#						$uptime, ar: [$ac, $rj]}' <<< "$stats_raw")
	#busid: [.result[].busid[5:]|ascii_downcase]

#				local fan=$(jq -c "[.fan$nvidia_indexes_array]" <<< $gpu_stats)
	local temp=$(jq -c "[.temp$nvidia_indexes_array]" <<< $gpu_stats)

	stats=$(jq -c --argjson temp "$temp" --argjson fan "`echo "${fans_array[@]}" | jq -s . | jq -c .`" \
			--arg uptime "$uptime" --arg ac "$ac" --arg rj "$rj" \
			--argjson bus_numbers "$bus_numbers" --arg algo "$EWBF_ALGO"  \
			--arg ver `miner_ver` \
		'{hs: [.result[].speed_sps], $temp, $fan,
			$uptime, ar: [$ac, $rj], $bus_numbers, $algo, $ver}' <<< "$stats_raw")
fi
