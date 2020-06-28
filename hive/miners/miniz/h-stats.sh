#!/usr/bin/env bash

get_miner_uptime(){
  local a=0
  let a=`date +%s`-`stat --format='%Y' /run/hive/miners/miniz/miniz.conf`
  echo $a
}

stats_raw=`curl --silent --connect-timeout 2  --max-time $API_TIMEOUT localhost:$MINER_API_PORT -X '{"id":"0", "method":"getstat"}'`
if [[ $? -ne 0 || -z $stats_raw ]]; then
  echo -e "${YELLOW}Failed to read $miner from ${WEB_HOST}:{$WEB_PORT}${NOCOLOR}"
else
  khs=`echo $stats_raw | jq -r '.result[].speed_sps'  | awk '{s+=$1} END {print s/1000}'` #"
  local ac=$(jq '[.result[].accepted_shares] | add' <<< "$stats_raw")
  local rj=$(jq '[.result[].rejected_shares] | add' <<< "$stats_raw")

  [[ ! -z $(echo $stats_raw | jq -r ".result[0].busid") ]] && local busid=$(echo $(jq ".result[].busid"<<< "$stats_raw"|awk -F: '{ printf ",%d\n",("0x"$2) }'|cut -b2-)|tr ' ' ',') #'

  local uptime=`get_miner_uptime`
  local algo=$(jq ".algorithm"<<< "$stats_raw"|tr -d '"' |tr ',' "/" | tr '[:upper:]' '[:lower:]')
  
# Hardcode remapping to avoid warning at miner start
  [[ $algo == "equihash 144/5s" ]] && algo="beamhashv3"
#

  stats=$(jq -c --arg ac "$ac" --arg rj "$rj" --arg uptime "$uptime" --arg hs_units "hs" \
                --arg algo "$algo" \
                --argjson bus_numbers "[$busid]" \
                '{hs: [.result[].speed_sps], $hs_units,
                  temp: [.result[].temperature], fan: [.result[].gpu_fan_speed], uptime: '$uptime', ar: ['$ac', '$rj'],
                  $bus_numbers, $algo, ver: .version}' <<< "$stats_raw")
fi

  [[ -z $khs ]] && khs=0
  [[ -z $stats ]] && stats="null"
