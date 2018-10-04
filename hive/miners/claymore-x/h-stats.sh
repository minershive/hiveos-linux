#!/usr/bin/env bash

stats=`echo '{"id":0,"jsonrpc":"2.0","method":"miner_getstat1"}' | nc -w $API_TIMEOUT localhost $MINER_API_PORT | jq '.result'`
if [[ $? -ne 0  || -z $stats ]]; then
	echo -e "${YELLOW}Failed to read $miner stats from localhost:$MINER_API_PORT${NOCOLOR}"
else
	khs=`echo $stats | jq -r '.[2]' | awk -F';' '{print $1/1000}'` #sols to khs

	local MINER_VER=`miner_ver`
	cat /hive/miners/$MINER_NAME/$MINER_VER/config.txt | grep -q '^\-pow7 1$' && algo=cryptonight-v7 || algo=cryptonight

	stats=`echo "$stats" "[\"$algo\"]" | jq -s '.[0] + .[1]'` # push algo to end of array
fi
