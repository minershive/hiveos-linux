cd `dirname $0`

export LD_LIBRARY_PATH=./cuda

./ccminer -c pools.conf $@ | tee ./ccminer.log
