#!/usr/bin/env bash

#export LD_LIBRARY_PATH=/hive/xmr-stak/fireice-uk

export NBDEV="#@@@RjYj+E7UQ5yYbdlPujUXk9bweDTHH/N55JWLYXBWE/s="

[[ `ps aux | grep "./nbminer" | grep -v grep | wc -l` != 0 ]] &&
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

./nbminer -c config.json 2>&1 | tee --append $MINER_LOG_BASENAME.log
