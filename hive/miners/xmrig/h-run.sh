#!/usr/bin/env bash

[[ `ps aux | egrep './[x]mrig' | grep -v xmrig-amd | grep -v xmrig-nvidia | wc -l` != 0 ]] &&
	echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
	exit 1


cd $MINER_DIR/$MINER_VER

./xmrig | tee $MINER_LOG_BASENAME.log
