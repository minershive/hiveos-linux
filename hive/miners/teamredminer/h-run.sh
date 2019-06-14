#!/usr/bin/env bash

export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100
export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1

[[ `ps aux | grep "./teamredminer" | grep -v grep | wc -l` != 0 ]] &&
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
WATCHDOG=""
[[ -e watchdog.sh ]] && WATCHDOG="--watchdog_script"
./teamredminer $(< $MINER_NAME.conf) --api_listen=0.0.0.0:${MINER_API_PORT} $WATCHDOG $@ 2>&1 | tee ${MINER_LOG_BASENAME}.log
