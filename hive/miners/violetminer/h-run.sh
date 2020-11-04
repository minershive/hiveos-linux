#!/usr/bin/env bash

[[ `ps aux | grep "./violetminer" | grep -v grep | wc -l` != 0 ]] &&
  echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
  exit 1

export LD_LIBRARY_PATH=${MINER_DIR}/lib:$LD_LIBRARY_PATH

cd $MINER_DIR/$MINER_VER

./violetminer 2>&1 | tee --append $MINER_LOG_BASENAME.log
