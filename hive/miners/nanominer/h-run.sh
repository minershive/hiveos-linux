#!/usr/bin/env bash

[[ `ps aux | grep "./nanominer" | grep -v grep | wc -l` != 0 ]] &&
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

cd $MINER_DIR/$MINER_VER

algos=`grep -oP "\[.*\]" $MINER_DIR/$MINER_VER/config.ini 2>/dev/null`
if [[ ${algos,,} =~ "random" ]] && ! grep -q -v "random" <<< "${algos,,}"; then
	# CRITICAL BUG FIX for v1.6.0+
	# this is needed to prevent nanominer from using CUDA for CPU ONLY algos
	# otherwise it will crash 4GB rigs with NVIDIA GPUs that mining something else
	[[ ! -f $MINER_DIR/$MINER_VER/libcuda.so.1 ]] && touch $MINER_DIR/$MINER_VER/libcuda.so.1
	#[[ ! -f $MINER_DIR/$MINER_VER/libcuda.so ]] && touch $MINER_DIR/$MINER_VER/libcuda.so
	echo "> Disable CUDA for CPU only mining"
	# also set LOW priority for CPU mining
	nice -n 10 ./nanominer
else
	rm $MINER_DIR/$MINER_VER/libcuda.*
	./nanominer
fi
