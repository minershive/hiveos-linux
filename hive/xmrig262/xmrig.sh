#!/usr/bin/env bash
cd `dirname $0`

export LD_LIBRARY_PATH=../xmr-stak

./xmrig | tee /var/log/miner/xmrig/xmrig.log
