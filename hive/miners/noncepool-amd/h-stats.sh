#!/usr/bin/env bash

threads=`echo "threads" | nc -w $API_TIMEOUT localhost ${MINER_API_PORT} | tr -d '\0'` #&& echo $threads
if [[ $? -ne 0  || -z $threads ]]; then
  echo -e "${YELLOW}Failed to read $miner stats from localhost:${MINER_API_PORT}${NOCOLOR}"
else
  summary=`echo "summary" | nc -w 2 localhost ${MINER_API_PORT} | tr -d '\0'`
  re=';UPTIME=([0-9]+);' && [[ $summary =~ $re ]] && local uptime=${BASH_REMATCH[1]} #&& echo "Matched" || echo "No match"
  #saving log head to read bus_numbers
  [[ $uptime -lt 60 ]] && head -n 50 ${MINER_LOG_BASENAME}.log > ${MINER_LOG_BASENAME}_head.log
  #khs will calculate from cards; re=';KHS=([0-9\.]+);' && [[ $summary =~ $re ]] && khs=${BASH_REMATCH[1]} #&& echo "Matched" || echo "No match"
  #algo=`echo "$summary" | tr ';' '\n' | grep -m1 'ALGO=' | sed -e 's/.*=//'`
  local algo="sha224"
  local ac=`echo "$summary" | tr ';' '\n' | grep -m1 'ACC=' | sed -e 's/.*=//'`
  local rj=`echo "$summary" | tr ';' '\n' | grep -m1 'REJ=' | sed -e 's/.*=//'`
  local ver=`echo "$summary" | tr ';' '\n' | grep -m1 'VER=' | sed -e 's/.*=//'`
  #stats=`echo $threads | tr '|' '\n' | tr ';' '\n' | tr -cd '\11\12\15\40-\176' | grep -E 'KHS=' | sed -e 's/.*=//' | jq -cs '{khs:.}'`
  striplines=`echo "$threads" | tr '|' '\n' | tr ';' '\n' | tr -cd '\11\12\15\40-\176'`

  #if GPU has 0.0 temp it hanged. ccminer does not mine on this card but shows hashrate
  #cctemps=(`echo "$striplines" | grep 'TEMP=' | sed -e 's/.*=//'`) #echo ${cctemps[@]} | tr " " "\n" #print it in lines
  cckhs=(`echo "$striplines" | grep 'KHS=' | sed -e 's/.*=//'`)

  local bus_ids=""
  local a_fans=""
  local a_temp=""

  for (( i=0; i < ${#cckhs[@]}; i++ )); do

    #cckhs[$i]="84316579.94" #test
    #check Ghs. 1080ti gives ~64mh (64000kh) on lyra. when it's showing ghs then load is 0 on gpu
    #if [[ `echo ${cckhs[$i]} | awk '{ print ($1 >= 1000000) ? 1 : 0 }'` == 1 ]]; then #hash is in Ghs, >= 1000000 khs
    if [[ `echo ${cckhs[$i]} | awk '{ print ($1 >= 1000) ? 1 : 0 }'` == 1 ]]; then # > 1Mh
      #[[ -z $nvidiastats ]] && nvidiastats=`gpu-stats nvidia` #a bit overhead in calling nvidia-smi again
      local busid=`cat ${MINER_LOG_BASENAME}_head.log | grep -A1 "Card $i is at pci slot name"| tail -1 | cut -d " " -f 3` #ccbus is decimal
      bus_ids+=$busid" "

      #convert busid to hex
      busid=`echo $busid | awk '{ printf("%02x:00.0", $1) }'`
      local gpu_i=`echo "$gpu_stats" | jq ".busids|index(\"$busid\")"`
      if [[ $gpu_i != "null" ]]; then #can be null on failed driver
        local t_fan=`echo "$gpu_stats" | jq -r ".fan[$gpu_i]"`
        a_fans+=$t_fan" "

        local t_temp=`echo "$gpu_stats" | jq -r ".temp[$gpu_i]"`
        a_temp+=$t_temp" "
      else
        a_fans+="0 "
        a_temp+="0 "
        cckhs[$i]="0.0"
      fi
    fi

    #khs=`echo $khs ${cckhs[$i]} | awk '{ printf("%.3f", $1 + $2) }'`
    khs=`echo $khs ${cckhs[$i]} | awk '{ printf("%.3f", $1 + $2) }'`
  done

  [[ $cpu_indexes_array != '[]' ]] && #remove Internal Gpus
    temp=$(jq -c "del(.$cpu_indexes_array)" <<< $temp) &&
    fan=$(jq -c "del(.$cpu_indexes_array)" <<< $fan)

  khs=`echo $khs | sed -E 's/^( *[0-9]+\.[0-9]([0-9]*[1-9])?)0+$/\1/'` #1234.100 -> 1234.1

  stats=$(jq -n \
    --arg algo "$algo" \
    --argjson hs "`echo ${cckhs[@]} | tr " " "\n" | jq -cs '.'`" \
    --arg hs_units "khs" \
    --argjson fan "`echo ${a_fans[@]} | tr " " "\n" | jq -cs '.'`" \
    --argjson temp "`echo ${a_temp[@]} | tr " " "\n" | jq -cs '.'`" \
    --argjson bus_numbers "`echo ${bus_ids[@]} | tr " " "\n" | jq -cs '.'`" \
    --arg ver "$ver" \
    '{$hs, $hs_units, $temp, $fan, $bus_numbers, uptime:'$uptime', ar: ['$ac', '$rj'], $algo, $ver}')
fi
