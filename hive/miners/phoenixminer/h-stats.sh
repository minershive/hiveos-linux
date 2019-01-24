#!/usr/bin/env bash

stats_raw=`echo '{"id":0,"jsonrpc":"2.0","method":"miner_getstat2"}' | nc -w $API_TIMEOUT localhost ${MINER_API_PORT} | jq '.result'`
if [[ $? -ne 0  || -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner stats_raw from localhost:${MINER_API_PORT} ${NOCOLOR}"
else
	khs=`echo $stats_raw | jq -r '.[2]' | awk -F';' '{print $1}'`

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

	local hs=`echo "$stats_raw" | jq -r '.[3]' | tr ';' '\n' | jq -cs '.'`

	local ac=`echo $stats_raw | jq -r '.[2]' | awk -F';' '{print $2}'`
	local rj=`echo $stats_raw | jq -r '.[2]' | awk -F';' '{print $3}'`
	local ir=`echo $stats_raw | jq -r '.[8]' | awk -F';' '{print $1}'`
	local ir_gpu=`echo $stats_raw | jq '.[11]'`
	local ver=`echo $stats_raw | jq -r '.[0]'`
	local algo="ethash"
	[[ `echo $META | jq -r .phoenixminer.coin` == "UBQ" ]] && algo="ubiqhash"

	local uptime=`echo "$stats_raw" | jq -r '.[1]' | awk '{print $1*60}'`
	[[ $uptime -lt 60 ]] && head -n 50 $MINER_LOG_BASENAME.log > ${MINER_LOG_BASENAME}_head.log

	local bus_id=""
	local bus_ids=""
	local bus_str=""
	for (( i = 1; i <= `echo $fan | jq length`; i++ )); do
		#2018.12.22:13:38:35.674: main GPU1: GeForce GTX 1050 Ti (pcie 1), CUDA cap. 6.1, 3.9 GB VRAM, 6 CUs
		bus_str=`cat ${MINER_LOG_BASENAME}_head.log | grep "main GPU$i"`
		bus_id=`echo ${bus_str#*" (pcie "} | cut -d \) -f 1`
		bus_ids+=${bus_id}" "
	done

	stats=$(jq -n \
		--arg uptime "$uptime" \
		--argjson hs "$hs" --argjson temp "$temp" --argjson fan "$fan" \
		--arg ac "$ac" --arg rj "$rj" --arg ir "$ir" --argjson ir_gpu "$ir_gpu" \
		--arg algo "$algo" \
		--arg ver "$ver" \
		--argjson bus_numbers "`echo ${bus_ids[@]} | tr " " "\n" | jq -cs '.'`" \
		'{$hs, $temp, $fan, $uptime, $algo, ar: [$ac, $rj, $ir, $ir_gpu], $ver, $bus_numbers}')
fi

[[ -z $khs ]] && khs=0
[[ -z $stats ]] && stats="null"
