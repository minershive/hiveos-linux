#!/usr/bin/env bash

stats_raw=`echo '{"id":0,"jsonrpc":"2.0","method":"miner_getstat2"}' | nc -w $API_TIMEOUT localhost ${MINER_API_PORT} | jq '.result'`
if [[ $? -ne 0  || -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner stats_raw from localhost:${MINER_API_PORT} ${NOCOLOR}"
else
	local tempfans=`echo $stats_raw | jq -r '.[6]' | tr ';' ' '`
	local temp=()
	local fan=()
	local tfcounter=0
	for tf in $tempfans; do
		(( $tfcounter % 2 == 0 )) &&
			temp+=($tf) ||
			fan+=($tf)
		((tfcounter++))
	done
	temp=`printf '%s\n' "${temp[@]}" | jq --raw-input . | jq --slurp -c .`
	fan=`printf '%s\n' "${fan[@]}" | jq --raw-input . | jq --slurp -c .`

	local ver=`echo $stats_raw | jq -r '.[0]'`
	local uptime=`echo "$stats_raw" | jq -r '.[1]' | awk '{print $1*60}'`
	local bus_numbers=`echo $stats_raw | jq -r '.[15]' | tr ";" ","`

	local algo="ethash"
	khs=`echo $stats_raw | jq -r '.[2]' | awk -F';' '{print $1}'`
	if [[ $khs -gt 0 ]]; then
		local hs=`jq -rc '[ .[3]|split(";")|.[]|if .=="off" then 0 elif .=="stopped" then 0 else .|tonumber end ]' <<< $stats_raw`
		local ac=`echo $stats_raw | jq -r '.[2]' | awk -F';' '{print $2}'`
		local rj=`echo $stats_raw | jq -r '.[2]' | awk -F';' '{print $3}'`
		local ir=`echo $stats_raw | jq -r '.[8]' | awk -F';' '{print $1}'`
		local ir_gpu=`echo $stats_raw | jq '.[11]'`
	fi

	khs_2=`echo $stats_raw | jq -r '.[4]' | awk -F';' '{print $1}'`
	if [[ $khs_2 -gt 0 ]]; then # Miner is in dual mode!
		algo2=$DCOIN
		local hs2=`jq -rc '[ .[5]|split(";")|.[]|if .=="off" then 0 else .|tonumber end ]' <<< $stats_raw`
		local ac2=`echo $stats_raw | jq -r '.[4]' | awk -F';' '{print $2}'`
		local rj2=`echo $stats_raw | jq -r '.[4]' | awk -F';' '{print $3}'`
		local ir2=`echo $stats_raw | jq -r '.[8]' | awk -F';' '{print $3}'`
		local ir2_gpu=`echo $stats_raw | jq '.[14]'`

		stats=$(jq -n \
			--argjson hs "$hs" --argjson temp "$temp" --argjson fan "$fan" \
			--arg ac "$ac" --arg rj "$rj" --arg ir "$ir" --argjson ir_gpu "$ir_gpu" \
			--arg algo "$algo" \
			--argjson hs2 "$hs2" \
			--arg ac2 "$ac2" --arg rj2 "$rj2" --arg ir2 "$ir2" --argjson ir2_gpu "$ir2_gpu" \
			--arg algo2 "$algo2" \
			--arg ver "$ver" \
			--argjson bus_numbers "[${bus_numbers}]" \
			'{"total_khs":'$khs', $hs, $temp, $fan, "uptime":'$uptime', $algo, ar: [$ac, $rj, $ir, $ir_gpu], $ver, $bus_numbers,
				'"total_khs2":$khs_2', $hs2, $algo2, ar2:[$ac2, $rj2, $ir2, $ir2_gpu]}')
	else
		# Mine is in solo mode
		stats=$(jq -n \
			--argjson hs "$hs" --argjson temp "$temp" --argjson fan "$fan" \
			--arg ac "$ac" --arg rj "$rj" --arg ir "$ir" --argjson ir_gpu "$ir_gpu" \
			--arg algo "$algo" \
			--arg ver "$ver" \
			--argjson bus_numbers "[${bus_numbers}]" \
			'{"total_khs":'$khs', $hs, $temp, $fan, "uptime":'$uptime', $algo, ar: [$ac, $rj, $ir, $ir_gpu], $ver, $bus_numbers}')
	fi

fi

[[ -z $khs ]] && khs=0
[[ -z $stats ]] && stats="null"
