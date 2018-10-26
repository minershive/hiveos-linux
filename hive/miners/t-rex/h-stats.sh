#!/usr/bin/env bash

#algo_avail=("balloon" "bcd" "bitcore" "c11" "hmq1725" "hsr" "lyra2z" "phi" "polytimos" "renesis" "sha256t" "skunk" "sonoa" "timetravel" "tribus" "x16r" "x16s" "x17")

stats_raw=`echo 'summary' | nc -w $API_TIMEOUT localhost $MINER_API_PORT`

if [[ $? -ne 0 ]]; then
	echo -e "${YELLOW}Failed to read miner stats from localhost:${API_PORT}${NOCOLOR}"
	stats=""
	khs=0
else
	stats=$(jq '{hs: [.gpus[].hashrate], hs_units: "hs", temp: [.gpus[].temperature], fan: [.gpus[].fan_speed], uptime: .uptime, ar: [.accepted_count, .rejected_count], bus_numbers:[.gpus[].gpu_id], algo: .algorithm}' <<< $stat_raw)
	khs=$(jq ".hashrate/1000" <<< $stat_raw)
fi
