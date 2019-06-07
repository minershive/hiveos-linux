#!/usr/bin/env bash

[[ `ps aux | grep "./sushi-miner-cuda" | grep -v grep | wc -l` != 0 ]] &&
  echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
  exit 1

cd $MINER_DIR/$MINER_VER

UV_THREADPOOL_SIZE=24 ./sushi-miner-cuda 2>&1 | tee $MINER_LOG_BASENAME.log

