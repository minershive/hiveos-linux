#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$NQ_MINER_VER
  [[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
  echo $MINER_VER
}

function miner_config_echo() {
  local MINER_VER=`miner_ver`
  miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/miner.conf"
}

function miner_config_gen() {
  local MINER_CONFIG="$MINER_DIR/$MINER_VER/$MINER_NAME.conf"
  mkfile_from_symlink $MINER_CONFIG

  local pool=`head -n 1 <<< "$NQ_MINER_URL"`

  local conf="--pool $pool --address '$NQ_MINER_TEMPLATE'"

  [[ ! -z $NQ_MINER_WORKER ]] && conf+=" --name '$NQ_MINER_WORKER'"

  [[ ! -z $NQ_MINER_USER_CONFIG ]] && conf+=" $NQ_MINER_USER_CONFIG"

  if [[ "$NQ_MINER_CUDA" -eq 1 ]]; then
    conf+=" --type cuda"
  else
    conf+=" --type opencl"
  fi

  conf+=" --api 127.0.0.1:3110"

  echo "$conf" > $MINER_CONFIG
}
