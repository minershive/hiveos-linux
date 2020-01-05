#!/usr/bin/env bash

[[ `ps aux | grep "./eggminer" | grep -v grep | wc -l` != 0 ]] &&
  echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
  exit 1

tmp_dir=$MINER_DIR/tmpfs
$MINER_DIR/h-umount_tmpfs.sh $MINER_DIR/$MINER_VER/eggminer $tmp_dir

if [[ $EGGMINERGPU_TMPFS -eq 1 ]]; then
  [[ ! -d $tmp_dir ]] && mkdir -p $tmp_dir

  mount -t tmpfs -o size=1024M tmpfs $tmp_dir

  (crontab -l; echo "*/1 * * * * $MINER_DIR/h-umount_tmpfs.sh $MINER_DIR/$MINER_VER/eggminer $tmp_dir") | crontab -
fi

cd $MINER_DIR/$MINER_VER
./eggminer 2>&1 | tee --append $MINER_LOG_BASENAME.log
