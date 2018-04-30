#!/usr/bin/env bash
. colors


RIG_CONF="/hive-config/rig.conf"
[[ ! -f $RIG_CONF ]] && exit 1

. $RIG_CONF

if [  $TABLETKA -eq 1 ];then

while true 
do

/hive/opt/tabletka/OhGodAnETHlargementPill-r2 > /var/run/hive/tabletka 
sleep 3
done

fi
#exit 0