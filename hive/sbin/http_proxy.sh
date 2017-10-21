#!/usr/bin/env bash
#Sets environment for HTTP PROXY from /hive-config/http_proxy.txt
#ls -s /etc/profile.d/http_proxy.sh

[[ ! -e /hive-config/http_proxy.txt ]] && exit

#echo "http_proxy EXISTS====================="
#unix=`tr -d '\r' < /hive-config/http_proxy.txt`
#`sed 's/^M$//' /hive-config/http_proxy.txt`"

#this might be windows file
#don't create it every time
[[ ! -e /tmp/http_proxy.txt ]] &&
tr -d '\r' < /hive-config/http_proxy.txt > /tmp/http_proxy.txt

. /tmp/http_proxy.txt

#checking
#echo $http_proxy
