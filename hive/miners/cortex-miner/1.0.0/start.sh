#! /bin/bash
export LD_LIBRARY_PATH=/usr/local/cuda/lib64/:/usr/local/cuda/lib64/stubs:$LD_LIBRARY_PATH
export LIBRARY_PATH=/usr/local/cuda/lib64/:/usr/local/cuda/lib64/stubs:$LIBRARY_PATH
export PATH=/usr/local/go/bin:/usr/local/cuda/bin/:$PATH
NVIDIA_COUNT=`nvidia-smi -L | grep 'GeForce' | wc -l`
echo "there has "$NVIDIA_COUNT "gpu"
str=""
for ((i=0; i < $NVIDIA_COUNT; i++))
do
 str=$str$i
 if [ $i -lt $[$NVIDIA_COUNT - 1] ]; then
  str=$str,
 fi
done

worker='your worker name'
pool_uri='the remote pool uri, example: xxxx@xxx.com:8008'
pool_uri_1='the first candidate pool uri'
pool_uri_2='the second candidate pool uri'
device=$str
account='you wallet address, example:0x0000000000000000000000000'
start='./cortex_miner -pool_uri='$pool_uri' -pool_uri_1='$pool_uri_1' -pool_uri_2='$pool_uri_2' -worker='$worker' -devices='$device' -account='$account
echo $start
$start
