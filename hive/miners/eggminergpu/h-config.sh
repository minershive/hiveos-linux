#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$EGGMINERGPU_VER
  [[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
  echo $MINER_VER
}

function miner_config_echo() {
  local MINER_VER=`miner_ver`
  miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/miner.cfg"
}

function miner_config_gen() {
  local MINER_CONFIG="$MINER_DIR/$MINER_VER/miner.cfg"
  mkfile_from_symlink $MINER_CONFIG

  [[ -z $EGGMINERGPU_TEMPLATE ]] && echo -e "${YELLOW}EGGMINERGPU_TEMPLATE is empty${NOCOLOR}" && return 1

  echo "address = \"${EGGMINERGPU_TEMPLATE}\"" > $MINER_CONFIG

  [[ ! -z $EGGMINERGPU_WORKER ]] && echo "minerName = \"$EGGMINERGPU_WORKER\"" >> $MINER_CONFIG

  #merge user config options into main config
  if [[ ! -z $EGGMINERGPU_USER_CONFIG ]]; then
    while read -r line; do
      [[ -z $line ]] && continue
      echo $line >> $MINER_CONFIG
    done <<< "$EGGMINERGPU_USER_CONFIG"
  fi

  if [[ $EGGMINER_TMPFS -eq 1 ]]; then
    #echo 'heavyFileName="'$MINER_DIR'/tmpfs/heavy3a.bin"' >> $MINER_CONFIG
    ln -sf $MINER_DIR/tmpfs/heavy3a.bin $MINER_DIR/$MINER_VER/heavy3a.bin
  else
    #echo 'heavyFileName="'$MINER_DIR'/tmp/heavy3a.bin"' >> $MINER_CONFIG
    ln -sf /home/user/tmp/heavy3a.bin $MINER_DIR/$MINER_VER/heavy3a.bin
  fi
}
