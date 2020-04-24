#!/usr/bin/env bash


function miner_ver() {
  local MINER_VER=$TT_MINER_VER
  [[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
  echo $MINER_VER
}


function miner_config_echo() {
  local MINER_VER=`miner_ver`
  miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/miner.conf"
}


function miner_config_gen() {
  local MINER_CONFIG="$MINER_DIR/$MINER_VER/miner.conf"
  mkfile_from_symlink $MINER_CONFIG

  [[ -z $TT_MINER_TEMPLATE ]] && echo -e "${YELLOW}TT_MINER_TEMPLATE is empty${NOCOLOR}" && return 1
  [[ -z $TT_MINER_URL ]] && echo -e "${YELLOW}TT_MINER_URL is empty${NOCOLOR}" && return 1
  [[ -z $TT_MINER_ALGO ]] && TT_MINER_ALGO='ETHASH'

  echo "-log -b 127.0.0.1:$MINER_API_PORT" > $MINER_CONFIG

  [[ ! -z $TT_MINER_USER_CONFIG ]] && echo "$TT_MINER_USER_CONFIG" >> $MINER_CONFIG

  DRV_VERS=`nvidia-smi --help | head -n 1 | awk '{print $NF}' | sed 's/v//' | tr '.' ' ' | awk '{print $1}'`
  echo -e -n "${GREEN}NVidia${NOCOLOR} driver ${GREEN}${DRV_VERS}${NOCOLOR}-series detected "
  if [ ${DRV_VERS} -ge 430 ]; then
     echo -e "(${BCYAN}CUDA 10.2${NOCOLOR} compatible)"
     CUDA_VERS='-102'
  elif [ ${DRV_VERS} -ge 418 ]; then
    echo -e "(${BCYAN}CUDA 10.1${NOCOLOR} compatible)"
    CUDA_VERS='-101'
  elif [ ${DRV_VERS} -ge 410 ]; then
    echo -e "(${BCYAN}CUDA 10.0${NOCOLOR} compatible)"
    CUDA_VERS='-100'
  elif [ ${DRV_VERS} -ge 396 ]; then
    echo -e "(${BCYAN}CUDA 9.2${NOCOLOR} compatible)"
    CUDA_VERS='-92'
  else
    echo -e "(${RED}CUDA less then 9.2 - update your Nvidia card drivers! ${NOCOLOR})"
    CUDA_VERS=''
  fi

  echo "-algo ${TT_MINER_ALGO}${CUDA_VERS}" >> $MINER_CONFIG

  pool1=$(head -n 1 <<< "$TT_MINER_URL")
  echo "-wal $TT_MINER_TEMPLATE" >> $MINER_CONFIG
  [[ ! -z $TT_MINER_PASS ]] && echo "-pass $TT_MINER_PASS" >> $MINER_CONFIG
  echo "-pool $pool1" >> $MINER_CONFIG

  if [[ `echo "$TT_MINER_URL" | wc -l` -gt 1 ]]; then
    pool2=$(head -n 2 <<< "$TT_MINER_URL" | tail -1 | sed -re 's:.*//\s*(.*):\1:') #' second pool should be without protocol.
    echo "-wal2 $TT_MINER_TEMPLATE" >> $MINER_CONFIG
    [[ ! -z $TT_MINER_PASS ]] && echo "-pass2 $TT_MINER_PASS" >> $MINER_CONFIG
    echo "-pool2 $pool2" >> $MINER_CONFIG
  fi
}
