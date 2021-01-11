#!/usr/bin/env bash

function miner_ver() {
	local MINER_VER=$PHOENIXMINER_VER
	[[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
	echo $MINER_VER
}


function miner_config_echo() {
	local MINER_VER=`miner_ver`
	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/config.txt"
	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/epools.txt"
}

function miner_config_gen() {

	local MINER_CONFIG="$MINER_DIR/$MINER_VER/config.txt"
	mkfile_from_symlink $MINER_CONFIG

	local MINER_EPOOLS="$MINER_DIR/$MINER_VER/epools.txt"
	mkfile_from_symlink $MINER_EPOOLS

	echo "" > $MINER_CONFIG

	# coin=`echo $META | jq -r '.phoenixminer.coin' | awk '{print tolower($0)}'`
	# grep -q "nicehash" <<< $coin
	# [[ $? -eq 0 || -z ${coin} ]] && coin="auto"
	# [[ ! -z ${coin} ]] && echo "-coin $coin" >> $MINER_CONFIG

	[[ -z $PHOENIXMINER_URL ]] && echo -e "${YELLOW}PHOENIX_URL is empty${NOCOLOR}" && return 1
	echo "Creating epools.txt"
	echo "$PHOENIXMINER_URL" > $MINER_EPOOLS

	if [[ ! -z $PHOENIXMINER_USER_CONFIG ]]; then
		echo "### USER CONFIG ###" >> $MINER_CONFIG
		echo "Appending user config";
		echo "$PHOENIXMINER_USER_CONFIG" >> $MINER_CONFIG
	fi

	echo "-cdmport $MINER_API_PORT" >> $MINER_CONFIG
	echo "-cdm 1" >> $MINER_CONFIG
	echo "-rmode 2" >> $MINER_CONFIG
	echo "-logfile ${MINER_LOG_BASENAME}.log" >> $MINER_CONFIG
	# echo "-allpools 1" >> $MINER_CONFIG
}
