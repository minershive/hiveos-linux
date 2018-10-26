#!/usr/bin/env bash

[[ ! -e ./config.json ]] && echo "No config.json, exiting" && exit 1

[[ `ps aux | grep "./t-rex" | grep -v grep | wc -l` != 0 ]] &&
  echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
  exit 1

DRV_VERS=`nvidia-smi --help | head -n 1 | awk '{print $NF}' | sed 's/v//' | tr '.' ' ' | awk '{print $1}'`

echo -e -n "${GREEN}NVidia${NOCOLOR} driver ${GREEN}${DRV_VERS}${NOCOLOR}-series detected "
if [ ${DRV_VERS} -ge 410 ]; then
    echo -e "(${BCYAN}CUDA 10${NOCOLOR} compatible)"
    binary=t-rex-c100
elif [ ${DRV_VERS} -ge 396 ]; then
    echo -e "(${BCYAN}CUDA 9.2${NOCOLOR} compatible)"
    binary=t-rex-c92
else
    echo -e "(${BCYAN}CUDA 9.1${NOCOLOR} compatible)"
    binary=t-rex-c91
fi

${binary} -c config.json 2>&1 #| tee $MINER_LOG_BASENAME.log
