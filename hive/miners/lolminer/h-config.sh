#!/usr/bin/env bash

function miner_ver() {
	local MINER_VER=$LOLMINER_VER
	[[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
	echo $MINER_VER
}

function miner_config_echo() {
	local MINER_VER=`miner_ver`
	miner_echo_config_file "$MINER_DIR/$MINER_VER/lolminer.conf"
}

function miner_config_gen() {
	MINER_CONFIG="$MINER_DIR/$MINER_VER/lolminer.conf"
	GLOBAL_CONFIG="$MINER_DIR/$MINER_VER/global_config.conf"
	mkfile_from_symlink $MINER_CONFIG

	if [ -z $LOLMINER_ALGO ]; then
	    coin="AUTO144_5"
	else
	    coin=$LOLMINER_ALGO
	fi
	#
	if [[ "$LOLMINER_ALGO" =~ "BEAM-" || $LOLMINER_ALGO =~ "EQUI" || $LOLMINER_ALGO =~ "C29" || $LOLMINER_ALGO =~ "CR29" || $LOLMINER_ALGO == "C31" || $LOLMINER_ALGO == "C32" || $LOLMINER_ALGO == "ETHASH" || $LOLMINER_ALGO == "ETCHASH" ]]; then
	   conf="--algo $coin\n"
	else
	   conf="--coin $coin\n"
	fi
	local host_cnt=$(echo $LOLMINER_SERVER | wc -w)
	LOLMINER_SERVER=($LOLMINER_SERVER)
	LOLMINER_PORT=($LOLMINER_PORT)
	for ((i=0; i<$host_cnt; i++)); do
		#URL
		local url="${LOLMINER_SERVER[$i]}:${LOLMINER_PORT[$i]}"
		echo ${LOLMINER_PORT[$i]}
		conf+="--pool $url\n"
		# WALLET
		conf+="--user $LOLMINER_TEMPLATE\n"
		# PASSWORD
		if [[ ! -z $LOLMINER_PASS ]]; then
			conf+="--pass $LOLMINER_PASS\n"
		fi
	done

	[[ ! -z $LOLMINER_WORKER ]] && conf+="--worker $LOLMINER_WORKER\n"

	# TLS and other options
	while read -r line; do
		[[ -z $line ]] && continue
		local tls_cnt=$(echo "$line" | grep -e "--tls" | awk '{print $2}' | tr ';' ' ' | wc -w)
		if [[ $tls_cnt -eq 1 ]]; then
			local tls_val=$(echo "$line" | grep -e "--tls" | awk '{print $2}')
			for ((i=0; i<$host_cnt; i++)); do
				conf+="--tls $tls_val\n"
			done
		else
			conf+="$line\n"
		fi
	done <<< "$LOLMINER_USER_CONFIG"

	conf+="--apiport $MINER_API_PORT\n"
	conf+=`cat $GLOBAL_CONFIG`"\n"

	echo -e "$conf" > $MINER_CONFIG
}
