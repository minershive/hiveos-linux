#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$CORTEX_MINER_VER
  [[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
  echo $MINER_VER
}


function miner_config_echo() {
  local MINER_VER=`miner_ver`
  miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/$MINER_NAME.conf"
}

function miner_config_gen() {

  local MINER_CONFIG="$MINER_DIR/$MINER_VER/$MINER_NAME.conf"
  mkfile_from_symlink $MINER_CONFIG

  local conf=

  [[ -z $CORTEX_MINER_TEMPLATE ]] && echo -e "${YELLOW}CORTEX_MINER_TEMPLATE is empty${NOCOLOR}" && return 1
  [[ -z $CORTEX_MINER_URL ]] && echo -e "${YELLOW}CORTEX_MINER_URL is empty${NOCOLOR}" && return 1

  local i=
  local pool_num=
  for pool in $CORTEX_MINER_URL; do
    [[ ! -z $i ]] && pool_num="_$i"
    conf+="-pool_uri$pool_num=$pool"
    let i++
  done

  conf+=" -account=$CORTEX_MINER_TEMPLATE"

  [[ ! -z $CORTEX_MINER_WORKER ]] && conf+=" -worker $CORTEX_MINER_WORKER"

  [[ ! -z $CORTEX_MINER_USER_CONFIG ]] && conf+=" $CORTEX_MINER_USER_CONFIG"

  if [[ `echo $CORTEX_MINER_USER_CONFIG | grep -c "\-devices"` -eq 0 ]]; then
    devices=
    for ((i=0; i < `gpu-detect NVIDIA`; i++)); do
      [[ ! -z $devices ]] && devices+=","
      devices+=$i
    done

    conf+=" -devices=$devices"
  fi

  echo $conf > $MINER_CONFIG
}
