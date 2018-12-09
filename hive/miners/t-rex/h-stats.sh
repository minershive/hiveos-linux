#!/usr/bin/env bash

#algo_avail=("balloon" "bcd" "bitcore" "c11" "hmq1725" "hsr" "lyra2z" "phi" "polytimos" "renesis" "sha256t" "skunk" "sonoa" "timetravel" "tribus" "x16r" "x16s" "x17")

stat_raw=`echo 'summary' | nc -w $API_TIMEOUT localhost $MINER_API_PORT`

if [[ $? -ne 0 ]]; then
	echo -e "${YELLOW}Failed to read miner stats from localhost:${MINER_API_PORT}${NOCOLOR}"
else
	local gpu_worked=`echo $stat_raw | jq '.gpus[].gpu_id'`
	local gpu_busid=(`cat /var/run/hive/gpu-detect.json | jq -r '.[] | select(.brand=="nvidia") | .busid' | cut -d ':' -f 1`)
	local busids=''
	local idx=0
	for i in $gpu_worked; do
		gpu=${gpu_busid[$i]}
		busids[idx]=$((16#$gpu))
		idx=$((idx+1))
	done
	stats=$(jq --argjson gpus `echo ${busids[@]} | jq -cs '.'` \
	'{ hs: [.gpus[].hashrate], hs_units: "hs", temp: [.gpus[].temperature], fan: [.gpus[].fan_speed], uptime: .uptime, ar: [.accepted_count, .rejected_count], bus_numbers: $gpus, algo: .algorithm, ver: .version }' <<< $stat_raw)

	# total hashrate in khs
	khs=$(jq ".hashrate/1000" <<< $stat_raw)
fi

[[ -z $khs ]] && khs=0
[[ -z $stats ]] && stats="null"
