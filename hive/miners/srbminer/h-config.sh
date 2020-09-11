#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$SRBMINER_VER
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

  local algo=$SRBMINER_ALGO

  dpkg --compare-versions "`miner_ver`" "gt" "0.4.7"; [[ $? -eq "0" ]] && local ver=1 || local ver=0;

  if (( $ver )); then
    local pool=
    while read -r line; do
      [[ ! -z $pool ]] && pool+='!'
      [[ $SRBMINER_TLS -eq 1 ]] && local pool+='stratum+ssl://'
      pool+=$line
    done <<< "$SRBMINER_URL"
  else
    [[ $SRBMINER_TLS -eq 1 ]] && local pool+='stratum+ssl://'
    local pool+=`head -n 1 <<< "$SRBMINER_URL"`
  fi

  local wallet=$SRBMINER_TEMPLATE

  [[ ! -z $SRBMINER_PASS ]] && local pass=$SRBMINER_PASS || local pass=x

  if [[ ! -z $SRBMINER_ALGO2 ]] && (( $ver )); then
    algo+=';'$SRBMINER_ALGO2

    local pool2=
    while read -r line; do
      [[ ! -z $pool2 ]] && pool2+='!'
      [[ $SRBMINER_TLS2 -eq 1 ]] && local pool2+='stratum+ssl://'
      pool2+=$line
    done <<< "$SRBMINER_URL2"
    pool+=';'$pool2

    wallet+=';'$SRBMINER_TEMPLATE2

    [[ ! -z $SRBMINER_PASS2 ]] && pass+=';'$SRBMINER_PASS2 || pass+=';'x
  fi

  local user_config=`echo $SRBMINER_USER_CONFIG`

  #generating config
  echo "--algorithm $algo --pool $pool --wallet $wallet --password $pass $user_config" > $MINER_CONFIG
}
