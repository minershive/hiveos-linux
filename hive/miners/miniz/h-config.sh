#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$MINIZ_VER
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

  ssl=
  [[ $MINIZ_TLS == 1 ]] && ssl='ssl://'
  
  [[ -z $MINIZ_ALGO ]] && MINIZ_ALGO="144,5" 
  local conf="--par=$MINIZ_ALGO"

  for url in $MINIZ_URL; do
    conf+=" --url=${ssl}${MINIZ_TEMPLATE}@${url}"
  done

  [[ ! -z $MINIZ_PASS ]] && conf+=" --pass=$MINIZ_PASS"
  

  [[ ! -z $MINIZ_USER_CONFIG ]] && conf+=" $MINIZ_USER_CONFIG"

	echo "$conf" > $MINER_CONFIG
}
