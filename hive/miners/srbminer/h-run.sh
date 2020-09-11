#!/usr/bin/env bash

# HugePages tunning
function HugePagesTune(){
   if [[ `echo $SRBMINER_ALGO | grep -c "^random"` -gt 0 ]]; then
     echo "Apply HugePages tuning for RandomX ..."
     hugepages -rx
   fi
}

[[ `ps aux | grep "SRBMiner-MULTI" | grep -v grep | wc -l` != 0 ]] &&
  echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
  exit 1

cd $MINER_DIR/$MINER_VER

HugePagesTune

unset LD_LIBRARY_PATH

conf=`cat $MINER_NAME.conf`

if [[ $conf=~';' ]]; then
  conf=`echo $conf | tr -d '\'`
#  conf=${conf//;/'\;'}
fi

eval "unbuffer ./SRBMiner-MULTI ${conf//;/'\;'} --api-enable --api-port $MINER_API_PORT --log-file $MINER_LOG_BASENAME.log"
