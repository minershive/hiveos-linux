#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$HSPMINERAE_VER
  [[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
  echo $MINER_VER
}

function miner_config_echo() {
  local MINER_VER=`miner_ver`
  miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/${MINER_NAME}.conf"
}

function miner_config_gen() {
  local MINER_CONFIG="$MINER_DIR/$MINER_VER/${MINER_NAME}.conf"
  mkfile_from_symlink $MINER_CONFIG

  [[ -z $HSPMINERAE_TEMPLATE ]] && echo -e "${YELLOW}HSPMINERAE_TEMPLATE is empty${NOCOLOR}" && return 1
  [[ -z $HSPMINERAE_URL ]] && echo -e "${YELLOW}HSPMINERAE_URL is empty${NOCOLOR}" && return 1

  local conf=
  local pool=`head -n 1 <<< "$HSPMINERAE_URL"`
  local worker=
  local psw=

  [[ ! -z $HSPMINERAE_WORKER ]] && worker=" -worker $HSPMINERAE_WORKER"
  [[ ! -z $HSPMINERAE_PASS ]] && psw=" -psw $HSPMINERAE_PASS"

  #./HSPMinerAE -pool ae.uupool.cn:6210 -wal {ae wallet address} -worker {worker name} -logfile -m 10 -api 0.0.0.0:16666
  conf="-pool $pool -wal ${HSPMINERAE_TEMPLATE}${psw}${worker} -api 127.0.0.1:$MINER_API_PORT -logfile $MINER_LOG_BASENAME.log"

  echo "$conf" > $MINER_CONFIG
}
