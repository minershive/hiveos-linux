#!/bin/bash
#MUST BE RUN AS ROOT
#3 minutes timeout by default, enough to reboot 
TIMEOUT=180

#Bus 001 Device 002: ID 16c0:03e8 Van Ooijen Technische Informatica free for internal lab use 1000

#grep processes but not a self sh script
if [ `ps aux | grep "watchdoginua " | grep -v grep | wc -l` -ne 0 ]; then
	echo "Killing Watchdog InUa existing process"
	killall -9 watchdoginua
fi

c=`lsusb | grep 16c0:03e8 | wc -l`
echo "Watchdogs InUa found: $c"

if [ $c -eq 0 ]; then
	exit 1
fi

path=$(dirname $(realpath $0))
#echo $path
#cd $path

#script pings watchdog every 5 seconds

nohup $path/watchdoginua $TIMEOUT > /dev/null 2>&1 &
