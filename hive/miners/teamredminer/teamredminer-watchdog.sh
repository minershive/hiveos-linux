#!/bin/bash

. /hive/miners/teamredminer/h-manifest.conf

#save last messages about hanging cards
if [[ -e $MINER_LOG_BASENAME.log ]]; then
  tail -n 100 $MINER_LOG_BASENAME.log > ${MINER_LOG_BASENAME}_reboot.log

  #2018-12-20 08:26:02:  Can't work on device: 1
  lastmsg=`tac $MINER_LOG_BASENAME.log | grep -m1 -E "Can't work on device"`

  #echo $lastmsg
  [[ $lastmsg =~ ^([0-9]{4}-[0-9]{2}-[0-9]{2})[[:space:]]+([0-9:]+)[[:space:]]+(.*) ]]

  if [[ ! -z ${BASH_REMATCH[3]} ]]; then
    lastmsg=${BASH_REMATCH[3]}
  fi
  #echo $lastmsg
fi

if [[ -z $lastmsg ]]; then
  lastmsg="${MINER_NAME} reboot"
else
  lastmsg="${MINER_NAME} reboot: $lastmsg"
fi

if [[ -e ${MINER_LOG_BASENAME}_reboot.log ]]; then
  echo -e "=== Last 50 lines of ${MINER_LOG_BASENAME}.log ===\n`tail -n 50 ${MINER_LOG_BASENAME}_reboot.log`" | /hive/bin/message danger "$lastmsg" payload
else
  /hive/bin/message danger "$lastmsg"
fi

#need nohup or the sreboot will stop miner and this process also in it
nohup bash -c 'sreboot' > /tmp/nohup.log 2>&1 &
