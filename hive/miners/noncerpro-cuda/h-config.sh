#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$NONCERPRO_CUDA_VER
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

  [[ -z $NONCERPRO_CUDA_TEMPLATE ]] && echo -e "${YELLOW}NONCERPRO_CUDA_TEMPLATE is empty${NOCOLOR}" && return 1
  [[ -z $NONCERPRO_CUDA_HOST ]] && echo -e "${YELLOW}NONCERPRO_CUDA_HOST is empty${NOCOLOR}" && return 1
  [[ -z $NONCERPRO_CUDA_PORT ]] && echo -e "${YELLOW}NONCERPRO_CUDA_PORT is empty${NOCOLOR}" && return 1

  [[ ! -z $NONCERPRO_CUDA_WORKER ]] && local worker="--name=$NONCERPRO_CUDA_WORKER" || local worker=''

  local conf="--address=`echo ${NONCERPRO_CUDA_TEMPLATE} | tr -d ' '` \
              --server=${NONCERPRO_CUDA_HOST} \
              --port=${NONCERPRO_CUDA_PORT} \
              ${worker} \
              ${NONCERPRO_CUDA_USER_CONFIG}"
  echo "$conf" > $MINER_CONFIG
}
