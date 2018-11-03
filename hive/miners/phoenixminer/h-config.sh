#!/usr/bin/env bash

function miner_ver() {
	echo $MINER_LATEST_VER
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

	coin=`echo $META | jq -r '.phoenixminer.coin' | awk '{print tolower($0)}'`
	[[ -z ${coin} ]] && coin="auto"
	[[ ! -z ${coin} ]] && coin="-coin ${coin}"

	#cat /hive/custom/${CUSTOM_NAME}/config_global.txt > $MINER_CONFIG || echo -e "${YELLOW}WORKER_NAME not set${NOCOLOR}"
	echo "-mport $MINER_API_PORT" > $MINER_CONFIG
	echo "-rmode 1" >> $MINER_CONFIG
	echo "-logfile ${MINER_LOG_BASENAME}.log" >> $MINER_CONFIG
	echo "-allpools 1" >> $MINER_CONFIG

	[[ -z $PHOENIXMINER_URL ]] && echo -e "${YELLOW}PHOENIX_URL is empty${NOCOLOR}" && return 1
	echo "Creating epools.txt"
	echo "$PHOENIXMINER_URL" > $MINER_EPOOLS

	#Don't remove until Hive 1 is gone
	[[ ! -z $EWAL ]] && sed -i "s/%EWAL%/$EWAL/g" $MINER_EPOOLS #|| echo "${RED}EWAL not set${NOCOLOR}"
	[[ ! -z $DWAL ]] && sed -i "s/%DWAL%/$DWAL/g" $MINER_EPOOLS #|| echo "${RED}DWAL not set${NOCOLOR}"
	[[ ! -z $ZWAL ]] && sed -i "s/%ZWAL%/$ZWAL/g" $MINER_EPOOLS #|| echo "${RED}ZWAL not set${NOCOLOR}"
	[[ ! -z $EMAIL ]] && sed -i "s/%EMAIL%/$EMAIL/g" $MINER_EPOOLS
	[[ ! -z $WORKER_NAME ]] && sed -i "s/%WORKER_NAME%/$WORKER_NAME/g" $MINER_EPOOLS

	if [[ ! -z $PHOENIXMINER_USER_CONFIG ]]; then
		echo "### USER CONFIG ###" >> $MINER_CONFIG
		echo "Appending user config";
		echo "$PHOENIXMINER_USER_CONFIG" >> $MINER_CONFIG

		#Don't remove until Hive 1 is gone
		[[ ! -z $EWAL ]] && sed -i "s/%EWAL%/$EWAL/g" $MINER_CONFIG #|| echo "${RED}EWAL not set${NOCOLOR}"
		[[ ! -z $DWAL ]] && sed -i "s/%DWAL%/$DWAL/g" $MINER_CONFIG #|| echo "${RED}DWAL not set${NOCOLOR}"
		[[ ! -z $ZWAL ]] && sed -i "s/%ZWAL%/$ZWAL/g" $MINER_CONFIG #|| echo "${RED}ZWAL not set${NOCOLOR}"
		[[ ! -z $EMAIL ]] && sed -i "s/%EMAIL%/$EMAIL/g" $MINER_CONFIG
		[[ ! -z $WORKER_NAME ]] && sed -i "s/%WORKER_NAME%/$WORKER_NAME/g" $MINER_CONFIG
	fi
}
