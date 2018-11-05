#!/usr/bin/env bash

[[ `ps aux | grep "./t-rex" | grep -v grep | wc -l` != 0 ]] &&
  echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
  exit 1

cd $MINER_DIR/$MINER_VER

[[ ! -e ./config.json ]] && echo "No config.json, exiting" && exit 1

#DRV_VERS=`nvidia-smi --help | head -n 1 | awk '{print $NF}' | sed 's/v//' | tr '.' ' ' | awk '{print $1}'`

#if [ ${DRV_VERS} -lt 390 ]; then
#    echo -e "(${RED}Needs driver 396 or higher version${NOCOLOR} compatible)"
#    exit 1
#fi

t-rex -c config.json 2>&1 #| tee $MINER_LOG_BASENAME.log
