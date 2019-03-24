#!/usr/bin/env bash

[[ `ps aux | grep "./noncepool_miner" | grep -v grep | wc -l` != 0 ]] &&
  echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
  exit 1

tmp_dir=$MINER_DIR/tmpfs
$MINER_DIR/h-umount_tmpfs.sh $MINER_DIR/$MINER_VER/noncepool_miner $tmp_dir

if [[ $NONCEPOOL_NVIDIA_TMPFS -eq 1 ]]; then
  tmp_dir=$MINER_DIR/tmpfs
  [[ ! -d $tmp_dir ]] && mkdir -p $tmp_dir
  mount -t tmpfs -o size=1024M tmpfs $tmp_dir

  (crontab -l; echo "*/1 * * * * $MINER_DIR/h-umount_tmpfs.sh $MINER_DIR/$MINER_VER/noncepool_miner $tmp_dir") | crontab -
fi

cd $MINER_DIR/$MINER_VER
conf=`head -n 1 miner.conf`
stdbuf -oL -eL ./noncepool_miner $conf | tee $MINER_LOG_BASENAME.log 
#./noncepool_miner `cat miner.conf`
# 2>&1 #| tee $MINER_LOG_BASENAME.log

