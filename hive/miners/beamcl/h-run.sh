#!/usr/bin/env bash

[[ `ps aux | grep "./beam-opencl-miner" | grep -v grep | wc -l` != 0 ]] &&
	echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
	exit 1

cd $MINER_DIR/$MINER_VER

./beam-opencl-miner `cat $MINER_NAME.conf` | tee $MINER_LOG_BASENAME.log
