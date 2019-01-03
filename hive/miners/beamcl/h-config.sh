#!/usr/bin/env bash

function miner_ver() {
	local MINER_VER=$BEAMCL_VER
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

	[[ -z $BEAMCL_TEMPLATE ]] && echo -e "${YELLOW}BEAMCL_TEMPLATE is empty${NOCOLOR}" && return 1
	[[ -z $BEAMCL_URL ]] && echo -e "${YELLOW}BEAMCL_URL is empty${NOCOLOR}" && return 1

	local pool=`head -n 1 <<< "$BEAMCL_URL"`

	local conf="--server ${pool} --key ${BEAMCL_TEMPLATE} ${BEAMCL_USER_CONFIG}"

	echo "$conf" > $MINER_CONFIG
}
