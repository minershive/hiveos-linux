#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$ZJAZZ_CUDA_VER
  [[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
  echo $MINER_VER
}

function miner_config_echo() {
  local MINER_VER=`miner_ver`
  miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/zjazz-cuda.conf"
}

function miner_config_gen() {
  local MINER_CONFIG="$MINER_DIR/$MINER_VER/zjazz-cuda.conf"
  mkfile_from_symlink $MINER_CONFIG

  [[ -z $ZJAZZ_CUDA_TEMPLATE ]] && echo -e "${YELLOW}ZJAZZ_CUDA_TEMPLATE is empty${NOCOLOR}" && return 1
  [[ -z $ZJAZZ_CUDA_URL ]] && echo -e "${YELLOW}ZJAZZ_CUDA_URL is empty${NOCOLOR}" && return 1

  [[ ! -z $ZJAZZ_CUDA_ALGO ]] && algo=$ZJAZZ_CUDA_ALGO || algo="bitcash"
  local conf="-a $algo"

  for url in $ZJAZZ_CUDA_URL; do
    grep -q "://" <<< $url
    [[ $? -ne 0 ]] && url="stratum+tcp://${url}"
    conf+=" -o $url"
    conf+=" -u $ZJAZZ_CUDA_TEMPLATE"
    [[ ! -z $ZJAZZ_CUDA_PASS ]] && conf+=" -p $ZJAZZ_CUDA_PASS"
  done

  [[ ! -z $ZJAZZ_CUDA_USER_CONFIG ]] && conf+=" $ZJAZZ_CUDA_USER_CONFIG"

  conf+=" -b 127.0.0.1:${MINER_API_PORT}"

  echo "$conf" > $MINER_CONFIG
}
