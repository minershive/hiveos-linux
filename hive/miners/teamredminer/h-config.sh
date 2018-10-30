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
  conf="-a ${TEAMREDMINER_ALGO} -o $pool -u ${TEAMREDMINER_TEMPLATE} -p ${TEAMREDMINER_PASS} ${TEAMREDMINER_USER_CONFIG}"

  #replace tpl values in whole file
  #Don't remove until Hive 1 is gone
	[[ ! -z $EWAL ]] && conf=$(sed "s/%EWAL%/$EWAL/g" <<< $conf) #|| echo "${RED}EWAL not set${NOCOLOR}"
	[[ ! -z $DWAL ]] && conf=$(sed "s/%DWAL%/$DWAL/g" <<< $conf) #|| echo "${RED}DWAL not set${NOCOLOR}"
	[[ ! -z $ZWAL ]] && conf=$(sed "s/%ZWAL%/$ZWAL/g" <<< $conf) #|| echo "${RED}ZWAL not set${NOCOLOR}"
	[[ ! -z $EMAIL ]] && conf=$(sed "s/%EMAIL%/$EMAIL/g" <<< $conf)
  [[ ! -z $WORKER_NAME ]] && conf=$(sed "s/%WORKER_NAME%/$WORKER_NAME/g" <<< $conf) #|| echo "${RED}WORKER_NAME not set${NOCOLOR}"

  echo "$conf" > $MINER_CONFIG
}
