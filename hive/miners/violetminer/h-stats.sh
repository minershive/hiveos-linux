#!/usr/bin/env bash


#######################
# Functions
#######################

get_cards_hashes(){
  local line=
  local gpus=`cat $GPU_DETECT_JSON | jq -c '. | to_entries[] | select(.value.brand == "nvidia") | .key'`
# [trtl.pool.mine2gether.com:2225] GPU3#11-3           | 38281.47 H/s
  for i in $gpus; do
    line=`cat $log_name | tail -200 | grep "GPU$i" | tail -1`
    if [[ ! -z $line ]]; then
      hs+=`echo $line | cut -d '|' -f 2 | awk '{print $1}'`" "
      gpus+="$i "
      bus_numbers+=`echo $line | awk '{print $2}' | cut -d '#' -f 2 | cut -d '-' -f 1`" "
    fi
  done
# [trtl.pool.mine2gether.com:2225] Total Hashrate      | 151756.90 H/s
#  khs=`cat $log_name | tail -200 | grep "Total Hashrate" | tail -1 | cut -d '|' -f 2 | awk '{printf $1/1000}'`
  khs=`echo ${hs%' '} | tr ' ' + | bc | awk '{printf $1/1000}'`
}

get_miner_uptime(){
  ps -o etimes= -C $MINER_NAME | awk '{print $1}'
}

get_log_time_diff(){
  local a=0
  let a=$(date +%s)-$(stat --format='%Y' $log_name)
  echo $a
}


#######################
# MAIN script body
#######################

stats=""
khs=0
hs=
gpus=
bus_numbers=

local log_name="$MINER_LOG_BASENAME.log"

if [[ -f $log_name ]]; then

  # Calculate log freshness
  local diffTime=$(get_log_time_diff)
  local maxDelay=60

  # If log is fresh the calc miner stats or set to null if not
  if [ "$diffTime" -lt "$maxDelay" ]; then

    local temp=
    local fan=
    local ac=0
    local rj=0
    local ver=$(miner_ver)

    [[ -z $GPU_COUNT_NVIDIA ]] &&
      GPU_COUNT_NVIDIA=`gpu-detect NVIDIA`

    # Per-card hashes array
    get_cards_hashes
    # Hashes units
    local hs_units='khs'
    # Get temp and fan of GPUs from $gpu_stats
    gpus=`echo ${gpus} | tr " " "\n" | jq -cs '.'`
    local temp=$(jq -c "[.temp$gpus]" <<< $gpu_stats)
    local fan=$(jq -c "[.fan$gpus]" <<< $gpu_stats)
    # Miner uptime
    local uptime=$(get_miner_uptime)

    # Amount of A/R shares (by pool)
    # [trtl.pool.mine2gether.com:2225] Share accepted by pool! [130 / 130]
    local ac=`cat $log_name | tail -200 | grep "Share accepted by pool" | tail -1 | cut -d '[' -f 3 | cut -d '/' -f 1 | awk '{print $1}'`
    local all=`cat $log_name | tail -200 | grep "Share accepted by pool" | tail -1 | cut -d '[' -f 3 | cut -d '/' -f 2 | cut -d ']' -f 1 | awk '{print $1}'`
    local rj=$((all-ac))

    # create JSON
    stats=$(jq -nc \
               --argjson hs "`echo ${hs} | tr " " "\n" | jq -cs '.'`" \
               --arg hs_units "hs" \
               --argjson temp "$temp" \
               --argjson fan "$fan" \
               --arg uptime "$uptime" \
               --arg ac "$ac" \
               --arg rj "$rj" \
               --arg algo "$VIOLETMINER_ALGO" \
               --arg ver "`miner_ver`" \
               --argjson bus_numbers "`echo ${bus_numbers} | tr " " "\n" | jq -cs '.'`" \
               '{$hs, $hs_units, $temp, $fan, $uptime, ar: [$ac, $rj], $algo, $ver, $bus_numbers}')
  fi
fi
