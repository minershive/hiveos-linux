#!/bin/sh
GPU_FORCE_64BIT_PTR=1 GPU_MAX_HEAP_SIZE=100 GPU_USE_SYNC_OBJECTS=1 GPU_MAX_ALLOC_PERCENT=100 GPU_SINGLE_ALLOC_PERCENT=100 ./gatelessgate --gpu-platform 0 --default-config gatelessgate-Zcash.conf

