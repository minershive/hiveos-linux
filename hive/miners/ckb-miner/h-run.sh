#!/usr/bin/env bash

[[ `ps aux | grep "./ckb-miner" | grep -v grep | wc -l` != 0 ]] &&
  echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
  exit 1

cd $MINER_DIR/$MINER_VER

./ckb-miner
