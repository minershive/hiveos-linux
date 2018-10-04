#!/usr/bin/env bash

export LD_LIBRARY_PATH=/hive/lib

export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_SINGLE_ALLOC_PERCENT=100
export GPU_MAX_ALLOC_PERCENT=100

[[ ! -e ./ethminer.conf ]] && echo "No ethminer.conf, exiting" && exit 1

conf=`cat ./ethminer.conf | grep -v "^$" | grep -v "^#"`

#echo $conf outputs all in one line
echo $conf
ethminer `echo $conf` 2>&1 | tee /var/log/miner/ethminer/ethminer.log
