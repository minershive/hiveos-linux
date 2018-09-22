#!/usr/bin/env bash
#. colors
#
#

. $NVIDIA_OC_CONF

while true; do
	#Sleep before running
	[[ ! -z $OHGODAPILL_START_TIMEOUT ]] &&
		sleep $OHGODAPILL_START_TIMEOUT

	/hive/opt/ohgodapill/OhGodAnETHlargementPill-r2 $@ > /var/run/hive/ohgodapill 2>&1

	sleep 1
done


#exit 0