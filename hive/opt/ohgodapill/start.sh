#!/usr/bin/env bash
. colors


RIG_CONF="/hive-config/rig.conf"
[[ ! -f $RIG_CONF ]] && exit 1

. $RIG_CONF



while true 
do

/hive/opt/ohgodapill/OhGodAnETHlargementPill-r2 > /var/run/hive/ohgodapill 
sleep 3
done


#exit 0