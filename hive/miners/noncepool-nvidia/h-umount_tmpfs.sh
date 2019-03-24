#!/usr/bin/env bash

bin_name=$1
tmp_dir=$2

cmd_line=`ps aux | grep -v "h-umount_tmpfs.sh" | grep -v "grep" | grep ./noncepool_miner`

if [[ -z $cmd_line ]]; then
  while [[ -e $tmp_dir/heavy3.bin ]]; do

    rm -rf $tmp_dir/heavy3.bin
    umount -f $tmp_dir

  done
  crontab -l | grep -v "$0" | crontab -
fi
