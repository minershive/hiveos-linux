#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$NONCERPRO_KADENA_VER
  [[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
  echo $MINER_VER
}

function miner_config_echo() {
  local MINER_VER=`miner_ver`
  miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/miner.conf"
}

function miner_config_gen() {
  local MINER_CONFIG="$MINER_DIR/$MINER_VER/miner.conf"
  echo $MINER_CONFIG
  mkfile_from_symlink $MINER_CONFIG

  [[ $NONCERPRO_KADENA_CUDA -eq 1 ]] && local platform="nvidia" || local platform="amd"

  local conf=--address=`echo $NONCERPRO_KADENA_TEMPLATE | tr -d ' '`
  conf+=" --server=$NONCERPRO_KADENA_HOST"
  conf+=" --port=$NONCERPRO_KADENA_PORT"
  conf+=" --platform $platform"
  [[ ! -z $NONCERPRO_KADENA_USER_CONFIG ]] && conf+=" ${NONCERPRO_KADENA_USER_CONFIG}"

  echo "$conf" > $MINER_CONFIG
}
