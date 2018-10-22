#!/usr/bin/env bash


#######################
# Functions
#######################

get_amd_cards_temp(){
	echo $(jq -c "[.temp$amd_indexes_array]" <<< $gpu_stats)
}

get_amd_cards_fan(){
	echo $(jq -c "[.fan$amd_indexes_array]" <<< $gpu_stats)
}

#######################
# MAIN script body
#######################
stats_raw=`curl --connect-timeout 2 --max-time ${API_TIMEOUT} --silent --noproxy '*' http://127.0.0.1:${MINER_API_PORT}/summary`
if [[ $? -ne 0 || -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner from localhost:${MINER_API_PORT}${NOCOLOR}"
else
	khs=`echo $stats_raw | jq -r '.Session.Performance_Summary' | awk '{ print $1/1000 }'`
	local fan=$(jq -c "[.fan$amd_indexes_array]" <<< $gpu_stats)
	local temp=$(jq -c "[.temp$amd_indexes_array]" <<< $gpu_stats)
	stats=$(jq 	--argjson temp "$temp" \
				--argjson fan "$fan" \
				'{hs: [.GPUs[].Performance], hs_units: "hs", $temp, $fan, uptime: .Session.Uptime, ar: [.Session.Accepted, .Session.Submitted - .Session.Accepted ], algo: .Mining.Algorithm}' <<< "$stats_raw")
fi

[[ -z $khs ]] && khs=0
[[ -z $stats ]] && stats="null"

