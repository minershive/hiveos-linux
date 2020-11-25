#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$VIOLETMINER_VER
  [[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
  echo $MINER_VER
}


function miner_config_echo() {
  local MINER_VER=$(miner_ver)
  miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/config.json"
}

function miner_config_gen() {

  local MINER_CONFIG="$MINER_DIR/$MINER_VER/config.json"
  mkfile_from_symlink $MINER_CONFIG

  local conf=$(cat $MINER_DIR/$MINER_VER/config_global.json | envsubst)
  local gpus=''
  local nicehash=false
  [[ ${VIOLETMINER_URL,,} =~ 'nicehash' ]] && nicehash=true

  #merge user config options into main config
  if [[ ! -z $VIOLETMINER_USER_CONFIG ]]; then
    while read -r line; do
      [[ -z $line ]] && continue
      if [[ ${line,,} =~ '"devices":' ]]; then
        gpus=`echo "{$line}" | jq -r '.devices[]'`
      elif [[ ${line,,} =~ '"nicehash":' ]]; then
        nicehash=`echo "{$line}" | jq -r '.nicehash'`
      else
        conf=$(jq -s '.[0] * .[1]' <<< "$conf {$line}")
      fi
    done <<< "$VIOLETMINER_USER_CONFIG"
  fi

  # "pools": [
  #     {
  #         "agent": "",
  #         "algorithm": "turtlecoin",
  #         "host": "trtl.pool.mine2gether.com",
  #         "niceHash": false,
  #         "password": "x",
  #         "port": 2225,
  #         "priority": 0,
  #         "rigID": "",
  #         "ssl": false,
  #         "username": "TRTLv2F..."
  #     },
  local priority=0
  local pools=[]
  [[ $VIOLETMINER_TLS -eq 1 ]] && local ssl=true || local ssl=false
  while read -r line;  do
    local host=`cut -d ":" -f 1 <<< "$line"`
    local port=`cut -d ":" -f 2 <<< "$line"`
    local pool=$(jq -nc \
                    --arg agent "" \
                    --arg algorithm "$VIOLETMINER_ALGO" \
                    --arg host "$host" \
                    --arg password "$VIOLETMINER_PASS" \
                    --arg rigID "$VIOLETMINER_WORKER" \
                    --arg username "$VIOLETMINER_TEMPLATE" \
                    '{$agent, $algorithm, $host, "port": '$port', "nicehash": '$nicehash',
                      $password, "priority": '$priority', $rigID, "ssl": '$ssl', $username}')
    pools=`jq --null-input --argjson pools "$pools" --argjson pool "$pool" '$pools + [$pool]'`
    ((priority++))
  done <<< "$VIOLETMINER_URL"

  if [[ -z $pools || $pools == '[]' || $pools == 'null' ]]; then
    echo -e "${RED}No pools configured, using default${NOCOLOR}"
  else
    pools=`jq --null-input --argjson pools "$pools" '{"pools": $pools}'`
    conf=$(jq -s '.[0] * .[1]' <<< "$conf $pools")
  fi


  # "hardwareConfiguration": {
  #     "nvidia": {
  #         "devices": [
  #             {
  #                 "desktopLag": 100.0,
  #                 "enabled": true,
  #                 "id": 0,
  #                 "intensity": 100.0,
  #                 "name": "GeForce GTX 1070"
  #             }
  #         ]
  #     }
  # }
  local devices=[]
  if [[ $gpus == '' ]]; then
    local gpus=`cat $GPU_DETECT_JSON | jq -c '. | to_entries[] | select(.value.brand == "nvidia")' | tr '\n' ','`
    gpus="[${gpus%,}]"
    for (( i = 0; i < `gpu-detect NVIDIA`; i++ )); do
      local gpu=`echo $gpus | jq -r '.['$i'].key'`
      local bus_id=`echo $gpus | jq -r '.['$i'].value.busid[0:2]' | perl -pe '$_=hex;$_.="\n"'`
      local name="GPU$gpu#$bus_id"
      local device=$(jq -nc \
                        --arg name "$name" \
                        '{"desktopLag": 100.0, "enabled": true, "id": '$i', "intensity": 100.0, $name}')
      devices=`jq --null-input --argjson devices "$devices" --argjson device "$device" '$devices + [$device]'`
    done

  else
    local devices=[]
    for i in $gpus; do
      local bus_id=`cat $GPU_DETECT_JSON | jq -r '.['$i'].busid[0:2]'`
      local name="GPU$i#"$(( 0x$bus_id ))
      local device=$(jq -nc \
                        --arg name "$name" \
                        '{"desktopLag": 100.0, "enabled": true, "id": '$i', "intensity": 100.0, $name}')
      devices=`jq --null-input --argjson devices "$devices" --argjson device "$device" '$devices + [$device]'`
    done
  fi
  devices=`jq --null-input --argjson devices "$devices" '{"hardwareConfiguration":{"nvidia":{"devices": $devices}}}'`

  conf=$(jq -s '.[0] * .[1]' <<< "$conf $devices")

  echo "$conf" > $MINER_CONFIG

  local nv_version=`nvidia-smi --help | head -n 1 | awk '{print $NF}' | sed 's/v//' | cut -d '.' -f 1`
  [[ $nv_version -lt 455 ]] && message warning "If you are experiencing crashes, try to update Nvidia driver by running \"nvidia-driver-update 455\""
  exit 0
}
