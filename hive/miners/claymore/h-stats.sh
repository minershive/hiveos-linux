#!/usr/bin/env bash


stats=`echo '{"id":0,"jsonrpc":"2.0","method":"miner_getstat2"}' | nc -w $API_TIMEOUT localhost $MINER_API_PORT | jq '.result'`
if [[ $? -ne 0  || -z $stats ]]; then
	echo -e "${YELLOW}Failed to read $miner stats from localhost:$MINER_API_PORT${NOCOLOR}"
else
	#[ "10.0 - ETH", "83", "67664;48;0", "28076;27236;12351", "891451;29;0", "421143;408550;61758", "67;40;70;45;69;34", "eth-eu1.nanopool.org:9999;sia-eu1.nanopool.org:7777", "0;0;0;0" ]
	khs=`echo $stats | jq -r '.[2]' | awk -F';' '{print $1}'`


	local MINER_VER=`miner_ver`
	algo=`cat /hive/miners/$MINER_NAME/$MINER_VER/config.txt | grep -m1 --text "^\-dcoin" | sed 's/-dcoin //'`

	stats=`echo "$stats" "[\"$algo\"]" | jq -s '.[0] + .[1]'` # push algo to end of array
fi
