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

  local conf="-a ${TEAMREDMINER_ALGO}"
  local wallet="-u ${TEAMREDMINER_TEMPLATE}"
  local worker_name=
  local line=
  local pool=
  local pass=
  #local user_config=

  if [[ ! -z $TEAMREDMINER_WORKER && $TEAMREDMINER_ALGO = "ethash" ]]; then
    worker_name=" --eth_worker $TEAMREDMINER_WORKER"
  elif [[ ! -z $TEAMREDMINER_WORKER && $TEAMREDMINER_ALGO = "nimiq" ]]; then
    worker_name=" --nimiq_worker $TEAMREDMINER_WORKER"
  elif [[ ! -z $TEAMREDMINER_WORKER && $TEAMREDMINER_ALGO == cn* ]]; then
    worker_name=" --rig_id $TEAMREDMINER_WORKER"
  elif [[ ! -z $TEAMREDMINER_WORKER ]]; then
    wallet+=".$TEAMREDMINER_WORKER"
  fi

  [[ ! -z $TEAMREDMINER_PASS ]] && pass=" -p $TEAMREDMINER_PASS"

  # while read -r line; do
  #   [[ -z $line ]] && continue
  #   if grep -q '\-\-eth_worker' <<< $line; then
  #     worker_name=" $line"
  #   else
  #     user_config=$line
  #   fi
  # done <<< "$TEAMREDMINER_USER_CONFIG"

  # if [[ ${TEAMREDMINER_ALGO} == "ethash" ]]; then
  #   local wallet="${TEAMREDMINER_TEMPLATE%.*}"
  #   local worker_name="${TEAMREDMINER_TEMPLATE##*.}"
  #   [[ ! -z $worker_name ]] && worker_name=" --eth_worker $worker_name"
  # else
  #   local wallet=${TEAMREDMINER_TEMPLATE}
  #   local worker_name=
  # fi

  for pool in $TEAMREDMINER_URL; do
    grep -q "://" <<< $pool
    [[ $? -ne 0 ]] && pool="stratum+tcp://${pool}"

    conf+=" -o $pool ${wallet}${pass}${worker_name}"

  done

  [[ ! -z $TEAMREDMINER_USER_CONFIG ]] && conf+=" $TEAMREDMINER_USER_CONFIG"

  echo "$conf" > $MINER_CONFIG
}
