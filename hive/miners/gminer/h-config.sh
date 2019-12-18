#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$GMINER_VER
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

  [[ -z $GMINER_ALGO ]] && GMINER_ALGO="144_5"
  local conf="--algo $GMINER_ALGO"
  [[ "$GMINER_ALGO" == "ethash" && "$GMINER_ALGO2" == "eaglesong" ]] && conf="--algo eth+ckb" && echo "Dual mining ETH+CKB"
  [[ "$GMINER_ALGO" == "ethash" && "$GMINER_ALGO2" == "blake2s" ]] && conf="--algo eth+kda" && echo "Dual mining ETH+KDA"

  local host=
  local port=

  for (( i = 1; i <= `wc -w <<< $GMINER_HOST`; i++ )); do
    host=`awk '(NR == '$i')' <<< "$GMINER_HOST"`
    [[ ! -z `awk '(NR == '$i')' <<< "$GMINER_PORT"` ]] && port=`awk '(NR == '$i')' <<< "$GMINER_PORT"`

    conf+=" --server $host --port $port --user $GMINER_TEMPLATE"
    [[ ! -z $GMINER_PASS ]] && conf+=" --pass $GMINER_PASS"

    [[ $GMINER_TLS -eq 1 ]] && conf+=" --ssl 1"
  done

  host=
  port=

  for (( i = 1; i <= `wc -w <<< $GMINER_HOST2`; i++ )); do
    host=`awk '(NR == '$i')' <<< "$GMINER_HOST2"`
    [[ ! -z `awk '(NR == '$i')' <<< "$GMINER_PORT2"` ]] && port=`awk '(NR == '$i')' <<< "$GMINER_PORT2"`

    conf+=" --dserver $host --dport $port --duser $GMINER_TEMPLATE2"
    [[ ! -z $GMINER_PASS2 ]] && conf+=" --dpass $GMINER_PASS2"

    [[ $GMINER_TLS2 -eq 1 ]] && conf+=" --dssl 1"
  done

  [[ ! -z $GMINER_INTENSITY ]] && conf+=" --dual_intensity $GMINER_INTENSITY"

  #If there is no --pec param in USER_CONFIG, then disable power efficiency calculator to reduse CPU load.
  [[ ! $GMINER_USER_CONFIG =~ "--pec" ]] && conf+=" --pec 0"

  conf+=" $GMINER_USER_CONFIG"

  echo "$conf" > $MINER_CONFIG
}
