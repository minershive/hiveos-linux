#!/usr/bin/env bash

get_miner_uptime(){
  local a=0
  let a=`stat --format='%Y' $log_name`-`stat --format='%Y' $conf_name`
  echo $a
}

stats_raw=`curl --connect-timeout 2 --max-time ${API_TIMEOUT} --silent --noproxy '*' http://127.0.0.1:${MINER_API_PORT}/api/status`
if [[ $? -ne 0 || -z $stats_raw ]]; then
  echo -e "${YELLOW}Failed to read $miner from localhost:${MINER_API_PORT}${NOCOLOR}"
else

  khs=`echo $stats_raw | jq -r '.workers[].graphsPerSecond' | awk '{s+=$1} END {print s/1000}'` #sum up and convert to khs

  local log_dir=`dirname "$MINER_LOG_BASENAME"`

  cd "$log_dir"
  local log_name=$(ls -t --color=never | head -1)
  log_name="${log_dir}/${log_name}"
  local ver=`miner_ver`
  local conf_name="/hive/miners/$MINER_NAME/$ver/config.xml"

  local temp=$(jq '.temp' <<< $gpu_stats)
  local fan=$(jq '.fan' <<< $gpu_stats)

  [[ $cpu_indexes_array != '[]' ]] && #remove Internal Gpus
    temp=$(jq -c "del(.$cpu_indexes_array)" <<< $temp) &&
    fan=$(jq -c "del(.$cpu_indexes_array)" <<< $fan)

  local algo="cuckoo"

  local hs_units='hs' # hashes utits
  local uptime=$(get_miner_uptime) # miner uptime

  stats=$(jq --argjson temp "$temp" \
              --argjson fan "$fan" \
              --arg ver "$ver" \
              --arg algo "$algo" \
              --arg uptime "$uptime" \
              --arg hs_units "$hs_units" \
              '{hs: [.workers[].graphsPerSecond], $hs_units, $temp, $fan, $uptime, ar: [.shares.accepted, .shares.failedToValidate], $algo, ver: $ver}' <<< "$stats_raw")

fi

[[ -z $khs ]] && khs=0
[[ -z $stats ]] && stats="null"

# debug output
##echo temp:  $temp
##echo fan:   $fan
#echo stats: $statsOD
#echo khs:   $khs
