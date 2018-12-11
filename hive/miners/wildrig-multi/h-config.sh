#!/usr/bin/env bash

function miner_ver() {
	local MINER_VER=$WILDRIG_MULTI_VER
	[[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
	echo $MINER_VER
}

function miner_config_echo() {
        local MINER_VER=`miner_ver`
        miner_echo_config_file "$MINER_DIR/$MINER_VER/$MINER_NAME.conf"
}

function miner_config_gen() {
	local MINER_CONFIG="$MINER_DIR/$MINER_VER/$MINER_NAME.conf"
	mkfile_from_symlink $MINER_CONFIG

	[[ -z $WILDRIG_MULTI_TEMPLATE ]] && echo -e "${YELLOW}WILDRIG_MULTI_TEMPLATE is empty${NOCOLOR}" && return 1
	[[ -z $WILDRIG_MULTI_URL ]] && echo -e "${YELLOW}WILDRIG_MULTI_URL is empty${NOCOLOR}" && return 2
	[[ -z $WILDRIG_MULTI_PASS ]] && WILDRIG_MULTI_PASS=x

	# Add wallet template and password
	conf="--user ${WILDRIG_MULTI_TEMPLATE} --pass ${WILDRIG_MULTI_PASS}\n"

	# Add algorithm
	if [ ! -z $WILDRIG_MULTI_ALGO ]; then 
		case $WILDRIG_MULTI_ALGO in
			skunk) wild_algo=skunkhash
			;;
			*)
			wild_algo=$WILDRIG_MULTI_ALGO
		esac
		conf+="--algo=${wild_algo}\n"
	fi

	# Add pool or pools
	pools=""
	for pool_url in $WILDRIG_MULTI_URL; do
		pools+="--url $pool_url "
	done
	conf+="$pools\n"

	# Add general options
	conf+="--api-port ${MINER_API_PORT} --print-full --print-time=60 --print-level=2 --donate-level=1\n"

	# Add user config options
	[[ ! -z $WILDRIG_MULTI_USER_CONFIG ]] && conf+="${WILDRIG_MULTI_USER_CONFIG}"

	echo -e "$conf" > $MINER_CONFIG
}
