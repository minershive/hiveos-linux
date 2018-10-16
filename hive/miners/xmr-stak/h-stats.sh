#!/usr/bin/env bash

  MINER_LOG_BASENAME="/var/log/miner/xmr-stak/xmr-stak"

	stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:${MINER_API_PORT}/api.json`
	if [[ $? -ne 0 || -z $stats_raw ]]; then
		echo -e "${YELLOW}Failed to read $miner from localhost:${MINER_API_PORT}${NOCOLOR}"
	else
		# [[ -z $XMR_STAK_ALGO ]] && XMR_STAK_ALGO="cryptonight"

		khs=`echo $stats_raw | jq -r '.hashrate.total[0]' | awk '{print $1/1000}'`

		local cpu_temp=`cat /sys/class/hwmon/hwmon0/temp*_input | head -n $(nproc) | awk '{print $1/1000}' | jq -rsc .` #just a try to get CPU temps

		local gpus_disabled=
				(head -n 40 ${MINER_LOG_BASENAME}.log | grep -q "WARNING: backend AMD (OpenCL) disabled") && #AMD disabled found
				(head -n 40 ${MINER_LOG_BASENAME}.log | grep -q "WARNING: backend NVIDIA disabled") && #and nvidia disabled
				gpus_disabled=1
		if [[ $gpus_disabled == 1 ]]; then #gpus disabled
			local temp='[]'
			local fan='[]'
		else
			local temp=$(jq '.temp' <<< $gpu_stats)
			local fan=$(jq '.fan' <<< $gpu_stats)
			[[ $cpu_indexes_array != '[]' ]] && #remove Internal Gpus
				temp=$(jq -c "del(.$cpu_indexes_array)" <<< $temp) &&
				fan=$(jq -c "del(.$cpu_indexes_array)" <<< $fan)
		fi

		local ac=$(jq '.results.shares_good' <<< "$stats_raw")
		local rj=$(( $(jq '.results.shares_total' <<< "$stats_raw") - $ac ))

		local algo=`cat /run/hive/miners/xmr-stak/config.txt | grep -m1 '"currency"' | sed -E 's/\s*".*":\s*"(.*)",/\1/g'`

		stats=$(jq --argjson temp "$temp" --argjson fan "$fan" \
					--argjson cpu_temp "$cpu_temp" --arg ac "$ac" --arg rj "$rj" \
					--arg algo "$algo" \
			'{hs: [.hashrate.threads[][0]], $algo, $temp, $fan, $cpu_temp, uptime: .connection.uptime, ar: [$ac, $rj]}' <<< "$stats_raw")
		# TODO: bus_numbers
	fi

	[[ -z $khs ]] && khs=0
	[[ -z $stats ]] && stats="null"
