#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$CKB_MINER_VER
  [[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
  echo $MINER_VER
}


function miner_config_echo() {
  local MINER_VER=`miner_ver`
  miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/$MINER_NAME.toml"
}

function miner_config_gen() {

  local MINER_CONFIG="$MINER_DIR/$MINER_VER/$MINER_NAME.toml"
  mkfile_from_symlink $MINER_CONFIG

  #reading global config
  cat $MINER_DIR/$MINER_VER/${MINER_NAME}_global.toml > $MINER_CONFIG

  #[[ -z $CKB_MINER_TEMPLATE ]] && echo -e "${YELLOW}CKB_MINER_TEMPLATE is empty${NOCOLOR}" && return 1
  [[ -z $CKB_MINER_URL ]] && echo -e "${YELLOW}CKB_MINER_URL is empty${NOCOLOR}" && return 1

  local rpc_url=`head -n 1 <<< "$CKB_MINER_URL"`
  [[ $rpc_url != http* ]] && rpc_url="http://$rpc_url"
  echo "rpc_url=\"$rpc_url\"" >> $MINER_CONFIG

  for line in $CKB_MINER_USER_CONFIG; do
    echo $line >> $MINER_CONFIG
  done

  if [[ `echo $CKB_MINER_USER_CONFIG | grep -c "gpus"` -eq 0 ]]; then
    echo "gpus="`cat $GPU_DETECT_JSON | jq -c '[ . | to_entries[] | select(.value.brand == "nvidia") | .key ]'` >> $MINER_CONFIG
  fi

  if [[ `echo $CKB_MINER_USER_CONFIG | grep -c "cpus"` -eq 0 ]]; then
    echo "cpus=0" >> $MINER_CONFIG
  fi

}
