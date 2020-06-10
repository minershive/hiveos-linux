#!/usr/bin/env bash

function miner_fork() {
  local MINER_FORK=$XPMCLIENT_FORK
  [[ -z $MINER_FORK ]] && MINER_FORK=$MINER_DEFAULT_FORK
  echo $MINER_FORK
}


function miner_ver() {
  local MINER_VER=$XPMCLIENT_VER
  local MINER_FORK=`miner_fork`
  local fork=${MINER_FORK^^} #uppercase MINER_FORK
  [[ -z $MINER_VER ]] && eval "MINER_VER=\$MINER_LATEST_VER_${fork//-/_}" #char replace
  echo $MINER_VER
}


function miner_config_echo() {
  local MINER_FORK=`miner_fork`
  local MINER_VER=`miner_ver`
  miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_FORK/$MINER_VER/config.txt"
}

function miner_config_gen() {
  local MINER_CONFIG="$MINER_DIR/$MINER_FORK/$MINER_VER/config.txt"
  mkfile_from_symlink $MINER_CONFIG

  cat $MINER_DIR/$MINER_FORK/$MINER_VER/config.global > $MINER_CONFIG

  sed -i --follow-symlinks "s#.*server = .*#server = \"$XPMCLIENT_HOST\";#gi" $MINER_CONFIG
  sed -i --follow-symlinks "s#.*port = .*#port = \"$XPMCLIENT_PORT\";#gi" $MINER_CONFIG
  sed -i --follow-symlinks "s#.*address = .*#address = \"$XPMCLIENT_TEMPLATE\";#gi" $MINER_CONFIG
  if [[ ! -z $XPMCLIENT_WORKER ]]; then
    sed -i --follow-symlinks "s#.*name = .*#name = \"$XPMCLIENT_WORKER\";#gi" $MINER_CONFIG
  else
    sed -i --follow-symlinks "s#.*name = .*##gi" $MINER_CONFIG
  fi

  #merge user config options into main config
  if [[ ! -z $XPMCLIENT_USER_CONFIG ]]; then
    while read -r line; do
      [[ -z $line ]] && continue
      local param_name=`echo $line | cut -d '=' -f 1`'='
      [[ ${line:$((${#line}-1)):1} != ';' ]] && line+=';'
      if [[ `cat $MINER_CONFIG | grep -c "$param_name"` -gt 0 ]]; then
        sed -i --follow-symlinks "s#.*$param_name.*#${line//\"/\\\"}#gi" $MINER_CONFIG
      else
        echo $line >> $MINER_CONFIG
      fi
    done <<< "$XPMCLIENT_USER_CONFIG"
  fi
}
