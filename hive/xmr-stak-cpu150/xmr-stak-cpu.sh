#!/usr/bin/env bash
cd `dirname $0`

export LD_LIBRARY_PATH=../xmr-stak

./xmr-stak-cpu config.txt

