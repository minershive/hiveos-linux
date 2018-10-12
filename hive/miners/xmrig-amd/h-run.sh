#!/usr/bin/env bash

export LD_LIBRARY_PATH=/hive/xmr-stak/fireice-uk

[[ `ps aux | grep "./xmrig-amd" | grep -v grep | wc -l` != 0 ]] &&
	echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
	exit 1

MINER_LOG_BASEDIR=`dirname "$CUSTOM_LOG_BASENAME"`
[[ ! -d $MINER_LOG_BASEDIR ]] && mkdir -p $MINER_LOG_BASEDIR

cd $MINER_DIR/$MINER_VER

./xmrig-amd | tee $MINER_LOG_BASENAME.log
