#!/bin/bash
#Watchdog pinger for OpenDev products
#MUST BE RUN AS ROOT

#Bus 001 Device 002: ID 0483:5740 STMicroelectronics STM32F407


#grep processes but not a self sh script
if [ `ps aux | grep "watchdog-opendev-daemon" | grep -v grep | wc -l` -ne 0 ]; then
	echo "Killing Watchdog OpenDev existing process"
	killall -9 watchdog-opendev-daemon.sh
fi


c=`lsusb | grep 0483:5740 | wc -l`
echo "Watchdogs OpenDev found: $c"

if [ $c -eq 0 ]; then
	exit 1
fi



#detect port
for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do
(
	syspath="${sysdevpath%/dev}"
	devname="$(udevadm info -q name -p $syspath)"
	[[ "$devname" == "bus/"* ]] && continue
	#echo $syspath
	eval "$(udevadm info -q property --export -p $syspath)"
	[[ $ID_VENDOR_ID != 0483 && $ID_MODEL_ID != 5740 ]] && continue
	#echo "/dev/$devname - $ID_SERIAL"
	echo "$DEVNAME - $ID_SERIAL"
	
	#Starting actual daemon for watchdog
	path=$(dirname $(realpath $0))
	nohup $path/watchdog-opendev-daemon.sh $DEVNAME > /dev/null 2>&1 &
)
done

