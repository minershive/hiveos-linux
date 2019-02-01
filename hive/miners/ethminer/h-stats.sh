#!/usr/bin/env bash


stats_raw=`echo '{"id":0,"jsonrpc":"2.0","method":"miner_getstat1"}' | nc -w $API_TIMEOUT localhost $MINER_API_PORT | jq '.result'`
if [[ $? -ne 0  || -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner stats_raw from localhost:$MINER_API_PORT${NOCOLOR}"
else
	khs=`echo $stats_raw | jq -r '.[2]' | awk -F';' '{print $1}'`
	#`echo $stats_raw | jq -r '.[3]' | awk 'gsub(";", "\n")' | jq -cs .` #send only hashes
	local tempfans=`echo $stats_raw | jq -r '.[6]' | tr ';' ' '` #"56 26  48 42"
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

	#ethminer API can show hashes, but no load... hard to fix it here
	#local hs=(`echo "$stats_raw" | jq -r '.[3]' | tr ';' ' '`)
	#echo ${hs[0]}

	local hs=`echo "$stats_raw" | jq -r '.[3]' | tr ';' '\n' | jq -cs '.'`

	local ac=`echo $stats_raw | jq -r '.[2]' | awk -F';' '{print $2}'`
	local rj=`echo $stats_raw | jq -r '.[2]' | awk -F';' '{print $3}'`
	local ver=`echo $stats_raw | jq -r '.[0]'`

	local algo="ethash"
	[[ $ETHMINER_FORK == "progpow" ]] && algo="progpow"
	[[ $ETHMINER_FORK == "ubqminer" ]] && algo="ubiqhash"
	[[ $ETHMINER_FORK == "zilminer" ]] && algo="zilliqahash"
	stats=$(jq -n \
		--arg uptime "`echo \"$stats_raw\" | jq -r '.[1]' | awk '{print $1*60}'`" \
		--argjson hs "$hs" --argjson temp "$temp" --argjson fan "$fan" \
		--arg algo "$algo" \
		--arg ac "$ac" --arg rj "$rj" \
		--arg ver "$ver" \
		'{$hs, $temp, $fan, $uptime, $algo, ar: [$ac, $rj], $ver}')
		#TODO: bus_numbers
fi
