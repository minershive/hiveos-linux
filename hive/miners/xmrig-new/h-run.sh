#!/usr/bin/env bash

[[ `ps aux | egrep './[x]mrig' | grep -v xmrig-amd | grep -v xmrig-nvidia | wc -l` != 0 ]] &&
	echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
	exit 1

# HugePages tunning
if [[ ! -z $XMRIG_NEW_HUGEPAGES ]];
then
    hugepages $XMRIG_NEW_HUGEPAGES
else
   if [[ `echo $XMRIG_NEW_ALGO | grep -c "^rx\/"` -gt 0 ]];
   then
       hugepages -rx $XMRIG_NEW_HUGEPAGES
   fi
fi

# Miner run here
cd $MINER_DIR/$MINER_FORK/$MINER_VER

./xmrig
