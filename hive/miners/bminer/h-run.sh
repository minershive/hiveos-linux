#!/usr/bin/env bash

#export LD_LIBRARY_PATH=/hive/xmr-stak/fireice-uk

[[ `ps aux | grep "./bminer" | grep -v grep | wc -l` != 0 ]] &&
	echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
	exit 1

MINER_LOG_BASEDIR=`dirname "$MINER_LOG_BASENAME"`
[[ ! -d $MINER_LOG_BASEDIR ]] && mkdir -p $MINER_LOG_BASEDIR

cd $MINER_DIR/$MINER_VER

./bminer $(< $MINER_DIR/$MINER_VER/bminer.conf) | tee $MINER_LOG_BASENAME.log
