#!/usr/bin/env bash

function miner_ver() {
	local MINER_VER=$BMINER_VER
	if [[ -z $MINER_VER ]]; then 
		MINER_VER=$MINER_LATEST_VER
		[[ ! -z $MINER_LATEST_VER_UBU16 && $(lsb_release  -c) =~ xenial ]] &&
			MINER_VER=$MINER_LATEST_VER_UBU16
	fi
	echo $MINER_VER
}

function miner_config_echo() {
	local MINER_VER=`miner_ver`
	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/bminer.conf"
}

function miner_config_gen() {
	local MINER_CONFIG="$MINER_DIR/$MINER_VER/bminer.conf"
	mkfile_from_symlink $MINER_CONFIG

	[[ ! -z $BMINER_ALGO ]] && algo=$BMINER_ALGO || algo="stratum"
	[[ $BMINER_TLS -eq 1 && ! $algo =~ "ssl" ]] && algo+="+ssl"
	conf=
	pool=

	for url in $BMINER_URL; do
		tpl=$BMINER_TEMPLATE
		tpl=$(sed 's/\//%2F/g; s/ /%20/g; s/@/%40/g' <<< $tpl)
		[[ ! -z $BMINER_PASS ]] && tpl+=":$BMINER_PASS"

		grep -q "://" <<< $url
		if [[ $? -ne 0 ]]; then
			url_t="${algo}://${tpl}@${url}"
		else
			url_t=$(sed "s/:\/\//:\/\/$tpl@/g" <<< $url) #replace :// with username
		fi

		[[ ! -z $pool ]] && pool+=","
		pool+=$url_t

	done

	conf+=" -uri $pool"

	if [[ ! -z $BMINER_URL2 ]]; then
		[[ ! -z $BMINER_ALGO2 ]] && algo2=$BMINER_ALGO2 || algo2="blake2s"
		[[ $BMINER_TLS2 -eq 1 && ! $algo2 =~ "ssl" ]] && algo2+="+ssl"
		pool=
		for url in $BMINER_URL2; do
		  tpl=$BMINER_TEMPLATE2
		  tpl=$(sed 's/\//%2F/g; s/ /%20/g; s/@/%40/g' <<< $tpl)
		  [[ ! -z $BMINER_PASS2 ]] && tpl+=":$BMINER_PASS2"

			grep -q "://" <<< $url
			if [[ $? -ne 0 ]]; then #protocol not found
				url_t="${algo2}://${tpl}@${url}"
			else
				url_t=$(sed "s/:\/\//:\/\/$tpl@/g" <<< $url) #replace :// with username
			fi

			[[ ! -z $pool ]] && pool+=","
			pool+=$url_t

		done

		conf+=" -uri2 $pool"

		[[ ! -z $BMINER_INTENSITY ]] && conf+=" -dual-intensity $BMINER_INTENSITY"

	fi

	[[ ! -z $BMINER_USER_CONFIG ]] && conf+=" $BMINER_USER_CONFIG"

	conf+=" -api 127.0.0.1:${MINER_API_PORT}"
	#-max-temperature ${CRITICAL_TEMP}"

	echo "$conf" > $MINER_CONFIG
}
