#!/usr/bin/env bash
#Watchdog pinger for OpenDev products
#MUST BE RUN AS ROOT


#grep processes but not a self sh script
PREVPID=`ps aux | grep "hl340" | grep -v 'hl340.sh' | grep -v grep | awk '{print $2}'`
if [[ ! -z $PREVPID ]]; then
	echo "Killing Watchdog QinHeng Electronics HL-340 existing process $PREVPID"
	kill -9 $PREVPID
fi


c=`lsusb | grep -E '1a86:7523' | wc -l`
echo "QinHeng Electronics HL-340 Watchdogs found: $c"

if [ $c -eq 0 ]; then
	exit 1
fi



#detect port
for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do
	syspath="${sysdevpath%/dev}"
	devname="$(udevadm info -q name -p $syspath)"
	[[ "$devname" == "bus/"* ]] && continue
	#echo $syspath
	#eval "$(udevadm info -q property --export -p $syspath)" #evals variables in scope
	eval "$(udevadm info -q property --export -p $syspath | grep -E 'ID_VENDOR_ID|ID_MODEL_ID|DEVNAME|ID_SERIAL')" #evals variables in scope and filter valid vars
	[[ $ID_VENDOR_ID != "1a86" ]] && continue
	[[ ! ($ID_MODEL_ID == "7523" ) ]] && continue
	#echo "/dev/$devname - $ID_SERIAL"
	echo "$DEVNAME - $ID_SERIAL"

	#Starting actual daemon for watchdog
	#path=$(dirname $(realpath $0))
	nohup /hive/opt/qinheng/hl340 ping $DEVNAME > /dev/null 2>&1 &
done

