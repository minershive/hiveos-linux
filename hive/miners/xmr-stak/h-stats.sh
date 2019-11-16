#!/usr/bin/env bash

get_cpu_temp () {
  local coretemp0=`cat /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp*_input 2>/dev/null`
  [[ ! -z $coretemp0 ]] && #may not work with AMD cpous
    local tcore=$((`cat /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp*_input | head -n 1`/1000)) ||
    tcore=`cat /sys/class/hwmon/hwmon0/temp*_input | head -n 1 | awk '{print $1/1000}'` #maybe we will need to detect AMD cores
  echo $tcore
}

stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:${MINER_API_PORT}/api.json`

if echo $stats_raw | grep -q '""'; then
	echo "Fixing invalid unescaped json"
	#stats_raw=$(sed 's/"out of time job!"/\\"out of time job!\\"/g' <<< "$stats_raw")
	# "error_log":[{"count":490,"last_seen":1540293687,"text":"AMD Invalid Result GPU ID 9"},{"count":1,"last_seen":1540233037,"text":"invalid share: "invalid hash bytes!""}]}
	#stats_raw=$(echo $stats_raw | sed 's/""/\\""/' |  perl -pe 's/\ (\".+?)\\\"/\ \\$1\\\"/gx')
	#"error_log":[{"count":1,"last_seen":1540304281,"text":"invalid share: \"invalid hash bytes!\""},{"count":1,"last_seen":1540313734,"text":"invalid share: "out of time job!""},{"count":1,"last_seen":1540320745,"text":"AMD Invalid Result GPU ID 2"}]
	stats_raw=$(echo $stats_raw | perl -pe 's/,"error_log":\[.*?\]//') #just remove whole array
	echo $stats_raw | jq -c . > /dev/null
	if [[ $? -ne 0 ]]; then
		echo "Invalid JSON"
		stats_raw=""
	fi
fi

if [[ $? -ne 0 || -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner from localhost:${MINER_API_PORT}${NOCOLOR}"
else
	# [[ -z $XMR_STAK_ALGO ]] && XMR_STAK_ALGO="cryptonight"
	[[ `echo $stats_raw | jq -r '.connection.uptime'` -lt 260 ]] && head -n 150 ${MINER_LOG_BASENAME}.log > ${MINER_LOG_BASENAME}_head.log

	khs=`echo $stats_raw | jq -r '.hashrate.total[0]' | awk '{print $1/1000}'`

	local cpu_temp=`get_cpu_temp`

	local bus_numbers=
	local a_fans=
	local a_temp=

	local gpus_disabled=
	(head -n 50 ${MINER_LOG_BASENAME}_head.log | grep -q "WARNING: backend AMD (OpenCL) disabled") && #AMD disabled found
	(head -n 50 ${MINER_LOG_BASENAME}_head.log | grep -q "WARNING: backend NVIDIA disabled") && #and nvidia disabled
	gpus_disabled=1

	if [[ $gpus_disabled == 1 ]]; then #gpus disabled
		local temp='[]'
		local fan='[]'
	else
		local t_temp=$(jq '.temp' <<< $gpu_stats)
		local t_fan=$(jq '.fan' <<< $gpu_stats)
		# [[ $cpu_indexes_array != '[]' ]] && #remove Internal Gpus
		# 	temp=$(jq -c "del(.$cpu_indexes_array)" <<< $temp) &&
		# 	fan=$(jq -c "del(.$cpu_indexes_array)" <<< $fan)

		local all_bus_ids_array=(`echo "$gpu_detect_json" | jq -r '[ . | to_entries[] | select(.value) | .value.busid [0:2] ] | .[]'`)

		head -n 50 ${MINER_LOG_BASENAME}_head.log | grep -q "WARNING: backend AMD (OpenCL) disabled"
		if [ $? -ne 0 ]; then
		  local ocl_devices=`cat ${MINER_LOG_BASENAME}_head.log | grep "] : Device " | grep " work size " | cut -d " " -f 5`
			local ocl_busids=`echo $gpu_detect_json | jq -r '. | to_entries[] | select(.value.brand == "amd") | .value.busid' | cut -d ":" -f 1`
			for dev_no in $ocl_devices; do
				local t_num=$((dev_no + 1))
				local busid=`echo $ocl_busids | cut -d " " -f $t_num`
				busid=$((0x${busid}))
				[[ ! -z $busid ]] && bus_numbers+="$busid "
				for ((j = 0; j < ${#all_bus_ids_array[@]}; j++)); do
					if [[ "$(( 0x${all_bus_ids_array[$j]} ))" -eq "$busid" ]]; then
						a_fans+=$(jq .[$j] <<< $t_fan)" "
						a_temp+=$(jq .[$j] <<< $t_temp)" "
					fi
				done
			done
		fi

		head -n 50 ${MINER_LOG_BASENAME}_head.log | grep -q "WARNING: backend NVIDIA disabled"
		if [ $? -ne 0 ]; then
			cuda_devices=`cat ${MINER_LOG_BASENAME}_head.log | grep "Starting NVIDIA GPU thread " | cut -d " " -f 8 | tr -d ,`
			local cuda_busids=`echo $gpu_detect_json | jq -r '. | to_entries[] | select(.value.brand == "nvidia") | .value.busid' | cut -d ":" -f 1`
			for dev_no in $cuda_devices; do
				local t_num=$((dev_no + 1))
				local busid=`echo $cuda_busids | cut -d " " -f $t_num`
				busid=$((0x${busid}))
				[[ ! -z $busid ]] && bus_numbers+="$busid "
				for ((j = 0; j < ${#all_bus_ids_array[@]}; j++)); do
					if [[ "$(( 0x${all_bus_ids_array[$j]} ))" -eq "$busid" ]]; then
						a_fans+=$(jq .[$j] <<< $t_fan)" "
						a_temp+=$(jq .[$j] <<< $t_temp)" "
					fi
				done
			done
		fi
	fi

	cpu_devices=`cat ${MINER_LOG_BASENAME}_head.log | grep "] : Starting 1x thread, affinity: " | cut -d " " -f 8 | tr -d .`
	for dev_no in $cpu_devices; do
		bus_numbers+="null "
		a_fans+="0 "
		a_temp+="$cpu_temp "
	done

	local ac=$(jq '.results.shares_good' <<< "$stats_raw")
	local rj=$(( $(jq '.results.shares_total' <<< "$stats_raw") - $ac ))
	local ver=`echo $stats_raw | jq -r '.version' | tr '/' " " | awk '{ print $2 }'`
	local algo=`cat /run/hive/miners/xmr-stak/config.txt | grep -m1 '"currency"' | sed -E 's/\s*".*":\s*"(.*)",/\1/g'`

	stats=$(jq --arg ver "$ver" \
				--argjson temp "`echo ${a_temp[@]} | tr " " "\n" | jq -cs '.'`" \
				--argjson fan "`echo ${a_fans[@]} | tr " " "\n" | jq -cs '.'`" \
				--argjson cpu_temp "$cpu_temp" --arg ac "$ac" --arg rj "$rj" \
				--arg algo "$algo" \
				--argjson bus_numbers "`echo ${bus_numbers[@]} | tr " " "\n" | jq -cs '.'`" \
		'{ver: $ver, hs: [.hashrate.threads[][0]], $algo, $temp, $fan, $cpu_temp, uptime: .connection.uptime, ar: [$ac, $rj], $bus_numbers}' <<< "$stats_raw")
fi

[[ -z $khs ]] && khs=0
[[ -z $stats ]] && stats="null"
