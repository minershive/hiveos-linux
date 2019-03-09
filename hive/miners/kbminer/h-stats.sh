#!/usr/bin/env bash

#######################
# Functions
#######################

get_miner_uptime(){
  local a=`cat $log_name | tail -n 100 | grep "Uptime:" | tail -n 1 | awk '{ print $7 }'`
  if [[ $a == '' ]]; then
    local a=0
    let a=`stat --format='%Y' $log_name`-`stat --format='%Y' $conf_name`
  fi
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

local stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:${MINER_API_PORT}`
if [[ $? -ne 0 || -z $stats_raw ]]; then
  echo -e "${YELLOW}Failed to read $miner from 127.0.0.1:{$MINER_API_PORT}${NOCOLOR}"
  stats=""
  khs=0
else
  local log_name="$MINER_LOG_BASENAME.log"
  local ver=`miner_ver`
  local conf_name="/hive/miners/$MINER_NAME/$ver/$MINER_NAME.conf"

  local temp=$(jq '.temp' <<< $gpu_stats)
  local fan=$(jq '.fan' <<< $gpu_stats)
  cat $conf_name | grep -q "\-\-enable-cpu"
  if [[ ! $? -eq 0 ]]; then
    [[ $cpu_indexes_array != '[]' ]] && #remove Internal Gpus
      temp=$(jq -c "del(.$cpu_indexes_array)" <<< $temp) &&
      fan=$(jq -c "del(.$cpu_indexes_array)" <<< $fan)
  fi

  # Calc log freshness
  local diffTime=$(get_log_time_diff)
  local maxDelay=120

  # If log is fresh the calc miner stats or set to null if not
  if [ "$diffTime" -lt "$maxDelay" ]; then

    local hs=`jq '.hashrates' <<< "$stats_raw"`
    local hs_units='hs' # hashes utits
    khs=`jq add <<< "$hs" | awk '{print $1/1000}'`
    local uptime=$(get_miner_uptime) # miner uptime

    local acc=`grep -c "share accepted\!" $MINER_LOG_BASENAME.log`
    local rej=`grep -c "share rejected\!" $MINER_LOG_BASENAME.log`

  # make JSON
  #--argjson hs "`echo ${hs[@]} | tr " " "\n" | jq -cs '.'`" \
    stats=$(jq -nc \
          --arg total_khs "$khs" \
          --argjson hs "$hs" \
          --arg hs_units "$hs_units" \
          --argjson temp "$temp" \
          --argjson fan "$fan" \
          --arg uptime "$uptime" \
          --arg acc "$acc" \
          --arg rej "$rej" \
          --arg algo "$KBMINER_ALGO" \
          --arg ver "$ver" \
          '{$total_khs, $hs, $hs_units, ar: [$acc, $rej], $temp, $fan, $uptime, $algo, $ver}')
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
