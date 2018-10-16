#!/usr/bin/env bash

MINER_CONFIG_FILE=`dirname $0`/bminer.conf

[[ ! -e $MINER_CONFIG_FILE ]] && echo "No $MINER_CONFIG_FILE, exiting" && exit 1

conf=`cat $MINER_CONFIG_FILE | grep -v "^$" | grep -v "^#"`

echo $conf
bminer `echo $conf` 2>&1 | tee /var/log/miner/bminer/bminer.log

