#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$SUSHI_MINER_VER
  [[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
  echo $MINER_VER
}


function miner_config_echo() {
  local MINER_VER=$(miner_ver)
  miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/miner.conf"
}

function miner_config_gen() {

  [[ -z $SUSHI_MINER_OPENCL_TEMPLATE ]] && echo -e "${YELLOW}SUSHI_MINER_OPENCL_TEMPLATE is empty${NOCOLOR}" && return 1
  [[ -z $SUSHI_MINER_OPENCL_HOST ]] && echo -e "${YELLOW}SUSHI_MINER_OPENCL_HOST is empty${NOCOLOR}" && return 1
  [[ -z $SUSHI_MINER_OPENCL_PORT ]] && echo -e "${YELLOW}SUSHI_MINER_OPENCL_PORT is empty${NOCOLOR}" && return 1

  local MINER_CONFIG="$MINER_DIR/$MINER_VER/miner.conf"
  mkfile_from_symlink $MINER_CONFIG

  local conf=$(cat $MINER_DIR/$MINER_FORK/$MINER_VER/miner_global.conf | envsubst)

  #merge user config options into main config
  if [[ ! -z $SUSHI_MINER_OPENCL_USER_CONFIG ]]; then
    while read -r line; do
      [[ -z $line ]] && continue
      conf=$(jq -s '.[0] * .[1]' <<< "$conf {$line}")
    done <<< "$SUSHI_MINER_OPENCL_USER_CONFIG"
  fi

  local host=$(head -n 1 <<< "$SUSHI_MINER_OPENCL_HOST")
  local port=$(head -n 1 <<< "$SUSHI_MINER_OPENCL_PORT")

  local conf_t=$(jq -n \
           --arg address "$SUSHI_MINER_OPENCL_TEMPLATE"\
           --arg name "$SUSHI_MINER_OPENCL_WORKER" \
           --arg host "$host" \
           '{$address, $name, $host, "port":'$port'}')


  conf=$(jq -s '.[0] * .[1]' <<< "$conf $conf_t")

  echo "$conf" > $MINER_CONFIG
}
