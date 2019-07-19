#!/usr/bin/env bash
# This code is included

#Try to wait for ending process, maybe too fast after restart
for i in {1..5}; do
	ps aux | grep -v grep | grep $CLAYMORE_BINARY_NAME | grep "<defunct>" &&
		(echo "Waiting for previous process to end..."; sleep 1) ||
		break
done


[[ `ps aux | grep $CLAYMORE_BINARY_NAME | grep -v grep | wc -l` != 0 ]] &&
	echo -e "${RED}$CLAYMORE_BINARY_NAME is already running${NOCOLOR}" &&
	exit 1


#export GPU_FORCE_64BIT_PTR=0        # for R9 family need set to 1
export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100  # fixed DAG loading to cards with 4G for epoch 270+

cd $MINER_DIR/$MINER_VER

./$CLAYMORE_BINARY_NAME
