#!/usr/bin/env bash


stats_raw=`curl --connect-timeout 2 --max-time ${API_TIMEOUT} --silent --noproxy '*' http://127.0.0.1:${MINER_API_PORT}/summary`
if [[ $? -ne 0 || -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner from localhost:${MINER_API_PORT}${NOCOLOR}"
else
	khs=`echo $stats_raw | jq -r '.Session.Performance_Summary' | awk '{ print $1/1000 }'`
	local temp=$(jq '.temp' <<< $gpu_stats)
	local fan=$(jq '.fan' <<< $gpu_stats)
	[[ $cpu_indexes_array != '[]' ]] && #remove Internal Gpus
		temp=$(jq -c "del(.$cpu_indexes_array)" <<< $temp) &&
		fan=$(jq -c "del(.$cpu_indexes_array)" <<< $fan)
	local ver=`echo $stats_raw | jq -c -r ".Software" | sed 's/lolMiner //'`
	local bus_numbers=$(echo $stats_raw | jq -r ".GPUs[].PCIE_Address" | cut -f 1 -d ':' | jq -sc .)
	local algo=""
	case "$(echo $stats_raw | jq -r '.Mining.Coin')" in
		BEAM)
			algo="equihash 150/5/3"
			;;
		BEAM-I)
			algo="equihash 150/5"
			;;
		BEAM-II)
			algo="equihash 150/5/3"
			;;
		EXCC)
			algo="equihash 144/5"
			;;
		GRIN-AD29|GRIN-C29D|GRIN-C29M)
			algo="cuckoo"
			;;
		GRIN-AT31|GRIN-C31)
			algo="cuckootoo31"
			;;
		GRIN-AT32|GRIN-C32)
			algo="cuckootoo32"
			;;
		ZEL)
			algo="equihash 125/4"
			;;
		*)
			algo=$(echo $stats_raw | jq -r '.Mining.Algorithm')
			;;
	esac
	local Rejected=`echo $stats_raw | jq -c -r ".Session.Submitted - .Session.Accepted"`
	[[ $Rejected -lt 0 ]] && Rejected=0
	stats=$(jq 	--argjson temp "$temp" \
			--argjson fan "$fan" \
			--arg ver "$ver" \
			--argjson bus_numbers "$bus_numbers" \
			--arg algo "$algo" \
			--arg rej "$Rejected" \
			'{hs: [.GPUs[].Performance], hs_units: "hs", $temp, $fan, uptime: .Session.Uptime, ar: [.Session.Accepted, $rej ], $bus_numbers, algo: $algo, ver: $ver}' <<< "$stats_raw")
fi

[[ -z $khs ]] && khs=0
[[ -z $stats ]] && stats="null"
