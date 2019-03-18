#!/usr/bin/env bash

[[ `ps aux | grep "./eggminer" | grep -v grep | wc -l` != 0 ]] &&
  echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
  exit 1



if [[ $EGGMINERGPU_TMPFS -eq 1 ]]; then
  tmp_dir=$MINER_DIR/tmpfs
  [[ ! -d $tmp_dir ]] && mkdir -p $tmp_dir
  mount -t tmpfs -o size=1024M tmpfs $tmp_dir

  (crontab -l; echo "*/1 * * * * $MINER_DIR/h-umount_tmpfs.sh $MINER_DIR/$MINER_VER/eggminer $tmp_dir") | crontab -
else
  tmp_dir=$MINER_DIR/tmp
  [[ ! -d $tmp_dir ]] && mkdir -p $tmp_dir
fi

cd $MINER_DIR/$MINER_VER
./eggminer 2>&1 | tee $MINER_LOG_BASENAME.log
