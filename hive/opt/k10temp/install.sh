#!/bin/bash

[ -t 1 ] && . /hive/bin/colors


echo -e "${GREEN}> Installing k10temp module${NOCOLOR}"

tmpDir="/hive/tmp"
#downloadUrl="https://github.com/groeck/k10temp/archive/master.zip"

rmmod k10temp
#mkdir -p $tmpDir
#cd $tmpDir

#wget -c --no-check-certificate $downloadUrl
#[ $? -ne 0 ] && echo -e "${RED}Error downloading $downloadUrl${NOCOLOR}" && exit 1


#unzip -o master.zip
#cd k10temp-master
[[ -e /hive/opt/k10temp/build ]] && rm -R /hive/opt/k10temp/build
cp -R /hive/opt/k10temp/source /hive/opt/k10temp/build
cd /hive/opt/k10temp/build
make

[ $? -ne 0 ] && echo "${RED}> Driver building error" && exit 1

echo -e "${GREEN}> Driver integration${NOCOLOR}"

make install
#cd ..
#rm -rf k10temp-master
#rm master.zip
cd ..
rm -R /hive/opt/k10temp/build
modprobe k10temp

if [[ $? = 0 ]]; then
	echo -e "${GREEN}> Installed, updating initramfs${NOCOLOR}"
else
	echo -e "${RED}> Module installation failed${NOCOLOR}"
	exit 1
fi

update-initramfs -u
echo -e "${GREEN}Done. Have a happy CPU mining${NOCOLOR}"
exit 0
