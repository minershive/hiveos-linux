#!/usr/bin/env bash

[[ `ps aux | grep "./FAHClient" | grep -v grep | wc -l` != 0 ]] &&
  while killall FAHClient; do 
    sleep 1
  done

cd $MINER_DIR/$MINER_VER

./FAHClient 2>&1
