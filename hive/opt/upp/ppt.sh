#!/usr/bin/env bash

gfx=1150
vdd=850
mvdd=840
vddci=880
mclk=920

python upp.py -i /sys/class/drm/card1/device/pp_table set \
GfxClockDependencyTable/3/Clock=$(( ($gfx)*100 )) \
GfxClockDependencyTable/4/Clock=$(( ($gfx)*100 )) \
GfxClockDependencyTable/5/Clock=$(( ($gfx)*100 )) \
GfxClockDependencyTable/6/Clock=$(( ($gfx)*100 )) \
GfxClockDependencyTable/7/Clock=$(( ($gfx)*100 )) \
VddcLookupTable/1/Vdd=$vdd \
VddcLookupTable/2/Vdd=$mvdd \
VddcLookupTable/3/Vdd=$vdd \
VddcLookupTable/4/Vdd=$vdd \
VddcLookupTable/5/Vdd=$vdd \
VddcLookupTable/6/Vdd=$vdd \
VddcLookupTable/7/Vdd=$vdd \
VddciLookupTable/0/Vdd=$vddci \
MemClockDependencyTable/3/MemClock=$(($mclk*100)) \
 --write

 rocm-smi -d 1 --setfan 125
