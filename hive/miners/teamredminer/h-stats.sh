#!/usr/bin/env bash

stats_raw=`echo '{"command":"summary+devs"}' | nc -w $API_TIMEOUT localhost ${MINER_API_PORT}`
if [[ $? -ne 0 || -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner from localhost:${MINER_API_PORT}${NOCOLOR}"
else
	[[ -z $CUSTOM_ALGO ]] && CUSTOM_ALGO="lyra2z"

	khs=`echo $stats_raw | jq '."summary"."SUMMARY"[0]."KHS 30s"'`

	local t_temp=$(jq '.temp' <<< $gpu_stats)
	local t_fan=$(jq '.fan' <<< $gpu_stats)

	# [[ $cpu_indexes_array != '[]' ]] && #remove Internal Gpus
	# 	t_temp=$(jq -c "del(.$cpu_indexes_array)" <<< $t_temp) &&
	# 	t_fan=$(jq -c "del(.$cpu_indexes_array)" <<< $t_fan)

	local bus_ids=""
	local a_fans=""
	local a_temp=""

	local ver=`echo $stats_raw | jq -r .summary.STATUS[0].Description | awk '{ printf $2 }'`

	if [ $ver \< "0.3.8" ]; then #won't work if ver >= 10 (0.3.10 etc.)
		local bus_no=$(jq .devs.DEVS[]."GPU" <<< "$stats_raw")
		local all_bus_ids_array=(`echo "$gpu_detect_json" | jq -r '[ . | to_entries[] | select(.value) | .value.busid [0:2] ] | .[]'`)
		for ((i = 0; i < `echo $bus_no | awk "{ print NF }"`; i++)); do
			bus_id=`head -n 40 ${MINER_LOG_BASENAME}.log | grep "Successfully initialized GPU $i" | awk '{ printf $12"\n" }' | cut -d ':' -f 1`
			bus_id=$(( 0x${bus_id} ))
			bus_ids+=${bus_id}" "
			for ((j = 0; j < ${#all_bus_ids_array[@]}; j++)); do
				if [[ "$(( 0x${all_bus_ids_array[$j]} ))" -eq "$bus_id" ]]; then
					a_fans+=$(jq .[$j] <<< $t_fan)" "
					a_temp+=$(jq .[$j] <<< $t_temp)" "
				fi
			done
		done
	else
		local bus_no=$(jq .devs.DEVS[]."GPU" <<< "$stats_raw")
		for ((i = 0; i < `echo $bus_no | awk "{ print NF }"`; i++)); do
			bus_id=`head -n 40 ${MINER_LOG_BASENAME}.log | grep "Successfully initialized GPU $i" | awk '{ printf $12"\n" }' | cut -d ':' -f 1`
			bus_id=$(( 0x${bus_id} ))
			bus_ids+=${bus_id}" "
		done
		a_temp=$(jq '.devs.DEVS[].Temperature' <<< "$stats_raw")
		a_fans=$(jq '.devs.DEVS[]."Fan Percent"' <<< "$stats_raw")
	fi

	local ac=$(jq '."summary"."SUMMARY"[0]."Accepted"' <<< "$stats_raw")
	local rj=$(jq '."summary"."SUMMARY"[0]."Rejected"' <<< "$stats_raw")



	stats=$(jq \
		--argjson fan "`echo ${a_fans[@]} | tr " " "\n" | jq -cs '.'`" \
		--argjson temp "`echo ${a_temp[@]} | tr " " "\n" | jq -cs '.'`" \
		--argjson bus_numbers "`echo ${bus_ids[@]} | tr " " "\n" | jq -cs '.'`" \
		--arg ac "$ac" --arg rj "$rj" --arg algo "$TEAMREDMINER_ALGO" \
		--arg ver "$ver" \
		'{hs: [.devs.DEVS[]."KHS 30s"], $algo, $temp, $fan,
		  uptime: .summary.SUMMARY[0].Elapsed, ar: [$ac, $rj], $bus_numbers,
		  $ver}' <<< "$stats_raw")
fi

	[[ -z $khs ]] && khs=0
	[[ -z $stats ]] && stats="null"
