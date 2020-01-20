#!/usr/bin/env bash

get_cpu_temps () {
	local t_core=`cpu-temp`
	local i=0
	local l_num_cores=$1
	local l_temp=
	for (( i=0; i < ${l_num_cores}; i++ )); do
		l_temp+="$t_core "
	done
  echo ${l_temp[@]} | tr " " "\n" | jq -cs '.'
}

get_cpu_fans () {
	local t_fan=0
	local i=0
	local l_num_cores=$1
	local l_fan=
	for (( i=0; i < ${l_num_cores}; i++ )); do
		l_fan+="$t_fan "
	done
	echo ${l_fan[@]} | tr " " "\n" | jq -cs '.'
}

get_bus_numbers () {
	local i=0
	local l_num_cores=$1
	local l_numbers=
	for (( i=0; i < ${l_num_cores}; i++ )); do
		l_numbers+="null "
	done
	echo ${l_numbers[@]} | tr " " "\n" | jq -cs '.'
}

local ver=`miner_ver`
local fork=`miner_fork`

case $fork in
   xmrigcc)
	if [[ "$ver" < "2.0" ]]; then
		stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:$MINER_API_PORT`
	else
		stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:$MINER_API_PORT/1/summary`
	fi
	;;
         *)
	if [[ "$ver" < "2.15" ]]; then
		stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:$MINER_API_PORT`
	else
		stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:$MINER_API_PORT/1/summary`
	fi
esac

#echo $stats_raw | jq .
if [[ $? -ne 0 || -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner from localhost:$MINER_API_PORT${NOCOLOR}"
else
	khs=`echo $stats_raw | jq -r '.hashrate.total[0]' | awk '{print $1/1000}'`
	local ac=$(jq '.results.shares_good' <<< "$stats_raw")
	local rj=$(( $(jq '.results.shares_total' <<< "$stats_raw") - $ac ))
	local num_cores=`echo $stats_raw | jq '.hashrate.threads[][0]' | wc -l`
	local cpu_temp=`get_cpu_temps "$num_cores"`
	local cpu_fan=`get_cpu_fans "$num_cores"`
	local bus_numbers=`get_bus_numbers "$num_cores"`
	stats=`echo $stats_raw | jq --arg ac "$ac" --arg rj "$rj" \
                              --argjson temp "$cpu_temp" \
                              --argjson fan "$cpu_fan" \
															--argjson bus_numbers "$bus_numbers" \
					'{hs: [.hashrate.threads[][0]], $temp, $fan, ar: [$ac, $rj],
					  uptime: .connection.uptime, algo: .algo, $bus_numbers, ver: .version}'`
fi

[[ -z $khs ]] && khs=0
[[ -z $stats ]] && stats="null"
