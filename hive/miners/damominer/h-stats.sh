#!/usr/bin/env bash

function hex2dec_json() {
  local a=; local b=
  for a in $1; do
    [[ $a != "null" ]] && b+=" $(( 0x${a} ))" || b+=" $a"
  done
  echo ${b[@]} | tr " " "\n" | jq -cs '.'
}

  stats_raw=`echo '{"id": 1,"jsonrpc": "2.0","method": "miner_getstatdetail"}' | nc -w $API_TIMEOUT localhost ${MINER_API_PORT} | jq '.result'`
  if [[ $? -ne 0 || -z $stats_raw ]]; then
    echo -e "${YELLOW}Failed to read $miner from 127.0.0.1:{$MINER_API_PORT}${NOCOLOR}"
  else
    local bus_ids=`echo $stats_raw | jq -r '.devices[].hardware.pci [0:2]'`
    local bus_numbers=`hex2dec_json "$bus_ids"`
    local api_fan=`echo $stats_raw | jq -c '[.devices[].hardware.sensors[1]]'`
    local api_temp=`echo $stats_raw | jq -c '[.devices[].hardware.sensors[0]]'`
    local hs_units="hs"
    local uptime=`echo $stats_raw | jq -r '.host.runtime'`
    local hs_hex=`echo $stats_raw | jq -r '.devices[].mining.hashrate' | cut -d x -f 2`

    local hs_dec=`hex2dec_json "$hs_hex"`
    khs=`echo $hs_dec | jq -r '.[]' | awk '{s+=$1} END {printf("%.4f",s/1000)}'` #"
    local hs2_hex=`echo $stats_raw | jq -r '.devices[].mining.hashrate_sc' | cut -d x -f 2`
    local hs2_dec=`hex2dec_json "$hs2_hex"`
    khs2=`echo $hs2_dec | jq -r '.[]' | awk '{s+=$1} END {printf("%.4f",s/1000)}'` #"

    local acc=`echo $stats_raw | jq -r '.mining.shares[0]'`
    local rej=`echo $stats_raw | jq -r '.mining.shares[1]'`
    local inv=`echo $stats_raw | jq -r '.mining.shares[2]'`
    local inv_gpu=`echo $stats_raw | jq -r '.devices[].mining.shares[2]'`
    ing_gpu=`echo ${inv_gpu[@]} | tr " " "\;"`

    local acc2=`echo $stats_raw | jq -r '.mining.shares_sc[0]'`
    local rej2=`echo $stats_raw | jq -r '.mining.shares_sc[1]'`
    local inv2=`echo $stats_raw | jq -r '.mining.shares_sc[2]'`

    local algo=; local algo2=;
    [[ -z $DAMOMINER_ALGO ]] && DAMOMINER_ALGO="ethash"
    case $DAMOMINER_ALGO in
       eth_ckb)
          algo="ethash"
          algo2="eaglesong"
        ;;
       eth_hns)
          algo="ethash"
          algo2="bl2bsha3"
        ;;
       ckb)
           algo="eaglesong"
         ;;
       eth)
           algo="ethash"
         ;;
       *)
          algo=$DAMOMINER_ALGO
        ;;
    esac

    if [[ $DAMOMINER_ALGO =~ '_' ]]; then
      #dual mode
      stats=$(jq -nc --arg uptime "$uptime" \
                    --arg algo "$algo" \
                    --arg hs_units "$hs_units" \
                    --arg algo2 "$algo2" \
                    --arg hs_units2 "$hs_units" \
                    --arg total_khs "$khs" \
                    --arg total_khs2 "$khs2" \
                    --arg ver "`miner_ver`" \
                    --argjson bus_numbers "$bus_numbers" \
                    --argjson fan "$api_fan" --argjson temp "$api_temp" \
                    --argjson hs "$hs_dec" --argjson hs2 "$hs2_dec" \
                    --arg acc "$acc" --arg rej "$rej" \
                    --arg inv "$inv" --arg inv_gpu "$ing_gpu" \
                    --arg acc2 "$acc2" --arg rej2 "$rej2" \
                    --arg inv2 "$inv2"  \
                    '{$total_khs, $hs, $hs_units,
                    $temp, $fan, $uptime, $algo, ar:[$acc, $rej, $inv, $inv_gpu],
                    $total_khs2, $hs2, $hs_units2, ar2:[$acc2, $rej2, $inv2, $inv_gpu],
                    $algo2, $bus_numbers, $ver}')
    else
      #single mode
      stats=$(jq -nc --arg uptime "$uptime" \
                    --arg algo "$algo" \
                    --arg hs_units "$hs_units" \
                    --arg total_khs "$khs" \
                    --arg ver "`miner_ver`" \
                    --argjson bus_numbers "$bus_numbers" \
                    --argjson fan "$api_fan" --argjson temp "$api_temp" \
                    --argjson hs "$hs_dec" \
                    --arg acc "$acc" --arg rej "$rej" \
                    --arg inv "$inv" --arg inv_gpu "$ing_gpu" \
                    '{$total_khs, $hs, $hs_units,
                    $temp, $fan, $uptime, $algo, ar:[$acc, $rej, $inv, $inv_gpu],
                    $bus_numbers, $ver}')
    fi
  fi


  [[ -z $khs ]] && khs=0
  [[ -z $stats ]] && stats="null"

  # debug
  # echo uptime=$uptime
  # echo algo=$algo
  # echo hs_units=$hs_units
  # echo algo2=$algo2
  # echo hs_units2=$hs_units
  # echo total_khs=$khs
  # echo total_khs2=$khs2
  # echo ver=`miner_ver`
  # echo bus_numbers=$bus_numbers
  # echo fan=$api_fan
  # echo temp=$api_temp
  # echo hs=$hs_dec
  # echo hs2=$hs2_dec
  # echo DAMOMINER_URL2=$DAMOMINER_URL2
  # echo $stats
