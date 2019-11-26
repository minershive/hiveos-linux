#!/bin/bash

export LD_LIBRARY_PATH=/hive/lib

#Important : Make sure you tune intensity(-i) for your cards. It does support decimals for fine tuning (26.5).
./noncerpro --address=9953c3f7d843f95cf3c6bcb115444d238fc0e38bc3bc818d55ac42bd23408006   --server=fr3.chainweb.com   --port=443     -i 26

#eg : ./noncerpro --address=abf6f1c3d583dfc180189a4ad6c5bfa62b29fa2669dad25b8c6d700dbd3c96f8 --server=us1.chainweb.com --port=443 -i 26
