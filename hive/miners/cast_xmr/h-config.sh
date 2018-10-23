#!/usr/bin/env bash


function miner_ver() {
	echo $MINER_LATEST_VER
}


function miner_config_echo() {
	local MINER_VER=`miner_ver`
	miner_echo_config_file "$MINER_DIR/$MINER_VER/$MINER_NAME.conf"
}


function miner_config_gen() {
	local MINER_CONFIG="$MINER_DIR/$MINER_VER/$MINER_NAME.conf"
	mkfile_from_symlink $MINER_CONFIG

	case ${CAST_XMR_ALGO} in
		"cryptonight" )
			algo=" --algo=0"
		;;
		"cryptonight-v7" )
			algo=" --algo=1"
		;;
		"cryptonight-heavy" )
			algo=" --algo=2"
		;;
		"cryptonight-lite-v7" )
			algo=" --algo=4"
		;;
		"cryptonight-saber" )
			algo=" --algo=5"
		;;
    "cryptonight-xtl" )
			algo=" --algo=6"
		;;
		"cryptonight-xhv" )
			algo=" --algo=7"
		;;
		"cryptonight-fast" )
			algo=" --algo=8"
		;;
		"cryptonight-v8" )
			algo=" --algo=10"
		;;
		"" )
			algo=" --algo=-1"
		;;
		* )
			algo=" --algo=${CAST_XMR_ALGO}"
		;;
		#--algo=3 for CryptoNight-Lite
		#--algo=9 for CryptoNightFEST
esac

[[ -z $CAST_XMR_TEMPLATE ]] && echo -e "${YELLOW}CAST_XMR_TEMPLATE is empty${NOCOLOR}" && return 1
[[ -z $CAST_XMR_URL ]] && echo -e "${YELLOW}CAST_XMR_URL is empty${NOCOLOR}" && return 1
local pool=`head -n 1 <<< "$CAST_XMR_URL"`

conf="-S ${pool} -u ${CAST_XMR_TEMPLATE} -p ${CAST_XMR_PASS}${algo} ${CAST_XMR_USER_CONFIG}"

#replace tpl values in whole file
#Don't remove until Hive 1 is gone
[[ ! -z $EWAL ]] && conf=$(sed "s/%EWAL%/$EWAL/g" <<< "$conf") #|| echo "${RED}EWAL not set${NOCOLOR}"
[[ ! -z $DWAL ]] && conf=$(sed "s/%DWAL%/$DWAL/g" <<< "$conf") #|| echo "${RED}DWAL not set${NOCOLOR}"
[[ ! -z $ZWAL ]] && conf=$(sed "s/%ZWAL%/$ZWAL/g" <<< "$conf") #|| echo "${RED}ZWAL not set${NOCOLOR}"
[[ ! -z $EMAIL ]] && conf=$(sed "s/%EMAIL%/$EMAIL/g" <<< "$conf")
[[ ! -z $WORKER_NAME ]] && conf=$(sed "s/%WORKER_NAME%/$WORKER_NAME/g" <<< "$conf") #|| echo "${RED}WORKER_NAME not set${NOCOLOR}"

echo "$conf" > $MINER_CONFIG
}
