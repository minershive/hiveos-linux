#!/usr/bin/env bash


[[ ! -e ./zm.conf ]] && echo "No zm.conf, exiting" && exit 1

conf=`cat ./zm.conf | grep -v "^$" | grep -v "^#"`

echo $conf
./zm `echo $conf` 2>&1 | tee /var/log/miner/dstm/dstm.log

