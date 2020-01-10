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
	local tcore=`cpu-temp`
	local i=0
	local l_num_cores=$1
	local l_temp=
	if [[ ! -z tcore ]]; then
		for (( i=0; i < ${l_num_cores}; i++ )); do
		l_temp+="$tcore "
		done
		echo $l_temp
	fi
}

get_bus_numbers() {
	#2019-11-29 20:58:18: <info> GPU 0 PCI 01.00.0, Platform: CUDA, Name: GeForce GTX 1050 Ti, 4040 MB available
	local line=
	local l_bus_numbers=
	while read -r line ; do
		l_bus_numbers+=`echo $line | cut -d " " -f 7 | cut -d "." -f 1 | awk '{printf("%d\n", "0x"$1)}'`" "
	done < <(cat ${MINER_LOG_BASENAME}_head.log | grep "<info> GPU" | grep "PCI")
	echo $l_bus_numbers
}

get_cpu_bus_numbers() {
	local i=0
	local l_bus=
	for (( i=0; i < $1; i++ )); do
		l_bus+="null "
	done
	echo $l_bus
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

	[[ $uptime -lt 60 ]] && head -n 50 $MINER_LOG_BASENAME.log > ${MINER_LOG_BASENAME}_head.log

	if [[ $algo == "randomhash" ]]; then
		#2018-12-20 22:22:44: <info> Using CPU threads: 6
		num_cores=`cat ${MINER_LOG_BASENAME}_head.log | grep "<info> Using CPU threads:" | awk '{print $7}'`
		bus_numbers=`get_cpu_bus_numbers $num_cores | tr " " "\n" | jq -cs '.'`
		khs=`get_total_hs`
		get_cores_hs
		hs=`echo ${hs[@]} | tr " " "\n" | jq -cs '.'`
		khs=`echo $khs | awk '{ printf($1/1000) }'`
		temp=`get_cpu_temps "$num_cores"`
		temp=`echo ${temp[@]} | tr " " "\n" | jq -cs '.'`
		fan="[]"
	else
		bus_numbers=`get_bus_numbers | tr " " "\n" | jq -cs '.'`
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
		--argjson bus_numbers "$bus_numbers" \
		'{$hs, $hs_units, $temp, $fan, $uptime, $algo, ar: [$ac, $rj], $bus_numbers, $ver}')
fi

[[ -z $khs ]] && khs=0
[[ -z $stats ]] && stats="null"
