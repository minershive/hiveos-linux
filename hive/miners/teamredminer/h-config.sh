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

	[[ -z $TEAMREDMINER_ALGO ]] && TEAMREDMINER_ALGO=lyra2z
	local pool=`head -n 1 <<< "$TEAMREDMINER_URL"`
	grep -q "://" <<< $pool
	[[ $? -ne 0 ]] && pool="stratum+tcp://${pool}"

	conf="-a ${TEAMREDMINER_ALGO} -o $pool -u ${TEAMREDMINER_TEMPLATE} -p ${TEAMREDMINER_PASS} ${TEAMREDMINER_USER_CONFIG}"

	#replace tpl values in whole file
	[[ ! -z $WORKER_NAME ]] && conf=$(sed "s/%WORKER_NAME%/$WORKER_NAME/g" <<< $conf) #|| echo "${RED}WORKER_NAME not set${NOCOLOR}"

	echo "$conf" > $MINER_CONFIG
}
