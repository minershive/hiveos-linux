#!/usr/bin/env bash

export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100
export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1

[[ `ps aux | grep "./teamredminer" | grep -v grep | wc -l` != 0 ]] &&
  echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
  exit 1

[[ -f ${MINER_LOG_BASENAME}_head.log ]] && rm "${MINER_LOG_BASENAME}_head.log"

cd $MINER_DIR/$MINER_VER
WATCHDOG=""
[[ -e watchdog.sh ]] && WATCHDOG="--watchdog_script"
#./teamredminer $(< $MINER_NAME.conf) --api_listen=0.0.0.0:${MINER_API_PORT} $WATCHDOG $@ 2>&1 | tee --append ${MINER_LOG_BASENAME}.log
./teamredminer ${WATCHDOG} $(< $MINER_NAME.conf) --api_listen=0.0.0.0:${MINER_API_PORT}   2>&1 | tee --append ${MINER_LOG_BASENAME}.log
