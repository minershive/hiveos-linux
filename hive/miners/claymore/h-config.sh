#!/usr/bin/env bash
# This code is included

function claymore_epools_gen() {
	[[ -z $EPOOLS_TPL ]] &&
		echo -e "${YELLOW}WARNING: EPOOLS_TPL is not set, skipping epools.txt generation${NOCOLOR}" &&
		return 1

	echo "Creating epools.txt"

	[[ ! -z $WORKER_NAME ]] && EPOOLS_TPL=$(sed "s/%WORKER_NAME%/$WORKER_NAME/g" <<< $EPOOLS_TPL) || echo -e "${RED}WORKER_NAME not set${NOCOLOR}"

	echo "$EPOOLS_TPL" > $CLAYMORE_EPOOLS_TXT

#	if [[ -z $EPOOLS_TPL ]]; then
#		echo -e "${YELLOW}WARNING: EPOOLS_TPL not set${NOCOLOR}"
#		#echo -e "${YELLOW}Will leave the file as it is{NOCOLOR}"
#		#echo "" > $CLAYMORE_EPOOLS_TXT
#	else
#	fi

	return 0
}


function claymore_dpools_gen() {
	#dpools is not required, so clear it
	if [[ -z $DPOOLS_TPL || -z $DCOIN ]]; then
		echo -e "${YELLOW}DPOOLS_TPL or DCOIN is not set, clearing dpools.txt and setting \"-mode 1\"${NOCOLOR}"
		echo -e "#Only Ethereum\n-mode 1\n" >> $CLAYMORE_CONFIG
		echo "" > $CLAYMORE_DPOOLS_TXT
		return 1
	fi

	echo "Creating dpools.txt"

	[[ ! -z $DWAL ]] && DPOOLS_TPL=$(sed "s/%DWAL%/$DWAL/g" <<< $DPOOLS_TPL)
	[[ ! -z $EMAIL ]] && DPOOLS_TPL=$(sed "s/%EMAIL%/$EMAIL/g" <<< $DPOOLS_TPL)
	[[ ! -z $WORKER_NAME ]] && DPOOLS_TPL=$(sed "s/%WORKER_NAME%/$WORKER_NAME/g" <<< $DPOOLS_TPL) || echo -e "${YELLOW}WORKER_NAME not set${NOCOLOR}"

	echo "$DPOOLS_TPL" > $CLAYMORE_DPOOLS_TXT

	#Claymore is degrading if no dcoin, but he still uses dcri and eth performance is lower

#Dual coin name
#-dcoin dcr
#Dual coin intensity
#-dcri 20
#Only Ethereum
#-mode 1

	[[ ! -z $DCOIN ]] && echo -e "#Dual coin name\n-dcoin $DCOIN\n" >> $CLAYMORE_CONFIG || echo echo -e "${YELLOW}DCOIN not set${NOCOLOR}"
	[[ ! -z $DCRI ]] && echo -e "#Dual coin intensity\n-dcri $DCRI\n" >> $CLAYMORE_CONFIG || echo echo -e "${YELLOW}DCRI not set${NOCOLOR}"

#	[[ ! -z $DCRI ]] && sed -i --follow-symlinks "s/^-dcri .*/-dcri $DCRI/g" $CLAYMORE_CONFIG || echo "DCRI not set"
#	[[ ! -z $DCOIN ]] && sed -i --follow-symlinks "s/^-dcoin.*/-dcoin $DCOIN/g" $CLAYMORE_CONFIG #|| echo "DCOIN not set

	return 0
}

function claymore_user_config_gen() {
	#sed -i --follow-symlinks "/^$CLAYMORE_USER_CONFIG_SEPARATOR$/,$ d" $CLAYMORE_CONFIG

	if [[ ! -z $CLAYMORE_USER_CONFIG ]]; then
		echo "$CLAYMORE_USER_CONFIG_SEPARATOR" >> $CLAYMORE_CONFIG
		echo "Appending user config";
		echo "$CLAYMORE_USER_CONFIG" >> $CLAYMORE_CONFIG
	fi
}





function miner_ver() {
	local MINER_VER=$CLAYMORE_VER
	[[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
	echo $MINER_VER
}


function miner_config_echo() {
	local MINER_VER=`miner_ver`

	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/config.txt"
	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/epools.txt"
	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/dpools.txt"
}


function miner_config_gen() {
	[[ -z $WORKER_NAME ]] && echo "ERROR: No WORKER_NAME set" && return 1

	CLAYMORE_CONFIG="$MINER_DIR/$MINER_VER/config.txt"
	CLAYMORE_EPOOLS_TXT="$MINER_DIR/$MINER_VER/epools.txt"
	CLAYMORE_DPOOLS_TXT="$MINER_DIR/$MINER_VER/dpools.txt"
	CLAYMORE_USER_CONFIG_SEPARATOR="### USER CONFIG ###"

	mkfile_from_symlink $CLAYMORE_CONFIG
	mkfile_from_symlink $CLAYMORE_EPOOLS_TXT
	mkfile_from_symlink $CLAYMORE_DPOOLS_TXT


	#eval "echo \"$(cat $MINER_DIR/config_global.txt)\"" > $CLAYMORE_CONFIG
	cat $MINER_DIR/config_global.txt | envsubst > $CLAYMORE_CONFIG

	claymore_epools_gen
	claymore_dpools_gen
	claymore_user_config_gen

}


