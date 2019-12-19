#!/usr/bin/env bash

function miner_fork() {
	local MINER_FORK=$NHEQMINER_FORK
	[[ -z $MINER_FORK ]] && MINER_FORK=$MINER_DEFAULT_FORK
	echo $MINER_FORK
}

function miner_ver() {
	local MINER_VER=$NHEQMINER_VER
	local MINER_FORK=`miner_fork`
	local fork=${MINER_FORK^^} #uppercase MINER_FORK
	[[ -z $MINER_VER ]] && eval "MINER_VER=\$MINER_LATEST_VER_${fork//-/_}" #char replace
	echo $MINER_VER
}

function miner_config_echo() {
	local MINER_FORK=`miner_fork`
	local MINER_VER=`miner_ver`
	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_FORK/$MINER_VER/config.json"
}

function miner_config_gen() {

	local MINER_CONFIG="$MINER_DIR/$MINER_FORK/$MINER_VER/$MINER_NAME.conf"
	mkfile_from_symlink $MINER_CONFIG

	[[ -z $NHEQMINER_TEMPLATE ]] && echo -e "${YELLOW}BEAMCL_TEMPLATE is empty${NOCOLOR}" && return 1
	[[ -z $NHEQMINER_URL ]] && echo -e "${YELLOW}BEAMCL_URL is empty${NOCOLOR}" && return 1

	local pool=`head -n 1 <<< "$NHEQMINER_URL"`
	[[ ! -z $NHEQMINER_PASS ]] && local pass=" -p $NHEQMINER_PASS"

	conf="-v -l ${pool} -u ${NHEQMINER_TEMPLATE}${pass} -a ${MINER_API_PORT} ${NHEQMINER_USER_CONFIG}"

	echo "$conf" > $MINER_CONFIG
}
