#!/usr/bin/env bash

[[ `ps aux | grep "./hellminer" | grep -v grep | wc -l` != 0 ]] &&
  echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
  exit 1

cd $MINER_DIR/$MINER_VER

./hellminer `cat hellminer.conf` 2>&1 | tee --append $MINER_LOG_BASENAME.log
