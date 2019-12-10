#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$TEAMREDMINER_VER
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

  [[ -z $TEAMREDMINER_ALGO ]] && TEAMREDMINER_ALGO=lyra2z

  conf="-a ${TEAMREDMINER_ALGO}"

  for pool in $TEAMREDMINER_URL; do
    grep -q "://" <<< $pool
    [[ $? -ne 0 ]] && pool="stratum+tcp://${pool}"

    local pass=
    [[ ! -z ${TEAMREDMINER_PASS} ]] && pass=" -p ${TEAMREDMINER_PASS}"

  	conf+=" -o $pool -u ${TEAMREDMINER_TEMPLATE}${pass}"

	done


  [[ ! -z $TEAMREDMINER_USER_CONFIG ]] && conf+=" ${TEAMREDMINER_USER_CONFIG}"

  echo "$conf" > $MINER_CONFIG
}
