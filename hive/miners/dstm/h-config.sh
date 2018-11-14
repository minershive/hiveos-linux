#!/usr/bin/env bash

function miner_ver() {
	echo $MINER_LATEST_VER
}


function miner_config_echo() {
	local MINER_VER=`miner_ver`
	miner_echo_config_file "$MINER_DIR/$MINER_VER/zm.conf"
}


function miner_config_gen() {
	local MINER_CONFIG="$MINER_DIR/$MINER_VER/zm.conf"
	mkfile_from_symlink $MINER_CONFIG

	conf=`cat $MINER_DIR/$MINER_VER/zm-global.conf`$'\n'$'\n'

	if [[ ! -z $DSTM_USER_CONFIG ]]; then
		echo "$DSTM_USER_CONFIG" | grep -E "\-\-\w+" &&
			message warn "dstm config override has old syntax, please edit wallet" ||
			conf+="#User config overrides global"$'\n'$DSTM_USER_CONFIG$'\n'$'\n'
	fi

	for server in $DSTM_SERVER; do
		conf+="[POOL]"$'\n'
		conf+="server=$server"$'\n'
		[[ ! -z $DSTM_PORT ]] && conf+="port=$DSTM_PORT"$'\n'
		[[ ! -z $DSTM_TEMPLATE ]] && conf+="user=$DSTM_TEMPLATE"$'\n'
		[[ ! -z $DSTM_PASS ]] && conf+="pass=$DSTM_PASS"$'\n'
		conf+=$'\n'
	done

	echo "$conf" > $MINER_CONFIG
}
