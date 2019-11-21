#!/usr/bin/env bash

#######################
# Functions
#######################

get_miner_uptime(){
  local a=0
  let a=`date +%s`-`stat --format='%Y' $1`
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

local log_name="/var/log/miner/smine/smine.log"
local ver=`miner_ver`

local conf_name="/run/hive/miners/$MINER_NAME/$MINER_NAME.conf"

##array of user selected GPUS
#gpu_indexes_array=`cat $conf_name | egrep -o '*-device\ ([0-9\,])+' | awk '{print "["$2"]"}'`

local temp="[]"
local fan="[]"

local temp=`jq -c "[.temp$amd_indexes_array]" <<< $gpu_stats`
local fan=`jq -c "[.fan$amd_indexes_array]" <<< $gpu_stats`

#if [[ ! -z $gpu_indexes_array ]]; then
#  temp=`jq -c "[.$gpu_indexes_array]" <<< $temp`
#  fan=`jq -c "[.$gpu_indexes_array]" <<< $fan`
#fi

local algo="eaglesong"
local ver=`miner_ver`

dpkg --compare-versions $ver "ge" "0.4.0"
if [ $? -eq "0" ]; then #use api for ver 0.4.0 and newer
  #{"hash_rates":[73.88965546666667,298.0752042666667,281.018368,298.0752042666667],"total_rate":951.058432,"accept":1,"reject":0,"uptime":94}
  stats_raw=`curl -s "http://localhost:${MINER_API_PORT}"`
  if [[ $? -ne 0  || -z $stats_raw ]]; then
    echo -e "${YELLOW}Failed to read $miner stats from localhost:${MINER_API_PORT}${NOCOLOR}"
  else
    stats=$(jq -c --arg algo "$algo" \
                  --arg hs_units "mhs" \
                  --arg ver "$ver" \
                  --argjson gpu_stats "$gpu_stats" \
                  --argjson temp "$temp" --argjson fan "$fan" \
                  '{ total_khs: (.total_rate * 1000), hs: (.hash_rates), hs_units: "mhs",
                  $temp, $fan, uptime, $ver, ar: [.accept, .reject], $algo}' <<< "$stats_raw")
    khs=$(jq -r '.total_khs' <<< "$stats")
  fi
else #log parser for ver lower than 0.4.0
  # Calc log freshness
  local diffTime=`get_log_time_diff`
  local maxDelay=120

  # If log is fresh the calc miner stats or set to null if not
  if [ "$diffTime" -lt "$maxDelay" ]; then
    #INFO : 2019/09/06 22:11:00.736198 Hash Rate (MH/s):  15.94 15.94 15.94 13.70 14.26
    hs=`cat $log_name | grep "Hash Rate (MH/s):" | tail -1 | cut -c 54- | tr ' ' ','`
    khs=`echo "($hs)*1000" | tr ',' '+' | bc`
    hs="[$hs]"
    local hs_units='mhs' # hashes utits
    local uptime=`get_miner_uptime $conf_name` # miner uptime
    #INFO : 2019/09/06 22:11:30.736157 Accept/Reject: 4 / 0
    local acc_rej=[`cat $log_name | tail -100 | grep "Accept/Reject"  | tail -1 | cut -c 50- | tr '/' ',' | tr -d " "`]

  # make JSON
    stats=$(jq -nc \
          --argjson hs "$hs" \
          --arg hs_units "$hs_units" \
          --argjson temp "$temp" \
          --argjson fan "$fan" \
          --arg uptime "$uptime" \
          --argjson ar "$acc_rej" \
          --arg algo "$algo" \
          --arg ver "$ver" \
          '{$hs, $hs_units, $ar, $temp, $fan, $uptime, $algo, $ver}')
  fi
fi

[[ -z $stats ]] && stats="null"
[[ -z $khs ]] && khs=0

# debug output
##echo temp:  $temp
##echo fan:   $fan
#echo stats: $stats
#echo khs:   $khs
