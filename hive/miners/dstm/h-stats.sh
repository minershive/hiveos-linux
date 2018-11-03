#!/usr/bin/env bash

stats_raw=`echo '{"id":1, "method":"getstat"}' | nc -w $API_TIMEOUT localhost ${MINER_API_PORT}`
if [[ $? -ne 0 || -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner from localhost:${MINER_API_PORT}${NOCOLOR}"
else
	khs=`echo $stats_raw | jq '.result[].sol_ps' | awk '{s+=$1} END {print s/1000}'`
	local uptime=$(( `date +%s` - $(stat -c%X /proc/`pidof zm`) )) #dont think zm will die so soon after getting stats
#				local fan=$(jq -c "[.fan$nvidia_indexes_array]" <<< $gpu_stats)
#				local temp=$(jq -c "[.temp$nvidia_indexes_array]" <<< $gpu_stats)
	local temp=$(jq -c '[.result[].temperature]' <<< "$stats_raw")
	local ac=`echo $stats_raw | jq '[.result[].accepted_shares] | add'`
	local rj=`echo $stats_raw | jq '[.result[].rejected_shares] | add'`

	#All fans speed array
	local fan=$(jq -r ".fan | .[]" <<< "$gpu_stats")
	#DSTM's busid array
	local bus_id_array=$(jq -r '.result[].gpu_pci_bus_id' <<< "$stats_raw")
	local bus_numbers=$(echo "$bus_id_array" | awk '{printf("%d\n", "0x"$1)}' | jq -sc .)
	#All busid array
	local all_bus_ids_array=(`echo "$gpu_detect_json" | jq -r '[ . | to_entries[] | select(.value) | .value.busid [0:2]] | .[]'`)
	#Formating arrays
	bus_id_array=`sed 's/\n/ /' <<< $bus_id_array`
	fan=`sed 's/\n/ /' <<< $fan`
	IFS=', ' read -r -a bus_id_array <<< "$bus_id_array"
	IFS=' ' read -r -a fan <<< "$fan"

	#busid equality
	local fans_array=
	for ((i = 0; i < ${#all_bus_ids_array[@]}; i++)); do
		for ((j = 0; j < ${#bus_id_array[@]}; j++)); do
			if [[ "$(( 0x${all_bus_ids_array[$i]} ))" -eq "${bus_id_array[$j]}" ]]; then
				fans_array+=("${fan[$i]}")
			fi
		done
	done

	stats=$(jq --argjson temp "$temp" --argjson fan "`echo "${fans_array[@]}" | jq -s . | jq -c .`" \
		--arg uptime "$uptime" --arg ac "$ac" --arg rj "$rj" --argjson bus_numbers "$bus_numbers" \
		'{ hs: [.result[].sol_ps], $temp, $fan, $uptime, ar: [$ac, $rj], $bus_numbers }' <<< "$stats_raw")
fi
