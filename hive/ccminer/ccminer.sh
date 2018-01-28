#!/usr/bin/env bash
cd `dirname $0`
[ -t 1 ] && . colors

export LD_LIBRARY_PATH=./cuda


fork=$1

#set default fork
if [[ -z $fork ]]; then
	WALLET_CONF="/hive-config/wallet.conf"
	. $WALLET_CONF

	if [[ ! -z $CCMINER_FORK ]]; then
		fork=$CCMINER_FORK
	else
		fork="tpruvot"
	fi
fi


binary="ccminer-$fork"
echo -e "Fork version: ${GREEN}$fork${NOCOLOR}"


if [[ ! -e $binary ]]; then
	url=http://download.hiveos.farm/ccminer/cuda9/$binary.gz
	gz=$binary.gz
	echo -e "${YELLOW}Downloading $gz this can take some time${NOCOLOR}"
	wget $url -O $gz
	[[ $? -ne 0 ]] &&
		echo -e "${RED}Failed to download $url${NOCOLOR}" &&
		rm $gz &&
		exit 1

	gunzip -v $gz
	[[ $? -ne 0 ]] &&
		echo -e "${RED}Unable to decompress $gz${NOCOLOR}" &&
		exit 1

	chmod +x $binary
fi


[[ ! -e $binary ]] &&
	echo -e "${RED}/hive/ccminer/$binary does not exist, check installation${NOCOLOR}" &&
	exit 1

./$binary -c pools.conf $@ | tee ./ccminer.log
