#!/usr/bin/env bash

#######################
# Functions
#######################

get_cards_hashes_v3(){
# GPU 0  : AMD_0                ONLINE       Mining at  2.15 gps  Solutions: 13
# GPU 1  : AMD_1                ONLINE       Mining at  2.07 gps  Solutions: 14
# GPU 2  : AMD_2                ONLINE       Mining at  2.09 gps  Solutions: 12

  hs=''
  khs=0
  local t_hs=-1
  local i=0;
  for (( i=0; i < ${GPU_COUNT}; i++ )); do
    t_hs=`cat $log_name | tail -n 1000 | grep "GPU ${i}" | tail -n 1 | awk '{print $8}'`
    [[ ! -z $t_hs ]] && hs+=\"$t_hs\"" " && khs=`echo $khs $t_hs | awk '{ printf("%.6f", $1 + $2/1000) }'`
  done
}

get_cards_hashes(){
  #2019-01-12T21:51:31Z    INFO,     Statistics: GPU 0: mining at 1.42 gps, solutions: 1
  #2019-01-12T21:51:31Z    INFO,     Statistics: GPU 1: mining at 1.41 gps, solutions: 2
  #2019-01-12T22:44:57Z    INFO,     Statistics: GPU 1: mining at 1.38 gps, solutions: 40

  hs=''
  khs=0
  local t_hs=-1
  local i=0;
  for (( i=0; i < ${GPU_COUNT}; i++ )); do
    t_hs=`cat $log_name | tail -n 50 | grep "Statistics: GPU ${i}:" | tail -n 1 awk '{print $7}'`
    [[ ! -z $t_hs ]] && hs+=\"$t_hs\"" " && khs=`echo $khs $t_hs | awk '{ printf("%.6f", $1 + $2/1000) }'`
  done
}

get_miner_uptime(){
  local a=0
  let a=`stat --format='%Y' $log_name`-`stat --format='%Y' $conf_name`
  echo $a
}

get_miner_uptime2(){
  local a=0
  local lastJob=`jq -r '.lastJob' <<< $stats_status`
  local minerWork=$((`date -d "$lastJob" +%s`))
  local minerStart=`stat --format='%Y' $conf_name`
  a=$(($minerWork - $minerStart))
  echo $a
}

get_log_time_diff(){
  local a=0
  let a=`date +%s`-`stat --format='%Y' $log_name`
  echo $a
}

#######################
# MAIN script body
#######################

local log_dir=`dirname "$MINER_LOG_BASENAME"`

# cd "$log_dir"
# local log_name=$(ls -t --color=never | head -1)
# log_name="${log_dir}/${log_name}"
log_name=${MINER_LOG_BASENAME}.log
local ver=`miner_ver`
local fork=`miner_fork`
local conf_name="/var/run/hive/miners/$MINER_NAME/config.xml"

local temp=$(jq '.temp' <<< $gpu_stats)
local fan=$(jq '.fan' <<< $gpu_stats)

[[ $cpu_indexes_array != '[]' ]] && #remove Internal Gpus
  temp=$(jq -c "del(.$cpu_indexes_array)" <<< $temp) &&
  fan=$(jq -c "del(.$cpu_indexes_array)" <<< $fan)

# Calc log freshness
local diffTime=$(get_log_time_diff)
local maxDelay=120

# echo $diffTime

local algo="cuckoo"
local hs_units='hs' # hashes utits

GPU_COUNT=`cat $conf_name | grep -c "<DeviceID>"`

if [[ "$fork" = "monerov" ]]; then

  # If log is fresh the calc miner stats or set to null if not
	if [ "$diffTime" -lt "$maxDelay" ]; then
		get_cards_hashes_v3 # hashes array
		local uptime=$(get_miner_uptime) # miner uptime

		# A/R shares by pool
		#Shares (sub/acc/stale/rej): 16/15/0/1     Last share:   27 seconds
		local ac=`cat $log_name | tail -n 1000 | grep 'Shares (sub/acc/stale/rej):' | tail -n 1 | awk '{print $3}' | cut -d "/" -f 2`
		local rj=`cat $log_name | tail -n 1000 | grep 'Shares (sub/acc/stale/rej):' | tail -n 1 | awk '{print $3}' | cut -d "/" -f 4`

		# make JSON
		stats=$(jq -nc \
			--argjson hs "`echo ${hs[@]} | tr " " "\n" | jq -cs '.'`" \
				--arg hs_units "$hs_units" \
				--argjson temp "$temp" \
				--argjson fan "$fan" \
				--arg uptime "$uptime" \
				--arg algo "$algo" \
				--arg ac "$ac" --arg rj "$rj" \
				--arg ver "$ver" \
				'{$hs, $hs_units, $temp, $fan, $uptime, ar: [$ac, $rj], $algo, $ver}')
	else
		stats=""
		khs=0
	fi
elif [[ "$ver" < "3.0" ]]; then
	# If log is fresh the calc miner stats or set to null if not
	if [ "$diffTime" -lt "$maxDelay" ]; then
		get_cards_hashes # hashes array
		local uptime=$(get_miner_uptime) # miner uptime

		# A/R shares by pool
		#2019-01-14T20:07:29Z    DEBUG,     Statistics for 1: shares sub: 11 ac: 10 rj: 0
		local ac=`cat $log_name | tail -n 50 | grep 'Statistics for ' | grep 'shares sub: ' | tail -n 1 | awk '{print $9}'`
		local rj=`cat $log_name | tail -n 50 | grep 'Statistics for ' | grep 'shares sub: ' | tail -n 1 | awk '{print $11}'`

		# make JSON
		stats=$(jq -nc \
			--argjson hs "`echo ${hs[@]} | tr " " "\n" | jq -cs '.'`" \
				--arg hs_units "$hs_units" \
				--argjson temp "$temp" \
				--argjson fan "$fan" \
				--arg uptime "$uptime" \
				--arg algo "$algo" \
				--arg ac "$ac" --arg rj "$rj" \
				--arg ver "$ver" \
				'{$hs, $hs_units, $temp, $fan, $uptime, ar: [$ac, $rj], $algo, $ver}')
	else
		stats=""
		khs=0
	fi
else
	stats_status=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:$MINER_API_PORT/api/status`
	if [[ $? -eq 0 ]] & [[ ! -z $stats_status ]]; then
		local uptime=$(get_miner_uptime2) # miner uptime
		local st=`jq -r '.shares.submitted' <<< $stats_status`
		local ac=`jq -r '.shares.accepted' <<< $stats_status`
		local rj=$(($st-$ac))
		local hs=`jq -r '.workers[].graphsPerSecond' <<< $stats_status`
		khs=`jq -r '[.workers[].graphsPerSecond] | add' <<< $stats_status`
    khs=`echo $khs | awk '{ printf("%.6f", $1/1000) }'`
		# make JSON
		stats=$(jq -nc \
			--argjson hs "`echo ${hs[@]} | tr " " "\n" | jq -cs '.'`" \
				--arg hs_units "$hs_units" \
				--argjson temp "$temp" \
				--argjson fan "$fan" \
				--arg uptime "$uptime" \
				--arg algo "$algo" \
				--arg ac "$ac" --arg rj "$rj" \
				--arg ver "$ver" \
				'{$hs, $hs_units, $temp, $fan, $uptime, ar: [$ac, $rj], $algo, $ver}')
	else
		stats=""
		khs=0
	fi
fi

# debug output
##echo temp:  $temp
##echo fan:   $fan
#echo stats: $stats
#echo khs:   $khs
