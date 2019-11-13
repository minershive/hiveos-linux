#!/usr/bin/env bash

[[ `ps aux | grep "./nq-miner" | grep -v grep | wc -l` != 0 ]] &&
  echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
  exit 1

cd $MINER_DIR/$MINER_VER

xargs -a $MINER_NAME.conf ./nq-miner $@ 2>&1 | tee $MINER_LOG_BASENAME.log
