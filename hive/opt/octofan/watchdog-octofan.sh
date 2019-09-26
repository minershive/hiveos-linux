#!/usr/bin/env bash
#MUST BE RUN AS ROOT

#Bus 001 Device 002: ID 16c0:05dc Van Ooijen Technische Informatica shared ID for use with libusb

#grep processes but not a self sh script
PREVPID=`ps aux | grep "watchdog-octofan" | grep -v 'watchdog-octofan.sh' | grep -v grep | awk '{print $2}'`
if [[ ! -z $PREVPID ]]; then
  echo "Killing Octofan Watchdog existing process $PREVPID"
  kill -9 $PREVPID
fi


c=`lsusb | grep -E '16c0:05dc' | wc -l`
echo "Octofan Watchdogs found: $c"

if [ $c -eq 0 ]; then
  exit 1
fi

#nohup /hive/opt/octofan/watchdog-octofan ping 2>&1 &
screen -dmS watchdog-octofan /hive/opt/octofan/watchdog-octofan ping
