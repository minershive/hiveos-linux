#!/usr/bin/env bash

function miner_ver() {
	echo $MINER_LATEST_VER
}

function miner_config_echo() {
	local MINER_VER=`miner_ver`
-	miner_echo_config_file "$MINER_DIR/$MINER_VER/lolminer.conf"
}

function miner_config_gen() {
	MINER_CONFIG="$MINER_DIR/$MINER_VER/lolminer.conf"
	GLOBAL_CONFIG="$MINER_DIR/$MINER_VER/global_config.conf"

	if [ -z $LOLMINER_ALGO ]; then
	    coin="AUTO144_5"
	else
	    coin=$LOLMINER_ALGO
	fi
	conf="--coin $coin\n"
	[[ ! -z $LOLMINER_SERVER ]]   && conf+="--pool $LOLMINER_SERVER\n"
	[[ ! -z $LOLMINER_PORT ]]     && conf+="--port $LOLMINER_PORT\n"
	[[ ! -z $LOLMINER_TEMPLATE ]] && conf+="--user $LOLMINER_TEMPLATE\n"
	[[ ! -z $LOLMINER_PASS ]]     && conf+="--pass $LOLMINER_PASS\n"
	conf+="--apiport $MINER_API_PORT\n"
	conf+=`cat $GLOBAL_CONFIG`
	if [[ ! -z $LOLMINER_USER_CONFIG ]]; then
		conf+="$LOLMINER_USER_CONFIG\n"
	fi

	#replace tpl values in whole file
	[[ ! -z $WORKER_NAME ]] && conf=$(sed "s/%WORKER_NAME%/$WORKER_NAME/g" <<< "$conf") #|| echo "${RED}WORKER_NAME not set${NOCOLOR}"

	echo -e "$conf" > $MINER_CONFIG
}
