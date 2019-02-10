#!/usr/bin/env bash

local MINER_VER=$SGMINER_VER
local MINER_FORK=$SGMINER_FORK
local fork=${SGMINER_FORK^^} #uppercase MINER_FORK
eval "MINER_VER=\$MINER_LATEST_VER_${fork//-/_}" #char replace
#echo $MINER_DIR/$MINER_FORK/$MINER_VER
if [ -e $MINER_DIR/$MINER_FORK/$MINER_VER/nohwmon ]; then
   NO_HW_MON=1
else
   NO_HW_MON=0
fi

stats_raw=`echo '{"command":"summary+devs"}' | nc -w $API_TIMEOUT localhost ${MINER_API_PORT}`
local ver=`echo $stats_raw | jq -r .summary[0].STATUS[0].Description | awk '{ printf $2 }'`
if [[ $? -ne 0 || -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner from localhost:${MINER_API_PORT}${NOCOLOR}"
else
	khs=`echo $stats_raw | jq '.["summary"][0]["SUMMARY"][0]["KHS 15s"]'`
	if [ -z $NO_HW_MON ] || [ $NO_HW_MON -eq 0 ]; then
		stats=`echo $stats_raw | jq --arg ver "$ver" --arg algo "$SGMINER_ALGO" \
			'{khs: [.devs[0].DEVS[]."KHS 15s"], temp: [.devs[0].DEVS[].Temperature], ar: [.summary[0].SUMMARY[0].Accepted,.summary[0].SUMMARY[0].Rejected],
			fan: [.devs[0].DEVS[]."Fan Percent"], uptime: .summary[0].SUMMARY[0].Elapsed, $algo, $ver}'`
	else
		#TODO: check on mixed rig, maybe amd first, then nvidia         

		local temp=$(jq '.temp' <<< $gpu_stats) 
		local fan=$(jq '.fan' <<< $gpu_stats)   
		local bus_id=$(jq '.busids' <<< $gpu_stats)

		[[ $cpu_indexes_array != '[]' ]] && #remove Internal Gpus
			temp=$(jq -c "del(.$cpu_indexes_array)" <<< $temp) &&
			fan=$(jq -c "del(.$cpu_indexes_array)" <<< $fan) &&
			bus_id=$(jq -c "del(.$cpu_indexes_array)" <<< $bus_id)
		
		local a_temp=(`echo $temp | jq -r '.[]'`)
		local a_fan=(`echo $fan  | jq -r '.[]'`)
		local a_busid=(`echo $bus_id | jq -r '.[]'`)
		local gpus_idx=(`echo $stats_raw | jq -r '.devs[0].DEVS[] | select(.Enabled == "Y") | .GPU'`)

		temp='[]'
		fan='[]'
		busids=()
		#echo $gpu_idx
		for idx in "${gpus_idx[@]}"
		do
			temp=`jq --null-input --argjson temp "$temp" --arg t "${a_temp[$idx]}" '$temp + [$t]'`
			fan=`jq --null-input --argjson fan "$fan" --arg f "${a_fan[$idx]}" '$fan + [$f]'`
			gpu=`echo "${a_busid[$idx]}" | tr ":" " " | awk '{print $1}'`
			busids[idx]=$((16#$gpu))
		done
		gpus=`echo ${busids[@]} | jq -cs '.'`
		per_cards=`echo $stats_raw | jq '.devs[0].DEVS[] | select(.Enabled == "Y") | ."KHS 15s"' | jq -R . | jq -s .`

		stats=`echo $stats_raw | jq --arg ver "$ver" --arg algo "$SGMINER_ALGO" --argjson temp "$temp" --argjson fan "$fan" --argjson bus_id "$gpus"  --argjson per_cards "$per_cards" \
			'{khs: $per_cards, temp: $temp, ar: [.summary[0].SUMMARY[0].Accepted,.summary[0].SUMMARY[0].Rejected],
			fan: $fan, bus_numbers: $bus_id, uptime: .summary[0].SUMMARY[0].Elapsed, $algo, $ver}'`

	fi
fi

[[ -z $khs ]] && khs=0
[[ -z $stats ]] && stats="null"





