#!/bin/bash

# /hive-config/watchdog_srrv2.txt
#
# ENABLE=0/1
# SERIAL_NUMBER=000123
# SLOT_NUMBER=1-8
# EB_SERIAL=123456


#grep processes but not a self sh script
PREVPID=`ps aux | grep "srrv2" | grep -v 'srrv2.sh' | grep -v grep | awk '{print $2}'`
if [[ ! -z $PREVPID ]]; then
	echo "Killing Watchdog srrv2 existing process $PREVPID"
	kill -9 $PREVPID
fi

EB_SERIAL=""
SRRV2_CONF="/hive-config/watchdog_srrv2.txt"
[ ! -e $SRRV2_CONF ] && echo "Not found config $SRRV2_CONF" && exit 1
eval "`cat $SRRV2_CONF | dos2unix`"
[ $ENABLE != "1" ] && echo "srrv2 disabled" && exit 1

path=$(dirname $(realpath $0))
nohup $path/srrv2 $SERIAL_NUMBER $SLOT_NUMBER $EB_SERIAL > /dev/null 2>&1 &
