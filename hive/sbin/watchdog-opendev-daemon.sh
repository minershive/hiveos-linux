#!/bin/bash

PORT=/dev/ttyACM0

[[ ! -z $1 ]] &&
	PORT=$1 ||
	echo "No port given, using default"

echo "Using $PORT"

[[ ! -c $PORT ]] &&
	echo "$PORT is not a character device" &&
	exit 1

while true
do
	echo "Pinging watchdog"
	echo -n "~U" > $PORT
	sleep 2
done
