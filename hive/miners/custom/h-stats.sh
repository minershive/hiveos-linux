#!/usr/bin/env bash


if [[ -z $CUSTOM_MINER ]]; then
	echo -e "${RED}\$CUSTOM_MINER is not defined${NOCOLOR}"
else
	if [[ ! -e /hive/custom/$CUSTOM_MINER/h-stats.sh ]]; then
		echo -e "${RED}/hive/custom/$CUSTOM_MINER/h-stats.sh is not implemented${NOCOLOR}"
	else
		source /hive/custom/$CUSTOM_MINER/h-stats.sh
	fi
fi