#!/usr/bin/env bash

stats_raw=`/hive/lolminer/lolHelper`
if [[ $? -ne 0 || -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner from lolHelper${NOCOLOR}"
else
	local platform=`tac /hive/lolminer/pool.cfg | grep -m1 "^\-\-platform" | awk '{print toupper($2)}'`
	khs=`echo $stats_raw | jq '.result[].sol_ps' | awk '{s+=$1} END {print s/1000}'`
	local uptime=$(( `date +%s` - $(stat -c%X /proc/`pidof lolMiner-mnx`) ))
	local fan='[]'
	local temp='[]'
	if [[ $platform = 0 || ($platform = "AUTO" && $amd_indexes_array != "[]") ]]; then #AMD
		fan=$(jq -c "[.fan$amd_indexes_array]" <<< $gpu_stats)
		temp=$(jq -c "[.temp$amd_indexes_array]" <<< $gpu_stats)
	elif [[ $platform = 1 || ($platform = "AUTO" && $nvidia_indexes_array != "[]") ]]; then #Nvidia
		fan=$(jq -c "[.fan$nvidia_indexes_array]" <<< $gpu_stats)
		temp=$(jq -c "[.temp$nvidia_indexes_array]" <<< $gpu_stats)
	fi
	stats=$(jq --argjson temp "$temp" --argjson fan "$fan" --arg uptime "$uptime" '{ hs: [.result[].sol_ps], $temp, $fan, $uptime}' <<< $stats_raw)
fi
