#!/usr/bin/env bash

# Memory pool tuning
export GPU_FORCE_64BIT_PTR=1
export GPU_MAX_HEAP_SIZE=100
export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100

#try to release TIME_WAIT sockets
while true; do
	for con in `netstat -anp | grep TIME_WAIT | grep $MINER_API_PORT | awk '{print $5}'`; do
		killcx $con lo
	done
	netstat -anp | grep TIME_WAIT | grep $MINER_API_PORT &&
		continue ||
		break
done



# Miner run here
cd $MINER_DIR/$MINER_FORK/$MINER_VER

# Hugepages tunning
if [[ ! -z $XMR_STAK_HUGEPAGES ]];
then
    hugepages $XMR_STAK_HUGEPAGES
else
   config=`cat config.txt`
   algo=`echo "{ $config }"| jq -r '.currency' | grep -c "^random"`
   if [[ "$algo" -gt 0 ]];
   then
       hugepages -rx
   fi
fi

./xmr-stak

