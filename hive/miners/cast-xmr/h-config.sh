#!/usr/bin/env bash


function miner_ver() {
	local MINER_VER=$CAST_XMR_VER
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
	  "cryptonight-fast-v8" )
			algo=" --algo=6"
		;;
		"cryptonight-xhv" )
			algo=" --algo=7"
		;;
		"cryptonight-fast" )
			algo=" --algo=8"
		;;
		"сryptonight-trtl" )
			algo=" --algo=9"
		;;
		"cryptonight-v8" )
			algo=" --algo=10"
		;;
		"сryptonight-superfast" )
			algo=" --algo=11"
		;;
		"" )
			algo=" --algo=-1"
		;;
		* )
			algo=" --algo=${CAST_XMR_ALGO}"
		;;
		#--algo=3 for CryptoNight-Lite
	esac

	[[ -z $CAST_XMR_TEMPLATE ]] && echo -e "${YELLOW}CAST_XMR_TEMPLATE is empty${NOCOLOR}" && return 1
	[[ -z $CAST_XMR_URL ]] && echo -e "${YELLOW}CAST_XMR_URL is empty${NOCOLOR}" && return 1
	local pool=`head -n 1 <<< "$CAST_XMR_URL"`

	conf="-S ${pool} -u ${CAST_XMR_TEMPLATE} -p ${CAST_XMR_PASS}${algo} ${CAST_XMR_USER_CONFIG}"

	echo "$conf" > $MINER_CONFIG
}
