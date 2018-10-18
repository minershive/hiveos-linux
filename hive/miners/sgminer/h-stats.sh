#!/usr/bin/env bash

stats_raw=`echo '{"command":"summary+devs"}' | nc -w $API_TIMEOUT localhost ${MINER_API_PORT}`
if [[ $? -ne 0 || -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner from localhost:${MINER_API_PORT}${NOCOLOR}"
else
	khs=`echo $stats_raw | jq '.["summary"][0]["SUMMARY"][0]["KHS 15s"]'`
	stats=`echo $stats_raw | jq '{khs: [.devs[0].DEVS[]."KHS 15s"], temp: [.devs[0].DEVS[].Temperature], \
			fan: [.devs[0].DEVS[]."Fan Percent"], uptime: .summary[0].SUMMARY[0].Elapsed, algo: "'$SGMINER_GM_ALGO'"}'`
fi
