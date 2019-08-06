	#!/usr/bin/env bash

max_tries=15
for (( i=1; i<=$max_tries; i++)); do
  stats_raw=`echo '{"id":0,"jsonrpc":"2.0","method":"miner_getstat1"}' | nc -w $API_TIMEOUT localhost $MINER_API_PORT | jq '.result'`
  [[ ! -z $stats_raw ]] && break
  sleep 0.5
done
[[ $i -gt 1 ]] && echo $i
if [[ -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner stats_raw from localhost:$MINER_API_PORT${NOCOLOR}"
else
	khs=`echo $stats_raw | jq -r '.[2]' | awk -F';' '{print $1/1000}'`
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
	local ver=`echo $stats_raw | jq -r '.[0]' | sed 's/TT-Miner\///'`
	
	stats=$(jq -n \
		--arg uptime "`echo \"$stats_raw\" | jq -r '.[1]' | awk '{print $1*60}'`" \
		--argjson hs "$hs" --arg hs_units "hs" \
		--argjson temp "$temp" --argjson fan "$fan" \
		--arg algo "$TT_MINER_ALGO" \
		--arg ac "$ac" --arg rj "$rj" \
		--arg ver "$ver" \
		'{$hs, $hs_units, $temp, $fan, $uptime, $algo, ar: [$ac, $rj], $ver}')
fi
