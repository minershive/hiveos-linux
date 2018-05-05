#!/bin/bash

tmpDir="/hive/tmp"

rmmod k10tem
mkdir -p $tmpDir
cd $tmpDir
wget -c https://github.com/groeck/k10temp/archive/master.zip
unzip -o master.zip
cd k10temp-master
make
make install
modprobe k10temp
