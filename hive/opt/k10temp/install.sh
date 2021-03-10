#!/bin/bash
# quiet|force

[[ -t 1 ]] && source colors

tmpDir=/tmp
buildDir=$tmpDir/k10temp
srcDir=/hive/opt/k10temp/source

src_ver=`grep -m1 -oP "DRV_VER\s*:=\s*\K[^\s]+" $srcDir/Makefile 2>/dev/null`
cur_ver=`modinfo -F version k10temp 2>/dev/null`
if [[ $? -eq 0 ]]; then
	[[ "$1" != "quiet" ]] && echo -e "Installed module version: ${cur_ver:-unknown}"
	[[ "$1" != "force" && "$cur_ver" == "$src_ver" ]] && exit 0
fi

rmmod k10temp 2>/dev/null
mkdir -p $tmpDir

echo -e "${GREEN}> Building k10temp module ${src_ver}${NOCOLOR}"

[[ -d $buildDir ]] && rm -R $buildDir
cp -R $srcDir $buildDir
cd $buildDir
make

[[ $? -ne 0 ]] && echo "${RED}> Driver building error${NOCOLOR}" && exit 1

echo -e "${GREEN}> Driver integration${NOCOLOR}"

make install

cd ..
rm -R $buildDir

modprobe k10temp

if [[ $? -ne 0 ]]; then
	echo -e "${RED}> Module installation failed${NOCOLOR}"
	exit 1
fi

echo -e "${GREEN}> Installed, updating initramfs${NOCOLOR}"
update-initramfs -u
echo -e "${GREEN}Done. Have a happy CPU mining${NOCOLOR}"

exit 0
