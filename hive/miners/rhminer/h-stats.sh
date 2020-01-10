#!/usr/bin/env bash

get_cores_hs(){
  local i=0
  local l_khs=$1
  local l_num_cores=$2
  local l_hs=()
  for (( i=0; i < ${l_num_cores}; i++ )); do
    l_hs+=`echo $l_khs | awk '{ printf($1/'$l_num_cores') }'`" "
  done
  echo $l_hs
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

stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://localhost:$MINER_API_PORT`
if [[ $? -ne 0 || -z $stats_raw ]]; then
  echo -e "${YELLOW}Failed to read $miner from localhost:${MINER_API_PORT}${NOCOLOR}"
else
  #optiminer sorts it's keys incorrectly, e.g. "GPU1", "GPU10", "GPU2", fixing that with sed hack by replacing "1":{ with "01":{
  khs=`echo $stats_raw | jq '.speed' | awk '{print $1/1000}'`

  local threads=`echo $stats_raw | jq '.infos[0].threads'`
  local hs=`get_cores_hs $khs $threads`
  local temp=`get_cpu_temps $threads`
  hs=`echo ${hs[@]} | tr " " "\n" | jq -cs '.'`
  temp=`echo ${temp[@]} | tr " " "\n" | jq -cs '.'`

  stats=$(jq --arg total_khs "$khs" \
             --argjson hs "$hs" \
             --arg algo "randomhash" \
             --arg ver `miner_ver` \
             --argjson temp "$temp" \
             '{$total_khs, $hs, $algo, $temp, uptime: .uptime, ar: [.accepted, .rejected, .failed], $ver}' <<< "$stats_raw")
fi


# {
#   "infos": [
#     {
#       "name": "CPU",
#       "threads": 6,
#       "speed": 1093,
#       "accepted": 40,
#       "rejected": 0,
#       "temp": 0,
#       "fan": 0
#     }
#   ],
#   "speed": 1093,
#   "accepted": 40,
#   "rejected": 0,
#   "failed": 0,
#   "uptime": 2590,
#   "extrapayload": "",
#   "stratum.server": "pasc-eu1.nanopool.org:15556",
#   "stratum.user": "86646-64.daaa095b4dcde5a6.AT_HS",
#   "diff": 1.526e-05
# }
