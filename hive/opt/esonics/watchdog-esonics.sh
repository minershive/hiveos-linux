#!/usr/bin/env bash
#MUST BE RUN AS ROOT
#timeout should be enough to reboot
RESET_TIMEOUT=300
POWER_TIMEOUT=600

# Bus 001 Device 002: ID 11d7:41ff

#grep processes but not a self sh script
pid=`ps aux | grep "WatchDogUtility/src/utility.py" | grep -v grep | awk '{print $2}'`
if [[ $pid > 0 ]]; then
	echo "Killing Esonics Utility existing process PID=$pid"
	kill -9 $pid
	sleep 2
fi

c=`lsusb | grep 11d7:41ff | wc -l`
echo "Esonics Watchdogs found: $c"

if [ $c -eq 0 ]; then
	exit 1
fi

path=$(dirname $(realpath $0))
#echo $path
#cd $path

nohup /hive/opt/esonics/WatchDogUtility/src/utility.py --reset $RESET_TIMEOUT --power $POWER_TIMEOUT > /dev/null 2>&1 &
