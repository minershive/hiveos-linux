#!/usr/bin/env bash

cd $MINER_DIR/$MINER_VER

[[ ! -e ./lolminer.conf ]] && echo "No config file found, exiting" && exit 1

lolMiner $(< lolminer.conf) $@ 2>&1 | tee $MINER_LOG_BASENAME.log
