#!/usr/bin/env bash

stats_raw=`echo '{"command":"summary+devs"}' | nc -w $API_TIMEOUT localhost ${MINER_API_PORT}`
if [[ $? -ne 0 || -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner from localhost:${MINER_API_PORT}${NOCOLOR}"
else
	khs=`echo $stats_raw | jq '."summary"."SUMMARY"[0]."KHS 30s"'`
	local temp=$(jq '.temp' <<< $gpu_stats)
	local fan=$(jq '.fan' <<< $gpu_stats)

	local ac=$(jq '."summary"."SUMMARY"[0]."Accepted"' <<< "$stats_raw")
	local rj=$(jq '."summary"."SUMMARY"[0]."Rejected"' <<< "$stats_raw")

	stats=$(jq --argjson temp "$temp" --argjson fan "$fan" --arg ac "$ac" --arg rj "$rj" --arg algo "$CUSTOM_ALGO" \
		'{hs: [.devs.DEVS[]."KHS 30s"], $algo, $temp, $fan, uptime: .summary.SUMMARY[0].Elapsed, ar: [$ac, $rj], bus_numbers: [.devs.DEVS[]."GPU"]}' <<< "$stats_raw")
fi

	[[ -z $khs ]] && khs=0
	[[ -z $stats ]] && stats="null"
