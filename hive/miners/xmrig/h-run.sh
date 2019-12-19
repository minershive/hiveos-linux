#!/usr/bin/env bash

# HugePages tunning
function HugePagesTune(){
   XMRIG_ALGO=`cat config.json | jq -r '.pools[0].algo'`
   echo "Start HugePages tuning for RandomX ..."
   if [[ `echo $XMRIG_ALGO | grep -c "^rx\/"` -gt 0 || `echo $XMRIG_ALGO | grep -c "^random\/"` -gt 0 ]]; then
       hugepages -rx
   fi
}

[[ `ps aux | egrep './[x]mrig' | grep -v xmrig-amd | grep -v xmrig-nvidia | wc -l` != 0 ]] &&
	echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
	exit 1

#try to release TIME_WAIT sockets
while true; do
	for con in `netstat -anp | grep TIME_WAIT | grep $MINER_API_PORT | awk '{print $5}'`; do
		killcx $con lo
	done
	netstat -anp | grep TIME_WAIT | grep $MINER_API_PORT &&
		continue ||
		break
done

cd $MINER_DIR/$MINER_FORK/$MINER_VER

HugePagesTune

./xmrig | tee $MINER_LOG_BASENAME.log
