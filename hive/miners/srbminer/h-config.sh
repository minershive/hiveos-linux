#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$SRBMINER_VER
  [[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
  echo $MINER_VER
}


function miner_config_echo() {
  local MINER_VER=`miner_ver`
  miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/$MINER_NAME.conf"
  miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/pools.txt"
}

function miner_config_gen() {
  local MINER_CONFIG="$MINER_DIR/$MINER_VER/$MINER_NAME.conf"
  mkfile_from_symlink $MINER_CONFIG
  local MINER_POOLS="$MINER_DIR/$MINER_VER/pools.txt"
  mkfile_from_symlink $MINER_POOLS

  #generating pool template
  [[ $SRBMINER_TLS -eq 1 ]] && local pool='{ "pool_use_tls": true }' || local pool={}
  pool=$(jq -s '.[0] * .[1]' <<< "$pool {\"wallet\": \"$SRBMINER_TEMPLATE\"}")
  pool=$(jq -s '.[0] * .[1]' <<< "$pool {\"password\": \"$SRBMINER_PASS\"}")
  pool=$(jq -s '.[0] * .[1]' <<< "$pool {\"algorithm\": \"$SRBMINER_ALGO\"}")
  [[ ! -z $SRBMINER_WORKER ]] && pool=$(jq -s '.[0] * .[1]' <<< "$pool {\"worker\": \"$SRBMINER_WORKER\"}")
  [[ ${SRBMINER_URL,,} = *"nicehash"* ]] && pool=$(jq -s '.[0] * .[1]' <<< "$pool {\"nicehash\": true}")
  #generating pool_config
  local pool_config="{\"pools\": ["
  while read -r line; do
    [[ -z $line ]] && continue
    pool=$(jq -cs '.[0] * .[1]' <<< "$pool {\"pool\": \"$line\"}")
    [[ $pool_config != "{\"pools\": [" ]] && pool_config+=", "
    pool_config+=$pool
  done <<< "$SRBMINER_URL"
  pool_config+="]}"
  echo "$pool_config" | jq . > $MINER_POOLS

  #generating config
  echo "--algorithm $SRBMINER_ALGO --api-enable --api-port $MINER_API_PORT $SRBMINER_USER_CONFIG" > $MINER_CONFIG
}
