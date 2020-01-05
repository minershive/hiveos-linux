#!/usr/bin/env bash

cd $MINER_DIR/$MINER_VER

[[ ! -e ./zm.conf ]] && echo "No zm.conf, exiting" && exit 1

[[ `ps aux | grep "./zm" | grep -v grep | wc -l` != 0 ]] &&
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

zm --cfg-file=zm.conf 2>&1 | tee --append $MINER_LOG_BASENAME.log
