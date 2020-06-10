#!/usr/bin/env bash

[[ `ps aux | grep "./xpmclient" | grep -v grep | wc -l` != 0 ]] &&
  echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
  exit 1

miner_run_dir="/run/hive/miners/$MINER_NAME"

ln -sfn $MINER_DIR/$MINER_FORK/$MINER_VER/xpm $miner_run_dir/xpm
ln -sf $MINER_DIR/$MINER_FORK/$MINER_VER/xpmclient $miner_run_dir/xpmclient
if [[ $MINER_FORK =~ "cuda" ]]; then
  ln -sf /hive/lib/libnvrtc-builtins.so.10.0.130 $miner_run_dir/libnvrtc-builtins.so
  ln -sf /hive/lib/libnvrtc.so.10.0.130 $miner_run_dir/libnvrtc.so.10.0
fi

cd $miner_run_dir
if [[ -f version ]]; then
  if [[ `cat version` != $MINER_FORK\\$MINER_VER ]]; then
    #remove *.bin becouse it had been created with other miner version
    rm -f *.bin
    echo $MINER_FORK\\$MINER_VER > version
  fi
else
  rm -f *.bin
  echo $MINER_FORK\\$MINER_VER > version
fi

# Miner run here
LD_LIBRARY_PATH=/hive/lib ./xpmclient 2>&1 | tee --append $MINER_LOG_BASENAME.log
