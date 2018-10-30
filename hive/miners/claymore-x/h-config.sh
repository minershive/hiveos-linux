#!/usr/bin/env bash

function claymore_xpools_gen() {
	[[ -z $XPOOLS_TPL ]] &&
		echo -e "${YELLOW}WARNING: XPOOLS_TPL is not set, skipping epools.txt generation${NOCOLOR}" &&
		return 1

	echo "Creating epools.txt"

#	[[ -z $EWAL && -z $ZWAL && -z $DWAL ]] && echo -e "${RED}No WAL address is set${NOCOLOR}"
	[[ ! -z $EWAL ]] && XPOOLS_TPL=$(sed "s/%EWAL%/$EWAL/g" <<< $XPOOLS_TPL)
	[[ ! -z $DWAL ]] && XPOOLS_TPL=$(sed "s/%DWAL%/$DWAL/g" <<< $XPOOLS_TPL)
	[[ ! -z $ZWAL ]] && XPOOLS_TPL=$(sed "s/%ZWAL%/$ZWAL/g" <<< $XPOOLS_TPL)
	[[ ! -z $EMAIL ]] && XPOOLS_TPL=$(sed "s/%EMAIL%/$EMAIL/g" <<< $XPOOLS_TPL)
	[[ ! -z $WORKER_NAME ]] && XPOOLS_TPL=$(sed "s/%WORKER_NAME%/$WORKER_NAME/g" <<< $XPOOLS_TPL) || echo -e "${RED}WORKER_NAME not set${NOCOLOR}"

	echo "$XPOOLS_TPL" > $CLAYMORE_XPOOLS_TXT

	return 0
}




function claymore_user_config_gen() {
	if [[ ! -z $CLAYMORE_X_USER_CONFIG ]]; then
		echo "$CLAYMORE_USER_CONFIG_SEPARATOR" >> $CLAYMORE_X_CONFIG
		echo "Appending user config";
		echo "$CLAYMORE_X_USER_CONFIG" >> $CLAYMORE_X_CONFIG
	fi
}





function miner_ver() {
	echo $MINER_LATEST_VER
}


function miner_config_echo() {
	local MINER_VER=`miner_ver`

	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/config.txt"
	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/epools.txt"
}


function miner_config_gen() {
	[[ -z $WORKER_NAME ]] && echo "ERROR: No WORKER_NAME set" && return 1


	local MINER_VER=`miner_ver`

	CLAYMORE_X_CONFIG="$MINER_DIR/$MINER_VER/config.txt"
	CLAYMORE_XPOOLS_TXT="$MINER_DIR/$MINER_VER/epools.txt"
	CLAYMORE_USER_CONFIG_SEPARATOR="### USER CONFIG ###"

	mkfile_from_symlink $CLAYMORE_X_CONFIG
	mkfile_from_symlink $CLAYMORE_XPOOLS_TXT

	cat /hive/miners/claymore/config_global.txt | envsubst > $CLAYMORE_X_CONFIG

	claymore_xpools_gen
	claymore_user_config_gen
}


