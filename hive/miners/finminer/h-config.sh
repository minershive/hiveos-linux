#!/usr/bin/env bash

function miner_ver() {
	local MINER_VER=$FINMINER_VER
	[[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
	echo $MINER_VER
}


function miner_config_echo() {
	local MINER_VER=`miner_ver`
	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/config.ini"
}

function miner_config_gen() {
	local MINER_CONFIG="$MINER_DIR/$MINER_VER/config.ini"
	mkfile_from_symlink $MINER_CONFIG

	echo "wallet = ${FINMINER_TEMPLATE}" > $MINER_CONFIG

	[[ ! -z ${FINMINER_ALGO} ]] && echo "algorithm = ${FINMINER_ALGO}" >> $MINER_CONFIG

	[[ ! -z ${FINMINER_PASS} ]] && echo "rigPassword = ${FINMINER_PASS}" >> $MINER_CONFIG

	i=1
	if [[ ! -z $FINMINER_URL ]]; then
		if [[ $FINMINER_URL = *"pool"* ]]; then
			echo $FINMINER_URL >> $MINER_CONFIG
		else
			for url in $FINMINER_URL; do
				echo "pool$i = $url" >> $MINER_CONFIG
				let "i = i + 1"
			done
		fi
	fi

	echo "mport = -$MINER_API_PORT" >> $MINER_CONFIG

	echo "logPath = $MINER_LOG_BASENAME.log"

	#merge user config options into main config
	if [[ ! -z $FINMINER_USER_CONFIG ]]; then
		while read -r line; do
			[[ -z $line ]] && continue
			echo $line >> $MINER_CONFIG
		done <<< "$FINMINER_USER_CONFIG"
	fi

}
