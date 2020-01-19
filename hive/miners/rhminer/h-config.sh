#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$RHMINER_VER
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

  local conf=

  [[ -z $RHMINER_TEMPLATE ]] && echo -e "${YELLOW}RHMINER_TEMPLATE is empty${NOCOLOR}" && return 1
  [[ -z $RHMINER_URL ]] && echo -e "${YELLOW}RHMINER_URL is empty${NOCOLOR}" && return 1
  local pool1=`head -n 1 <<< "$RHMINER_URL"`
  local pool2=`head -n 2 <<< "$RHMINER_URL" | tail -n 1`
  if [[ ! -z $pool2 ]]; then
    local pass2=$RHMINER_PASS
    [[ ! -z $pass2 ]] && pass2=" -fop $pass2"
    pool2=" -fo $pool2 -fou ${RHMINER_TEMPLATE}${pass2}"
  fi

  local pass=$RHMINER_PASS
  [[ ! -z $pass ]] && pass=" -pw $pass"
  
  conf="-s ${pool1} -su ${RHMINER_TEMPLATE}${pass}${pool2} -cpu ${RHMINER_USER_CONFIG} -logfilename $MINER_LOG_BASENAME.log -apiport ${MINER_API_PORT}"

  # use all cpu cores instead of 1 by default
  [[ ! $RHMINER_USER_CONFIG =~ -cputhreads ]] && conf+=" -cputhreads $(nproc --all)"

  echo "$conf" > $MINER_CONFIG

}
