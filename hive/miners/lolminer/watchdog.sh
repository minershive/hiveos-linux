#!/bin/bash

. /hive/miners/lolminer/h-manifest.conf

#save last messages about hanging cards
if [[ -e $MINER_LOG_BASENAME.log ]]; then
   tail -n 50 $MINER_LOG_BASENAME.log > ${MINER_LOG_BASENAME}_reboot.log
   lastmsg=`cat ${MINER_LOG_BASENAME}_reboot.log`
fi

if [[ -e ${MINER_LOG_BASENAME}_reboot.log ]]; then
  echo -e "=== Last 50 lines of ${MINER_LOG_BASENAME}.log ===\n`tail -n 50 ${MINER_LOG_BASENAME}_reboot.log`" | /hive/bin/message danger "$MINER_NAME reboot" payload
else
  /hive/bin/message danger "$lastmsg"
fi

#need nohup or the sreboot will stop miner and this process also in it
#nohup bash -c 'sreboot' > /tmp/nohup.log 2>&1 &
sreboot

exit 0
