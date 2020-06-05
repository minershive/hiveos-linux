#!/usr/bin/env bash

# HugePages tunning
function HugePagesTune(){
   if [[ ! -z $XMRIG_NEW_HUGEPAGES ]]; then
       echo "Start HugePages tuning for RandomX ..."
       hugepages $XMRIG_NEW_HUGEPAGES
   else
      if [[ `echo $XMRIG_NEW_ALGO | grep -c "^rx\/"` -gt 0 ]]; then
          echo "Start HugePages tuning for RandomX ..."
          hugepages -rx
      fi
   fi
}

[[ `ps aux | egrep './[x]mrig' | grep -v xmrig-amd | grep -v xmrig-nvidia | wc -l` != 0 ]] &&
	echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
	exit 1

[[ "$XMRIG_NEW_HUGEPAGES" == "" && "$MINER_VER" < "5.2.0" ]] && HugePagesTune

# Miner run here
cd $MINER_DIR/$MINER_FORK/$MINER_VER

./xmrig
