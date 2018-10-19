#!/usr/bin/env bash

. /hive/miners/cast_xmr-vega/h-manifest.conf

stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:$MINER_API_PORT`
if [[ $? -ne 0 || -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner from localhost:${WEB_PORT}${NOCOLOR}"
else
	khs=`echo $stats_raw | jq -r '.total_hash_rate' | awk '{print $1/1000}'`
	local temp=$(jq '.temp' <<< $gpu_stats)
	local fan=$(jq '.fan' <<< $gpu_stats)

	local ac=$(jq '."shares"."num_accepted"' <<< "$stats_raw")
	local rj=$(jq '."shares"."num_rejected"' <<< "$stats_raw")
	local iv=$(jq '."shares"."num_invalid"' <<< "$stats_raw")

	stats=$(jq --arg ac "$ac" --arg rj "$rj" --arg iv "$iv" --arg algo "$CAST_XMR_VEGA_ALGO" \
			'{hs: [.devices[].hash_rate], hs_units: "hs", $algo, temp: [.devices[].gpu_temperature], fan: [.devices[].gpu_fan_rpm], uptime: .pool.online, ar: [$ac, $rj, $iv], bus_numbers: [.devices[].device_id]}' <<< "$stats_raw")
fi

	[[ -z $khs ]] && khs=0
	[[ -z $stats ]] && stats="null"
