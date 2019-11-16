#!/usr/bin/env bash

stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:$MINER_API_PORT/stat`
if [[ $? -ne 0  || -z $stats_raw ]]; then
  echo -e "${YELLOW}Failed to read $miner stats_raw from localhost:${MINER_API_PORT}${NOCOLOR}"
else
  khs=`echo $stats_raw | jq -r '.devices[].speed' | awk '{s+=$1} END {print s/1000}'` #sum up and convert to khs
  if [ $GMINER_ALGO == "150_5" ]; then
    local ac=$(jq -r '.total_accepted_shares' <<< "$stats_raw")
    local rj=$(jq -r '.total_rejected_shares' <<< "$stats_raw")
  else
    local ac=$(jq '[.devices[].accepted_shares] | add' <<< "$stats_raw")
    local rj=$(jq '[.devices[].rejected_shares] | add' <<< "$stats_raw")
  fi

  #All fans speed array
  local fan=$(jq -r ".fan | .[]" <<< $gpu_stats)

  #All temp array
  local temp=$(jq -r ".temp | .[]" <<< $gpu_stats)

  #gminer's busid array
  local bus_id_array=$(jq -r '[.devices[].bus_id[5:7]] | .[]' <<< "$stats_raw")
  local bus_numbers=$(echo "$bus_id_array" | awk '{printf("%d\n", "0x"$1)}' | jq -sc .)
  #All busid array
  local all_bus_ids_array=(`echo "$gpu_detect_json" | jq -r '[ . | to_entries[] | select(.value) | .value.busid [0:2] ] | .[]'`)

  #Formating arrays
#  bus_id_array=`sed 's/\n/ /' <<< $bus_id_array`
#  fan=`sed 's/\n/ /' <<< $fan`
  bus_id_array=`tr '\n' ' ' <<< $bus_id_array`
  fan=`tr '\n' ' ' <<< $fan`
  temp=`tr '\n' ' ' <<< $temp`
  IFS=' ' read -r -a bus_id_array <<< "$bus_id_array"
  IFS=' ' read -r -a fan <<< "$fan"
  IFS=' ' read -r -a temp <<< "$temp"
  #busid equality
  local fans_array=
  local temp_array=
  for ((i = 0; i < ${#all_bus_ids_array[@]}; i++)); do
    for ((j = 0; j < ${#bus_id_array[@]}; j++)); do
      if [[ "$(( 0x${all_bus_ids_array[$i]} ))" -eq "$(( 0x${bus_id_array[$j]} ))" ]]; then
        fans_array+=("${fan[$i]}")
        temp_array+=("${temp[$i]}")
      fi
    done
  done

  [[ -z $GMINER_ALGO ]] && GMINER_ALGO="144_5"
  [[ "$GMINER_ALGO" == "beamhashI" ]] && GMINER_ALGO="150_5"
  [[ "$GMINER_ALGO" == "beamhash" ]] && GMINER_ALGO="equihash 150/5"
  [[ "$GMINER_ALGO" == "beamhashII" ]] && GMINER_ALGO="equihash 150/5/3"

  #local temp=$(jq -c "[.temp$nvidia_indexes_array]" <<< $gpu_stats)

  stats=$(jq -c \
        --argjson temp "`echo "${temp_array[@]}" | jq -s . | jq -c .`" \
        --argjson fan "`echo "${fans_array[@]}" | jq -s . | jq -c .`" \
        --arg ac "$ac" --arg rj "$rj" \
        --argjson bus_numbers "$bus_numbers" --arg algo "$GMINER_ALGO"  \
        --arg ver `miner_ver` \
        '{hs: [.devices[].speed], hs_units: "hs", $temp, $fan,
        uptime: .uptime, ar: [$ac, $rj], $bus_numbers, $algo, $ver}' <<< "$stats_raw")
fi

