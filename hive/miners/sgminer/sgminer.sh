#!/usr/bin/env bash

#Ubuntu 18.04 compat
[[ -e /usr/lib/x86_64-linux-gnu/libcurl-compat.so.3.0.0 ]] && export LD_PRELOAD=libcurl-compat.so.3.0.0

export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_SINGLE_ALLOC_PERCENT=100
export GPU_MAX_ALLOC_PERCENT=100


cd `dirname $0`

#remove core dumps
rm ./*.bin > /dev/null 2>&1


fork=$1

[[ -z $fork ]] && fork="gm"

#[[ $1 == "nicehash" ]] && binary="sgminer_gm_nicehash"
#[[ $1 == "gm" ]] && binary="sgminer_gm"

echo "Fork version: $binary"
# TODO remove this then sgminer-gm will be fixed
# A little hack to fix monero:true parameter
SGMINER_GM_CLI_ARGS=""
SGMINER_GM_ARGS_MONERO=$(cat sgminer.conf | grep -Pow '\"monero\"\s*:.*true' | wc -l)
if [ $SGMINER_GM_ARGS_MONERO -ne 0 ]; then
  SGMINER_GM_CLI_ARGS=" --monero"
fi

./$fork/sgminer -c sgminer.conf $SGMINER_GM_CLI_ARGS
