#!/usr/bin/env bash

get_cores_hs(){
	for (( i=0; i < ${num_cores}; i++ )); do
		hs[$i]=`echo $khs | awk '{ printf($1/'$num_cores') }'`
	done
}

#2018-12-20 23:26:44: [Statistics] Pascal: CPU: 724.556 H/s
get_total_hs(){
	cat $MINER_LOG_BASENAME.log | tail -n 50 | grep -a "[Statistics]" | grep -a "Pascal" | grep -a ": CPU: " | tail -n 1 | cut -f 6 -d " " -s
}

get_cpu_temps(){
	local coretemp0=`cat /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp*_input 2>/dev/null`
	[[ ! -z $coretemp0 ]] && #may not work with AMD cpous
		tcore=$((`cat /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp*_input | head -n 1`/1000)) ||
		tcore=`cat /sys/class/hwmon/hwmon0/temp*_input | head -n 1 | awk '{print $1/1000}'` #maybe we will need to detect AMD cores

	if [[ ! -z tcore ]]; then
		for (( i=0; i < ${num_cores}; i++ )); do
			temp[$i]=$tcore
		done
	fi
}

stats_raw=`echo '{"id":0,"jsonrpc":"2.0","method":"miner_getstat1"}' | nc -w $API_TIMEOUT localhost $MINER_API_PORT | jq '.result'`
if [[ $? -ne 0  || -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner stats_raw from localhost:${MINER_API_PORT}${NOCOLOR}"
else

	local temp=()
	local fan=()
	local tfcounter=0
	local hs=''

	local ac=`echo $stats_raw | jq -r '.[2]' | awk -F';' '{print $2}'`
	local rj=`echo $stats_raw | jq -r '.[2]' | awk -F';' '{print $3}'`
	local ver=`echo $stats_raw | jq -r '.[0]' | awk '{print $1}'`
	local uptime=`echo "$stats_raw" | jq -r '.[1]' | awk '{print $1*60}'`

	[[ ! -z $FINMINER_ALGO ]] && local algo=$FINMINER_ALGO || local algo="ethash"
	local hs_units=''
	[[ $algo == "ethash" ]] && hs_units="khs" || hs_units="hs"

	if [[ $algo == "randomhash" ]]; then
		[[ $uptime -lt 60 ]] && head -n 50 $MINER_LOG_BASENAME.log > ${MINER_LOG_BASENAME}_head.log
		#2018-12-20 22:22:44: <info> Using CPU threads: 6
		num_cores=`cat ${MINER_LOG_BASENAME}_head.log | grep "<info> Using CPU threads:" | awk '{print $7}'`
		khs=`get_total_hs`
		get_cores_hs
		hs=`echo ${hs[@]} | tr " " "\n" | jq -cs '.'`
		khs=`echo $khs | awk '{ printf($1/1000) }'`
		get_cpu_temps
		temp=`echo ${temp[@]} | tr " " "\n" | jq -cs '.'`
		fan="[]"
	else
		khs=`echo $stats_raw | jq -r '.[2]' | awk -F';' '{print $1}'`
		local tempfans=`echo $stats_raw | jq -r '.[6]' | tr ';' ' '`

		for tf in $tempfans; do
			(( $tfcounter % 2 == 0 )) &&
				temp+=($tf) ||
				fan+=($tf)
			((tfcounter++))
		done
		temp=`printf '%s\n' "${temp[@]}" | jq --raw-input . | jq --slurp -c .`
		fan=`printf '%s\n' "${fan[@]}" | jq --raw-input . | jq --slurp -c .`

		hs=`echo "$stats_raw" | jq -r '.[3]' | tr ';' '\n' | jq -cs '.'`
	fi

	stats=$(jq -n \
		--arg uptime "$uptime" \
		--argjson hs "$hs" --argjson temp "$temp" --argjson fan "$fan" \
		--arg ac "$ac" --arg rj "$rj" \
		--arg algo "$algo" --arg hs_units "$hs_units" --arg ver "$ver" \
		'{$hs, $hs_units, $temp, $fan, $uptime, $algo, ar: [$ac, $rj], $ver}')
fi

[[ -z $khs ]] && khs=0
[[ -z $stats ]] && stats="null"
