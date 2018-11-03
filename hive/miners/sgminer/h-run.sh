#!/usr/bin/env bash

  [[ `ps aux | grep "./sgminer" | grep -v grep | wc -l` != 0 ]] &&
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

  export GPU_MAX_HEAP_SIZE=100
  export GPU_USE_SYNC_OBJECTS=1
  export GPU_SINGLE_ALLOC_PERCENT=100
  export GPU_MAX_ALLOC_PERCENT=100

cd $MINER_DIR/$MINER_FORK/$MINER_VER

#remove core dumps
rm ./*.bin > /dev/null 2>&1

MINER_GM_CLI_ARGS=""
SGMINER_ARGS_MONERO=$(cat sgminer.conf | grep -Pow '\"monero\"\s*:.*true' | wc -l)
if [ $SGMINER_ARGS_MONERO -ne 0 ]; then
  SGMINER_CLI_ARGS=" --monero"
fi

sgminer -c sgminer.conf $SGMINER_CLI_ARGS
