#!/usr/bin/env bash

[[ `ps aux | grep "$MINER_DIR/$CUSTOM_MINER/h-run.sh" | grep -v grep | wc -l` != 0 ]] &&
	echo -e "${RED}$MINER_NAME $CUSTOM_MINER miner is already running${NOCOLOR}" &&
	exit 1



cd $MINER_DIR/$CUSTOM_MINER

[[ ! -e $MINER_DIR/$CUSTOM_MINER/h-run.sh ]] &&
	echo -e "${RED}$MINER_DIR/$CUSTOM_MINER/h-run.sh is not implemented${NOCOLOR}" &&
	exit 1


$MINER_DIR/$CUSTOM_MINER/h-run.sh
