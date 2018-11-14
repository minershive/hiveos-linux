#!/usr/bin/env bash

function miner_ver() {
	echo $MINER_LATEST_VER
}


function miner_config_echo() {
	local MINER_VER=`miner_ver`
	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/$MINER_NAME.conf"
}

function miner_config_gen() {

	local MINER_CONFIG="$MINER_DIR/$MINER_VER/$MINER_NAME.conf"
	mkfile_from_symlink $MINER_CONFIG

	local algo=${CRYPTODREDGE_ALGO}
	case ${algo} in
		"cryptonight-lite-v7" )
			algo="aeon"
		;;
		"cryptonight-fast" )
			algo="cnfast"
		;;
		"cryptonight-heavy" )
			algo="cnheavy"
		;;
		"cryptonight-v7" )
			algo="cnv7"
		;;
		"cryptonight-xhv" )
			algo="cnhaven"
		;;
		"cryptonight-saber" )
			algo="cnsaber"
		;;
		"cryptonight-v8" )
			algo="cnv8"
		;;
		"cryptonight" )
			algo="cnv8"
		;;
		"cryptonight-xtl" )
			algo="stellite"
		;;
	esac
	[[ ! -z ${algo} ]] && algo="-a ${algo}"

	local pool=`head -n 1 <<< "$CRYPTODREDGE_URL"`

	conf="${algo} -o $pool -u ${CRYPTODREDGE_TEMPLATE} -p ${CRYPTODREDGE_PASS} ${CRYPTODREDGE_USER_CONFIG}"

	echo "$conf" > $MINER_CONFIG
}
