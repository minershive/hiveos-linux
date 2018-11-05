#!/usr/bin/env bash

#installing libuv1 if necessary
#[[ `dpkg -s libuv1 2>/dev/null | grep -c "ok installed"` -eq 0 ]] && apt-get install -y libuv1

[[ `ps aux | grep "./t-rex" | grep -v grep | wc -l` != 0 ]] &&
  echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
  exit 1

#try to release TIME_WAIT sockets
while true; do
	for con in `netstat -anp | grep TIME_WAIT | grep $MINER_API_PORT | awk '{print $5}'`; do
	    killcx $con lo
	done
	netstat -anp | grep TIME_WAIT | grep $MINER_API_PORT && continue || break
done

cd $MINER_DIR/$MINER_VER

wildrig-multi $(< ${MINER_NAME}.conf) | tee $MINER_LOG_BASENAME.log
