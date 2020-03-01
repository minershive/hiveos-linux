#!/usr/bin/env bash

# HugePages tunning reset
function HugePagesReset(){
   if [[ `echo $SRBMINER_ALGO | grep -c "^randomx"` -gt 0 ]]; then
     echo "Reset HugePages tuning for RandomX to system default..."
     hugepages -r
   fi
}

HugePagesReset

