#!/usr/bin/env bash

[[ `ps aux | egrep './[x]mrig' | grep -v xmrig-amd | grep -v xmrig-nvidia | wc -l` != 0 ]] &&
	echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
	exit 1

# HugePages tunning
[[ ! -z $XMRIG_NEW_HUGEPAGES ]] && hugepages $XMRIG_NEW_HUGEPAGES

# Miner run here
cd $MINER_DIR/$MINER_FORK/$MINER_VER

./xmrig
