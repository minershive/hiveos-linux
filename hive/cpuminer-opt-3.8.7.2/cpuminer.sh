#!/usr/bin/env bash

[ -t 1 ] && . colors

HOMEPREFIX=""
#CPU_INFO=`lscpu`
CPU_INFO=`cat /proc/cpuinfo | grep flags`
#echo $CPU_INFO
FLAG_SSE2=`echo ${CPU_INFO} | grep -c " sse2 "`
FLAG_SSE42=`echo ${CPU_INFO} | grep -c " sse4_2 "`
FLAG_AVX=`echo ${CPU_INFO} | grep -c " avx "`
FLAG_AES=`echo ${CPU_INFO} | grep -c " aes "`
FLAG_AVX2=`echo ${CPU_INFO} | grep -c " avx2 "`
FLAG_SHA=`echo ${CPU_INFO} | grep -c " sha "`

#echo SSE2:$FLAG_SSE2 SSE42:$FLAG_SSE42 AVX:$FLAG_AVX AES:$FLAG_AES AVX2:$FLAG_AVX2 SHA:$FLAG_SHA

CPU_FLAG="sse2"

if [ $FLAG_SSE2 -eq 1 ] && [ $FLAG_SSE42 -eq 1 ] && [ $FLAG_AVX -eq 0 ] && [ $FLAG_AES -eq 0 ] && [ $FLAG_AVX2 -eq 0 ]
then
    CPU_FLAG="sse42"
fi


if [ $FLAG_SSE2 -eq 1 ] && [ $FLAG_SSE42 -eq 1 ] && [ $FLAG_AVX -eq 1 ] && [ $FLAG_AES -eq 0 ] && [ $FLAG_AVX2 -eq 0 ]
then
    CPU_FLAG="avx"
fi

if [ $FLAG_SSE2 -eq 1 ] && [ $FLAG_SSE42 -eq 1 ] && [ $FLAG_AVX -eq 1 ] && [ $FLAG_AES -eq 1 ] && [ ! $FLAG_AVX2 -eq 0 ]
then
    CPU_FLAG="aes-avx"
fi

if [ $FLAG_SSE2 -eq 1 ] && [ $FLAG_SSE42 -eq 1 ] && [ $FLAG_AVX -eq 0 ] && [ $FLAG_AES -eq 1 ] && [ $FLAG_AVX2 -eq 0 ]
then
    CPU_FLAG="aes-sse42"
fi

if [ $FLAG_AVX2 -eq 1 ] && [ $FLAG_SHA -eq 1 ]
then
    CPU_FLAG="sha-avx2"
else
  if [ $FLAG_AVX2 -eq 1 ]
  then
    CPU_FLAG="avx2"
  fi
fi

echo -e "Running ${CYAN}cpuminer-opt${NOCOLOR} optimized for ${GREEN}$CPU_FLAG${NOCOLOR}" 
#| tee $HOMEPREFIX/var/log/cpuminer-opt/cpuminer-opt.log

./cpuminer-$CPU_FLAG -c cpuminer.conf | tee $HOMEPREFIX/var/log/cpuminer-opt/cpuminer-opt.log
