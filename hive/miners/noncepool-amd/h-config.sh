#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$NONCEPOOL_AMD_VER
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

  [[ -z $NONCEPOOL_AMD_TEMPLATE ]] && echo -e "${YELLOW}NONCEPOOL_AMD_TEMPLATE is empty${NOCOLOR}" && return 1
  if [[ $NONCEPOOL_AMD_TMPFS -eq 1 ]]; then
    ln -sf $MINER_DIR/tmpfs/heavy3.bin $MINER_DIR/$MINER_VER/heavy3.bin
  else
    ln -sf /home/user/tmp/heavy3.bin $MINER_DIR/$MINER_VER/heavy3.bin
  fi
  #-p ${MINER_API_PORT}
  local conf="${NONCEPOOL_AMD_USER_CONFIG} ${NONCEPOOL_AMD_TEMPLATE} ${NONCEPOOL_AMD_WORKER}"
  echo "$conf" > $MINER_CONFIG
}
