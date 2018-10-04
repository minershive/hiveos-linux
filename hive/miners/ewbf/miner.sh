#!/usr/bin/env bash
cd `dirname $0`

fork=$1
if [[ -z $fork ]]; then
	fork="legacy"
fi

export LD_LIBRARY_PATH=./$fork/
./$fork/miner
