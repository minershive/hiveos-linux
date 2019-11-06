#!/usr/bin/env bash

function get_cpu_temp(){
    for HWMON in $(ls /sys/class/hwmon) 
    do
       local test=$(cat /sys/class/hwmon/${HWMON}/name | grep -c -E 'coretemp|k10temp')
       if [[ $test -gt 0 ]]; then
           HWMON_DIR=/sys/class/hwmon/$HWMON
           break
       fi
    done
    if [[ -z $HWMON_DIR ]]; then
       HWMON_DIR="/sys/class/hwmon/hwmon0"
    fi
    cat $HWMON_DIR/temp*_input
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
	local cpu_temp=`get_cpu_temp | head -n $(nproc) | awk '{print $1/1000}' | jq -rsc .` #just a try to get CPU temps
	stats=`echo $stats_raw | jq --arg ac "$ac" --arg rj "$rj" \
					'{hs: [.hashrate.threads[][0]], temp: '$cpu_temp', ar: [$ac, $rj],
					  uptime: .connection.uptime, algo: .algo, ver: .version}'`
fi

[[ -z $khs ]] && khs=0
[[ -z $stats ]] && stats="null"
