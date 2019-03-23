#!/usr/bin/env bash

local threads=`echo "threads" | nc -w $API_TIMEOUT localhost ${MINER_API_PORT} | tr -d '\0'` #&& echo $threads
if [[ $? -ne 0  || -z $threads ]]; then
  echo -e "${YELLOW}Failed to read $miner stats from localhost:${MINER_API_PORT}${NOCOLOR}"
else
  local summary=`echo "summary" | nc -w 2 localhost ${MINER_API_PORT} | tr -d '\0'`
  local re=';UPTIME=([0-9]+);' && [[ $summary =~ $re ]] && local uptime=${BASH_REMATCH[1]} #&& echo "Matched" || echo "No match"
  #khs will calculate from cards; re=';KHS=([0-9\.]+);' && [[ $summary =~ $re ]] && khs=${BASH_REMATCH[1]} #&& echo "Matched" || echo "No match"
  local algo=`echo "$summary" | tr ';' '\n' | grep -m1 'ALGO=' | sed -e 's/.*=//'`
  local ac=`echo "$summary" | tr ';' '\n' | grep -m1 'ACC=' | sed -e 's/.*=//'`
  local rj=`echo "$summary" | tr ';' '\n' | grep -m1 'REJ=' | sed -e 's/.*=//'`
  local ver=`echo "$summary" | tr ';' '\n' | grep -m1 'VER=' | sed -e 's/.*=//'`
  khs=`echo "$summary" | tr ';' '\n' | grep -v 'KHS=' | grep -m1 'HS=' | sed -e 's/.*=//' |  awk '{ printf($1/1000) }'`
  local hs_units="hs"
  #stats=`echo $threads | tr '|' '\n' | tr ';' '\n' | tr -cd '\11\12\15\40-\176' | grep -E 'KHS=' | sed -e 's/.*=//' | jq -cs '{khs:.}'`
  local striplines=`echo "$threads" | tr '|' '\n' | tr ';' '\n' | tr -cd '\11\12\15\40-\176'`
  local cckhs=(`echo "$striplines" | grep -v 'KHS=' | grep 'HS=' | sed -e 's/.*=//'`)

  stats=$(jq -n \
    --arg total_khs "$khs" \
    --arg uptime "$uptime" --arg algo "$algo" \
    --argjson hs "`echo ${cckhs[@]} | tr " " "\n" | jq -cs '.'`" \
    --arg hs_units "$hs_units" \
    --argjson temp "`jq -c "[.temp$nvidia_indexes_array]" <<< $gpu_stats`" \
    --argjson fan "`jq -c "[.fan$nvidia_indexes_array]" <<< $gpu_stats`" \
    --arg ac "$ac" --arg rj "$rj" \
    --arg ver "$ver" \
    '{$total_khs, $hs, $hs_units, $temp, $fan, $uptime, ar: [$ac, $rj], $algo, $ver}')
fi

[[ -z $khs ]] && khs=0
[[ -z $stats ]] && stats="null"
