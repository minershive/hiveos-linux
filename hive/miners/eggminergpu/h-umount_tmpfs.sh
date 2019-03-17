#!/usr/bin/env bash

bin_name=$1 #"$MINER_DIR/$MINER_VER/eggminer"
tmp_dir=$2 #"$MINER_DIR/tmp/"

cmd_line=`ps aux | grep -v "h-umount_tmpfs.sh" | grep -v "grep" | grep ./eggminer`

if [[ -z $cmd_line ]]; then
  while [[ -e $tmp_dir/heavy3a.bin ]]; do

    rm -rf $tmp_dir/heavy3a.bin
    umount -f $tmp_dir

  done
  crontab -l | grep -v "$0" | crontab -
fi
