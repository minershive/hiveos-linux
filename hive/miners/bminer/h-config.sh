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

	conf=

	pool=
	#local pool=`head -n 1 <<< "$BMINER_URL"`
	for url in $BMINER_URL; do
		grep -q "://" <<< $url
		if [[ $? -ne 0 ]]; then
			url_t=$(sed 's/\//%2F/g; s/ /%20/g' <<< $url)
			[[ `echo $url_t | sed 's/@/@\n/g'|grep -c @` -gt 1 ]] && url_t=$(sed 's/@/%40/1' <<< $url_t)
			#pool=`translate_algo $BMINER_ALGO`${pool}
			url_t="${BMINER_ALGO}://${url_t}"
		else
			url_t=$(sed 's/\//%2F/3g; s/ /%20/g' <<< $url)
			[[ `echo $url_t | sed 's/@/@\n/g' | grep -c @` -gt 1 ]] && url_t=$(sed 's/@/%40/1' <<< $url_t)
			#uri=$(sed "s/:\/\//:\/\/$tpl@/g; s/@/%40/1" <<< $pool)
		fi

		[[ ! -z $pool ]] && pool+=","
		pool+=$url_t

	done

	conf+=" -uri $pool"

	if [[ ! -z $BMINER_URL2 ]]; then
		pool=
		#local pool=`head -n 1 <<< "$BMINER_URL2"`
		for url in $BMINER_URL2; do

			grep -q "://" <<< $url
			if [[ $? -ne 0 ]]; then #protocol not found
				url_t=$(sed 's/\//%2F/g; s/ /%20/g' <<< $url)
				[[ `echo $url_t | sed 's/@/@\n/g'|grep -c @` -gt 1 ]] && url_t=$(sed 's/@/%40/1' <<< $url_t)
				#pool=`translate_algo $BMINER_ALGO2`${pool}
				url_t="${BMINER_ALGO2}://${url_t}"
			else
				url_t=$(sed 's/\//%2F/3g; s/ /%20/g' <<< $url)
				[[ `echo $url_t | sed 's/@/@\n/g'|grep -c @` -gt 1 ]] && url_t=$(sed 's/@/%40/1' <<< $url_t)
				#uri=$(sed "s/:\/\//:\/\/$tpl@/g; s/@/%40/1" <<< $pool) #replace :// with username
			fi

			[[ ! -z $pool ]] && pool+=","
			pool+=$url_t

		done

		conf+=" -uri2 $pool"

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

	conf+=" -api 127.0.0.1:${MINER_API_PORT}"
	#-max-temperature ${CRITICAL_TEMP}"

	echo "$conf" > $MINER_CONFIG
}
