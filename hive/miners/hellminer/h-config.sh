#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$HELLMINER_VER
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

  [[ -z $HELLMINER_TEMPLATE ]] && echo -e "${YELLOW}HELLMINER_TEMPLATE is empty${NOCOLOR}" && return 1
  [[ -z $HELLMINER_URL ]] && echo -e "${YELLOW}HELLMINER_URL is empty${NOCOLOR}" && return 1
  local pool1=`head -n 1 <<< "$HELLMINER_URL"`
  [[ ! $pool1 =~ 'stratum+tcp://' ]] && pool1='stratum+tcp://'$pool1
  # local pool2=`head -n 2 <<< "$HELLMINER_URL" | tail -n 1`
  # if [[ ! -z $pool2 ]]; then
  #   local pass2=$HELLMINER_PASS
  #   [[ ! -z $pass2 ]] && pass2=" -fop $pass2"
  #   pool2=" -fo $pool2 -fou ${HELLMINER_TEMPLATE}${pass2}"
  # fi

  local pass=$HELLMINER_PASS
  [[ ! -z $pass ]] && pass=" -p $pass"

  conf="-c ${pool1} -u ${HELLMINER_TEMPLATE}${pass}${cpu_conf} $HELLMINER_USER_CONFIG"

  # use all cpu cores instead of 1 by default
  [[ ! $HELLMINER_USER_CONFIG =~ -cpu ]] && conf+=" --cpu=$(nproc --all)"

  echo "$conf" > $MINER_CONFIG
}
