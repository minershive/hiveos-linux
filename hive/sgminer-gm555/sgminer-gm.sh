#!/usr/bin/env bash

export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_SINGLE_ALLOC_PERCENT=100
export GPU_MAX_ALLOC_PERCENT=100


cd `dirname $0`

#remove core dumps
rm ./*.bin > /dev/null 2>&1


binary="sgminer_gm"

[[ $1 == "nicehash" ]] && binary="sgminer_gm_nicehash"
[[ $1 == "gm" ]] && binary="sgminer_gm"


echo "Fork version: $binary"

./$binary -c sgminer-gm.conf
