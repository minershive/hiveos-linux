#!/usr/bin/env bash

[ -t 1 ] && . colors

#Ubuntu 18.04 compat
[[ -e /usr/lib/x86_64-linux-gnu/libcurl-compat.so.3.0.0 ]] && export LD_PRELOAD=libcurl-compat.so.3.0.0

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


echo -e "Running ${CYAN}cpuminer-opt${NOCOLOR} optimized for ${GREEN}$CPU_FLAG${NOCOLOR}" | tee /var/log/miner/cpuminer-opt/cpuminer-opt.log

./cpuminer-$CPU_FLAG -c cpuminer.conf $@ 2>&1 | tee /var/log/miner/cpuminer-opt/cpuminer-opt.log
