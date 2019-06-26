#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$NONCERPRO_OPENCL_VER
  [[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
  echo $MINER_VER
}

function miner_config_echo() {
  local MINER_VER=`miner_ver`
  miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/miner.conf"
}

function miner_config_gen() {
  local MINER_CONFIG="$MINER_DIR/$MINER_VER/miner.conf"
  mkfile_from_symlink $MINER_CONFIG

  [[ -z $NONCERPRO_OPENCL_TEMPLATE ]] && echo -e "${YELLOW}NONCERPRO_OPENCL_TEMPLATE is empty${NOCOLOR}" && return 1
  [[ -z $NONCERPRO_OPENCL_HOST ]] && echo -e "${YELLOW}NONCERPRO_OPENCL_HOST is empty${NOCOLOR}" && return 1
  [[ -z $NONCERPRO_OPENCL_PORT ]] && echo -e "${YELLOW}NONCERPRO_OPENCL_PORT is empty${NOCOLOR}" && return 1

  [[ ! -z $NONCERPRO_OPENCL_WORKER ]] && local worker="--name=$NONCERPRO_OPENCL_WORKER" || local worker=''

  local conf="--address=`echo ${NONCERPRO_OPENCL_TEMPLATE} | tr -d ' '` \
              --server=${NONCERPRO_OPENCL_HOST} \
              --port=${NONCERPRO_OPENCL_PORT} \
              ${worker} \
              ${NONCERPRO_OPENCL_USER_CONFIG}"
  echo "$conf" > $MINER_CONFIG
}
