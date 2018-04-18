#!/bin/bash

# /hive-config/watchdog_srrv2.txt
#
# ENABLE=0/1
# SERIAL_NUMBER=000123
# SLOT_NUMBER=1-8


#grep processes but not a self sh script
PREVPID=`ps aux | grep "srrv2" | grep -v 'srrv2.sh' | grep -v grep | awk '{print $2}'`
if [[ ! -z $PREVPID ]]; then
	echo "Killing Watchdog srrv2 existing process $PREVPID"
	kill -9 $PREVPID
fi

SRRV2_CONF="/hive-config/watchdog_srrv2.txt"
[ ! -e $SRRV2_CONF ] && echo "Not found config $SRRV2_CONF" && exit 1

ENABLE=$(cat $SRRV2_CONF | grep 'ENABLE' | sed 's/ENABLE=//')
[ $ENABLE != "1" ] && echo "srrv2 disabled" && exit 1

SERIAL_NUMBER=$(cat $SRRV2_CONF | grep 'SERIAL_NUMBER' | sed 's/SERIAL_NUMBER=//')
SLOT_NUMBER=$(cat $SRRV2_CONF | grep 'SLOT_NUMBER' | sed 's/SLOT_NUMBER=//')
path=$(dirname $(realpath $0))

nohup $path/srrv2 $SERIAL_NUMBER $SLOT_NUMBER > /dev/null 2>&1 &
