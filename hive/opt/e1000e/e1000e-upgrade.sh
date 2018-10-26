#!/usr/bin/env bash

. colors

[[ ! -z $1 ]] &&
	driverVersion=$1 ||
	driverVersion="3.4.2.1"


archName="e1000e-$driverVersion.tar.gz"
downloadUrl="https://downloadmirror.intel.com/15817/eng/$archName"
tmpDir="/hive/tmp"
archpath="$tmpDir/$archName"

echo -e "${WHITE}> Installing Intel's E1000E driver${NOCOLOR}"
echo -e "${YELLOW}> Current driver "$(modinfo e1000e | grep ^version)${NOCOLOR}

## Download
mkdir -p $tmpDir
cd $tmpDir
echo -e "${WHITE}> Downloading $downloadUrl${NOCOLOR}"
[[ -f $archpath ]] && echo -e "> $archpath found locally, maybe incomplete, trying to recover"
wget -c $downloadUrl
[ $? -ne 0 ] && echo -e "${RED}Error downloading $downloadUrl${NOCOLOR}" && exit 1

## Unpack
tar xvfz ./$archName

## Build
echo -e "${WHITE}> Building Intel's E1000E driver${NOCOLOR}"
cd $tmpDir/e1000e-$driverVersion/src
make
[ $? -ne 0 ] && echo "${RED}> Driver building error" && exit 1

## Install
echo -e "${WHITE}> Intel's E1000E driver kernel integration${NOCOLOR}"
rmmod e1000e
cp ./e1000e.ko /lib/modules/$(uname -r)/kernel/drivers/net/ethernet/intel/e1000e/e1000e.ko
modprobe e1000e
update-initramfs -u

echo -e "${GREEN}> Intel's E1000E driver installed${NOCOLOR}"
echo -e "${YELLOW}> Current driver "$(modinfo e1000e | grep ^version)${NOCOLOR}
