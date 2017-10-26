#!/usr/bin/env bash
#Sets environment for HTTP PROXY from /hive-config/network/http_proxy.txt
#ln -s /etc/profile.d/http_proxy.sh

#DONT EXIT FROM THIS PROCESS!!!

if [[ -e /hive-config/network/http_proxy.txt ]]; then
	#echo "http_proxy EXISTS====================="
	#unix=`tr -d '\r' < /hive-config/http_proxy.txt`
	#`sed 's/^M$//' /hive-config/http_proxy.txt`"

	#this might be windows file
	#don't create it every time
	[[ ! -e /tmp/http_proxy.txt ]] &&
		cp /hive-config/network/http_proxy.txt /tmp/http_proxy.txt &&
		dos2unix-safe /tmp/http_proxy.txt


	#Read variables
	. /tmp/http_proxy.txt

	#checking
	#echo $http_proxy

	#tr -d '\r' < /hive-config/network/http_proxy.txt > /tmp/http_proxy.txt
fi