#!/usr/bin/env bash

#CPU_INFO=`lscpu`
CPU_INFO=`cat /proc/cpuinfo | grep flags`
#echo $CPU_INFO
FLAG_SSE2=`echo ${CPU_INFO} | grep -c " sse2 "`
FLAG_SSE42=`echo ${CPU_INFO} | grep -c " sse4_2 "`
FLAG_AVX=`echo ${CPU_INFO} | grep -c " avx "`
FLAG_AES=`echo ${CPU_INFO} | grep -c " aes "`
FLAG_AVX2=`echo ${CPU_INFO} | grep -c " avx2 "`
FLAG_SHA=`echo ${CPU_INFO} | grep -c " sha_ni "`

#echo SSE2:$FLAG_SSE2 SSE42:$FLAG_SSE42 AVX:$FLAG_AVX AES:$FLAG_AES AVX2:$FLAG_AVX2 SHA:$FLAG_SHA

#try to release TIME_WAIT sockets
while true; do
	for con in `netstat -anp | grep TIME_WAIT | grep $MINER_API_PORT | awk '{print $5}'`; do
		killcx $con lo
	done
	netstat -anp | grep TIME_WAIT | grep $MINER_API_PORT &&
		continue ||
		break
done

if [[ $FLAG_SSE2 == 1 && $FLAG_SSE42 == 1 && $FLAG_AVX == 0 && $FLAG_AES == 0 && $FLAG_AVX2 == 0 ]]; then
    CPU_FLAG="sse42"
elif [[ $FLAG_SSE2 == 1 && $FLAG_SSE42 == 1 && $FLAG_AVX == 1 && $FLAG_AES == 0 && $FLAG_AVX2 == 0 ]]; then
    CPU_FLAG="avx"
elif [[ $FLAG_SSE2 == 1 && $FLAG_SSE42 == 1 && $FLAG_AVX == 1 && $FLAG_AES == 1 && $FLAG_AVX2 == 0 ]]; then
    CPU_FLAG="aes-avx"
elif [[ $FLAG_SSE2 == 1 && $FLAG_SSE42 == 1 && $FLAG_AVX == 0 && $FLAG_AES == 1 && $FLAG_AVX2 == 0 ]]; then
    CPU_FLAG="aes-sse42"
elif [[ $FLAG_AVX2 == 1 && $FLAG_SHA == 1 ]]; then
    CPU_FLAG="avx2-sha"
elif [[ $FLAG_AVX2 == 1 ]]; then
	CPU_FLAG="avx2"
else
	CPU_FLAG="sse2"
fi

echo -e "Running ${CYAN}cpuminer-opt-$MINER_FORK${NOCOLOR} optimized for ${GREEN}$CPU_FLAG${NOCOLOR}" | tee ${MINER_LOG_BASENAME}.log

cd ${MINER_DIR}/${MINER_FORK}/${MINER_VER}

./cpuminer-$CPU_FLAG -c cpuminer.conf 2>&1 | tee ${MINER_LOG_BASENAME}.log
