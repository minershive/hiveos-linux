#!/bin/sh
GPU_FORCE_64BIT_PTR=1 GPU_MAX_HEAP_SIZE=100 GPU_USE_SYNC_OBJECTS=1 GPU_MAX_ALLOC_PERCENT=100 GPU_SINGLE_ALLOC_PERCENT=100 ./gatelessgate -k pascal --gpu-platform 0 -o stratum+tcp://pasc.suprnova.cc:5279 -u zawawa.gatelessgate -p x -g 1 -I 21 -w 64

