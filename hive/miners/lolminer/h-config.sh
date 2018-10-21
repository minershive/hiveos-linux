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

	conf=""
	[ ! -f $RIG_CONF ] && echo -e "${RED}No rig config $RIG_CONF${NOCOLOR}" && return 1
	[ ! -f $WALLET_CONF ] && echo -e "${RED}No wallet config $WALLET_CONF${NOCOLOR}" && return 2
	[ ! -f $GLOBAL_CONFIG ] && echo -e "${RED}Global config template not found${NOCOLOR}" && return 3

#	. $RIG_CONF
#	. $WALLET_CONF

	if [[ ! -z $LOLMINER_USER_CONFIG ]]; then
		conf+="$LOLMINER_USER_CONFIG "
	fi

	[[ ! -z $LOLMINER_SERVER ]]   && conf+="--pool $LOLMINER_SERVER "
	[[ ! -z $LOLMINER_PORT ]]     && conf+="--port $LOLMINER_PORT "
	[[ ! -z $LOLMINER_TEMPLATE ]] && conf+="--user $LOLMINER_TEMPLATE "
	[[ ! -z $LOLMINER_PASS ]]     && conf+="--pass $LOLMINER_PASS "
	conf+="--apiport $MINER_API_PORT "
	conf+=`cat $GLOBAL_CONFIG`

	#replace tpl values in whole file
#	[[ -z $EWAL && -z $ZWAL && -z $DWAL ]] && echo -e "${RED}No WAL address is set${NOCOLOR}"
	[[ ! -z $EWAL ]] && conf=$(sed "s/%EWAL%/$EWAL/g" <<< "$conf")
	[[ ! -z $ZWAL ]] && conf=$(sed "s/%ZWAL%/$ZWAL/g" <<< "$conf")
	[[ ! -z $DWAL ]] && conf=$(sed "s/%DWAL%/$DWAL/g" <<< "$conf")
	[[ ! -z $EMAIL ]] && conf=$(sed "s/%EMAIL%/$EMAIL/g" <<< "$conf")
	[[ ! -z $WORKER_NAME ]] && conf=$(sed "s/%WORKER_NAME%/$WORKER_NAME/g" <<< "$conf") #|| echo "${RED}WORKER_NAME not set${NOCOLOR}"

	echo "$conf" > $MINER_CONFIG
}
