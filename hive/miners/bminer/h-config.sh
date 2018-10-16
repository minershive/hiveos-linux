#!/usr/bin/env bash

function miner_ver() {
	echo $MINER_LATEST_VER
}

function miner_config_echo() {
	local MINER_VER=`miner_ver`
	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/bminer.conf"
}

function translate_algo() {
	case $1 in
		"ethash" )
			echo "ethash://"
		;;
		"equihash 144/5" )
			echo "zhash://"
		;;
		"blake2s" )
			echo "blake2s://"
		;;
		"blake14r")
			echo "blake14r://"
		;;
		"tensority" )
			echo "tensority://"
		;;
		* )
			echo "stratum://"
		;;
	esac
}

function miner_config_gen() {
	local MINER_CONFIG="$MINER_DIR/$MINER_VER/bminer.conf"
	mkfile_from_symlink $MINER_CONFIG

	conf="-api ${MINER_API_HOST}:${MINER_API_PORT} -max-temperature 82"

	local pool=`head -n 1 <<< "$BMINER_URL"`
	pool=$(sed 's/\//%2F/g; s/ /%20/g' <<< $pool)
	[[ `echo $pool | sed 's/@/@\n/g'|grep -c @` -gt 1 ]] && pool=$(sed 's/@/%40/1' <<< $pool)

	grep -q "://" <<< $pool
	[[ $? -ne 0 ]] && uri=`translate_algo $BMINER_ALGO`${pool}
	conf+=" -uri $uri"

	if [[ ! -z $BMINER_URL2 ]]; then
		local pool=`head -n 1 <<< "$BMINER_URL2"`
		pool=$(sed 's/\//%2F/g; s/ /%20/g' <<< $pool)
		[[ `echo $pool | sed 's/@/@\n/g'|grep -c @` -gt 1 ]] && pool=$(sed 's/@/%40/1' <<< $pool)
		grep -q "://" <<< $pool
		if [[ $? -ne 0 ]]; then #protocol not found
			uri=`translate_algo $BMINER_ALGO2`${pool}
		else
			uri=$(sed "s/:\/\//:\/\/$tpl@/g; s/@/%40/1" <<< $pool) #replace :// with username
		fi
		conf+=" -uri2 $uri"
		[[ ! -z $BMINER_INTENSITY ]] && conf+=" -dual-intensity $BMINER_INTENSITY"
	fi

	[[ ! -z $BMINER_USER_CONFIG ]] && conf+=" $BMINER_USER_CONFIG"

	#pass can also contain %var%
	#Don't remove until Hive 1 is gone
	[[ ! -z $EWAL ]] && conf=$(sed "s/%EWAL%/$EWAL/g" <<< $conf) #|| echo "${RED}EWAL not set${NOCOLOR}"
	[[ ! -z $DWAL ]] && conf=$(sed "s/%DWAL%/$DWAL/g" <<< $conf) #|| echo "${RED}DWAL not set${NOCOLOR}"
	[[ ! -z $ZWAL ]] && conf=$(sed "s/%ZWAL%/$ZWAL/g" <<< $conf) #|| echo "${RED}ZWAL not set${NOCOLOR}"
	[[ ! -z $EMAIL ]] && conf=$(sed "s/%EMAIL%/$EMAIL/g" <<< $conf)
	[[ ! -z $WORKER_NAME ]] && conf=$(sed "s/%WORKER_NAME%/$WORKER_NAME/g" <<< $conf) #|| echo "${RED}WORKER_NAME not set${NOCOLOR}"

	echo "$conf" > $MINER_CONFIG
}
