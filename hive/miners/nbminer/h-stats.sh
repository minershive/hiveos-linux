#!/usr/bin/env bash

  stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:${MINER_API_PORT}/api/v1/status`
  if [[ $? -ne 0 || -z $stats_raw ]]; then
    echo -e "${YELLOW}Failed to read $miner from 127.0.0.1:{$MINER_API_PORT}${NOCOLOR}"
  else
    khs=`echo $stats_raw | jq '.miner.total_hashrate_raw' | awk '{s+=$1} END {printf("%.4f",s/1000)}'` #"
    khs2=`echo $stats_raw | jq '.miner.total_hashrate2_raw' | awk '{s+=$1} END {printf("%.4f",s/1000)}'` #"

    local uptime=$(( `date +%s` - $(jq '.start_time' <<< "$stats_raw") ))
    local hs_units="hs"
    local algo=; local algo2=;
    [[ -z $NBMINER_ALGO ]] && NBMINER_ALGO="ethash"
 #   [[ $NBMINER_ALGO == "tensority_ethash" ]] && algo="tensority" && algo2="ethash" || algo=$NBMINER_ALGO
    case $NBMINER_ALGO in
       tensority_ethash)
                        algo="tensority"
                        algo2="ethash"
                      ;;
       eaglesong_ethash)
                        algo="eaglesong"
                        algo2="ethash"
                      ;;
                      *)
                        algo=$NBMINER_ALGO
                      ;;
    esac

    #not working at the moment, just gives numbers from 0 to n, not bus numbers
    #local bus_numbers=$(echo $stats_raw | jq .miner | jq -r '[ .miners | to_entries[] | select(.value) | .key|tonumber ]') #'

    if [[ ! -z $NBMINER_URL2 ]]; then
      #dual mode
      stats=$(jq -c --arg uptime "$uptime" \
                    --arg algo "$algo" \
                    --arg hs_units "$hs_units" \
                    --arg algo2 "$algo2" \
                    --arg hs_units2 "$hs_units" \
                    --arg total_khs "$khs" \
                    --arg total_khs2 "$khs2" \
                   '{$total_khs, hs: [.miner.devices[].hashrate_raw], $hs_units,
                    temp: [.miner.devices[].temperature], fan: [.miner.devices[].fan], $uptime, $algo,
                    ar: [.stratum.accepted_shares, .stratum.rejected_shares],
                    $total_khs2, hs2: [.miner.devices[].hashrate2_raw], $hs_units2,
                    $algo2, ver: .version}' <<< "$stats_raw")
    else
      #single mode
      stats=$(jq -c --arg uptime "$uptime" \
                    --arg algo "$algo" \
                    --arg hs_units "$hs_units" \
                    --arg total_khs "$khs" \
                    '{$total_khs, hs: [.miner.devices[].hashrate_raw], $hs_units,
                    temp: [.miner.devices[].temperature], fan: [.miner.devices[].fan], $uptime, $algo,
                    ar: [.stratum.accepted_shares, .stratum.rejected_shares], ver: .version}' <<< "$stats_raw")
    fi
  fi

  [[ -z $khs ]] && khs=0
  [[ -z $stats ]] && stats="null"
