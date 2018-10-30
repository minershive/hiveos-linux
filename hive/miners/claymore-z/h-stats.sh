#!/usr/bin/env bash

stats=`echo '{"id":0,"jsonrpc":"2.0","method":"miner_getstat1"}' | nc -w $API_TIMEOUT localhost 3335 | jq '.result'`
if [[ $? -ne 0  || -z $stats ]]; then
	echo -e "${YELLOW}Failed to read $miner stats from localhost:3335${NOCOLOR}"
else
	khs=`echo $stats | jq -r '.[2]' | awk -F';' '{print $1/1000}'` #sols to khs
fi
