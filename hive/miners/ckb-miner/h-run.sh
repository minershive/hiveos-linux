#!/usr/bin/env bash

[[ `ps aux | grep "./ckb-miner" | grep -v grep | wc -l` != 0 ]] &&
  echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
  exit 1

cd $MINER_DIR/$MINER_VER

if [[ $CKB_MINER_OPENCL -eq 1 ]]; then
  ln -sf $MINER_DIR/$MINER_VER/ckb-miner-ocl $MINER_DIR/$MINER_VER/ckb-miner
else
  ln -sf $MINER_DIR/$MINER_VER/ckb-miner-cuda $MINER_DIR/$MINER_VER/ckb-miner
fi

./ckb-miner
