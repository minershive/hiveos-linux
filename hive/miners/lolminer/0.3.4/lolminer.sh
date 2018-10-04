#!/usr/bin/env bash

CFGFILE=./pool.cfg

MINER="lolminer"


cd "$(dirname "$0")"
while true
do
	mkdir -p /var/log/miner/$MINER
	lolMiner-mnx --use-config $CFGFILE $@ | tee /var/log/miner/$MINER/$MINER.log
	if [ $? -eq 134 ]; then
		break
	fi
done
