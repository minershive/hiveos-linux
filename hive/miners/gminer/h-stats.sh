#!/usr/bin/env bash

stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:$MINER_API_PORT/stat`
if [[ $? -ne 0  || -z $stats_raw ]]; then
  echo -e "${YELLOW}Failed to read $miner stats_raw from localhost:${MINER_API_PORT}${NOCOLOR}"
else
  khs=`echo $stats_raw | jq -r '.devices[].speed' | awk '{s+=$1} END {printf("%.4f",s/1000)}'` #sum up and convert to khs
  if [ $GMINER_ALGO == "150_5" ]; then
    local ac=$(jq -r '.total_accepted_shares' <<< "$stats_raw")
    local rj=$(jq -r '.total_rejected_shares' <<< "$stats_raw")
  else
    local ac=$(jq '[.devices[].accepted_shares] | add' <<< "$stats_raw")
    local rj=$(jq '[.devices[].rejected_shares] | add' <<< "$stats_raw")
  fi
  # set -x
  #All fans speed array
  local fan=$(jq -r ".fan | .[]" <<< $gpu_stats)
  #All temp array
  local temp=$(jq -r ".temp | .[]" <<< $gpu_stats)

  #All busid array
  local all_bus_ids_array=(`echo "$gpu_detect_json" | jq -r '[ . | to_entries[] | select(.value) | .value.busid [0:2] ] | .[]'`)
  #Formating arrays

  #gminer's busid array
  local bus_id_array=(`jq -r '.devices[].bus_id[5:7]' <<< "$stats_raw"`)
  local bus_numbers=()
  local idx=0
  for gpu in ${bus_id_array[@]}; do
     bus_numbers[idx]=$((16#$gpu))
     idx=$((idx+1))
  done

  fan=`tr '\n' ' ' <<< $fan`
  temp=`tr '\n' ' ' <<< $temp`
  #IFS=' ' read -r -a bus_id_array <<< "$bus_id_array"
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

  if [[ "$GMINER_ALGO2" == "eaglesong" || "$GMINER_ALGO2" == "blake2s" || "$GMINER_ALGO2" == "handshake" ]]; then
    local total_khs2=`echo $stats_raw | jq -r '.devices[].speed2' | awk '{s+=$1} END {printf("%.4f",s/1000)}'` #sum up and convert to khs

    local algo2="eaglesong"
    local ac2=$(jq '[.devices[].accepted_shares2] | add' <<< "$stats_raw")
    local rj2=$(jq '[.devices[].rejected_shares2] | add' <<< "$stats_raw")
    stats=$(jq -c \
          --argjson temp "`echo "${temp_array[@]}" | jq -s . | jq -c .`" \
          --argjson fan "`echo "${fans_array[@]}" | jq -s . | jq -c .`" \
          --arg ac "$ac" --arg rj "$rj" \
          --arg ac2 "$ac2" --arg rj2 "$rj2" \
          --argjson bus_numbers "`echo "${bus_numbers[@]}" | jq -sc .`" \
          --arg algo "$GMINER_ALGO" --arg algo2 "$GMINER_ALGO2" \
          --arg ver `miner_ver` \
          --arg total_khs "$khs" --arg total_khs2 "$total_khs2" \
          '{hs: [.devices[].speed], hs_units: "hs", ar: [$ac, $rj], $algo, $total_khs,
            hs2: [.devices[].speed2], hs_units2: "hs", ar2: [$ac2, $rj2], $algo2, $total_khs2,
            $bus_numbers, $temp, $fan, uptime: .uptime, $ver}' <<< "$stats_raw")
  else
    stats=$(jq -c \
          --argjson temp "`echo "${temp_array[@]}" | jq -s . | jq -c .`" \
          --argjson fan "`echo "${fans_array[@]}" | jq -s . | jq -c .`" \
          --arg ac "$ac" --arg rj "$rj" \
          --argjson bus_numbers "`echo "${bus_numbers[@]}" | jq -sc .`" \
          --arg algo "$GMINER_ALGO"  \
          --arg ver `miner_ver` \
          '{hs: [.devices[].speed], hs_units: "hs", ar: [$ac, $rj], $algo,
            $bus_numbers, $temp, $fan, uptime: .uptime, $ver}' <<< "$stats_raw")
  fi
fi
