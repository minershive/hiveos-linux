#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$NANOMINER_VER
  [[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
  echo $MINER_VER
}


function miner_config_echo() {
  local MINER_VER=`miner_ver`
  miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/config.ini"
}

function miner_config_gen() {
  local MINER_CONFIG="$MINER_DIR/$MINER_VER/config.ini"
  mkfile_from_symlink $MINER_CONFIG

#common parameters
  echo "port = $MINER_API_PORT" > $MINER_CONFIG
  echo "mport = 0" >> $MINER_CONFIG
  echo "logPath = $MINER_LOG_BASENAME.log" >> $MINER_CONFIG
  echo "restarts = 0" >> $MINER_CONFIG

#merge common config options into main config
  if [[ ! -z $NANOMINER_COMMON_CONFIG ]]; then
    while read -r line; do
      [[ -z $line ]] && continue
      echo $line >> $MINER_CONFIG
    done <<< "$NANOMINER_COMMON_CONFIG"
  fi

  local i=0
  local nom=0
  local n=1
  local n_algo
  local n_url=''
  local n_config=''

#algos
  for (( i = 1; i <= 6; i++ )); do

    [[ i -eq 1 ]] && nom='' || nom=$i

    eval "n_algo=\$NANOMINER_ALGO$nom"
    [[ -z $n_algo && $i -gt 1 ]] && break
    echo "[$n_algo]" >> $MINER_CONFIG

    eval "echo \"wallet = \$NANOMINER_TEMPLATE$nom\" >> \$MINER_CONFIG"

    eval "[[ ! -z \$NANOMINER_PASS$nom ]] && echo \"rigPassword = \$NANOMINER_PASS$nom\" >> \$MINER_CONFIG"

    eval "n_url=\$NANOMINER_URL$nom"
    if [[ ! -z $n_url ]]; then
      if [[ $n_url = *"pool"* ]]; then
        echo $n_url >> $MINER_CONFIG
      else
        for url in $n_url; do
          echo "pool$n = $url" >> $MINER_CONFIG
          let "n = n + 1"
        done
      fi
    fi

    #merge user config options into main config
    eval "n_config=\$NANOMINER_USER_CONFIG$nom"
    if [[ ! -z $n_config ]]; then
      while read -r line; do
        [[ -z $line ]] && continue
        echo $line >> $MINER_CONFIG
      done <<< "$n_config"
    fi
  done
}
