#!/usr/bin/env bash

function miner_ver() {
	local MINER_VER=$GMINER_VER
	[[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
	echo $MINER_VER
}


function miner_config_echo() {
	local MINER_VER=`miner_ver`
	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/$MINER_NAME.conf"
}

function miner_config_gen() {
	local MINER_CONFIG="$MINER_DIR/$MINER_VER/$MINER_NAME.conf"
	mkfile_from_symlink $MINER_CONFIG

	[[ -z $GMINER_ALGO ]] && GMINER_ALGO="144_5"
	local host=`head -n 1 <<< "$GMINER_HOST"`
	local port=`head -n 1 <<< "$GMINER_PORT"`

	local conf="--algo $GMINER_ALGO --server $host --port $port --user $GMINER_TEMPLATE --pass $GMINER_PASS --pec $GMINER_USER_CONFIG"

	echo "$conf" > $MINER_CONFIG
}
