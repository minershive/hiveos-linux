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

  local conf="--address=`echo ${NONCERPRO_KADENA_TEMPLATE} | tr -d ' '` \
              --server=${NONCERPRO_KADENA_HOST} \
              --port=${NONCERPRO_KADENA_PORT} \
              ${NONCERPRO_KADENA_USER_CONFIG}"
  echo "$conf" > $MINER_CONFIG
}
