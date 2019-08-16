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
	conf="--coin $coin\n"
	local host_cnt=$(echo $LOLMINER_SERVER | wc -w)
	if [[ $host_cnt -gt 1 ]]; then
		# URL
		local url=$(echo $LOLMINER_SERVER | tr ' ' ';' )
		[[ ! -z $LOLMINER_SERVER ]]   && conf+="--pool $url\n"
		# PORT
		conf+="--port "
		for ((i=0; i<$host_cnt; i++)); do
			conf+="$LOLMINER_PORT"
			[[ $i -eq $((host_cnt-1)) ]] && conf+="\n" || conf+=";"
		done
		# WALLET
		conf+="--user "
		for ((i=0; i<$host_cnt; i++)); do
			conf+="$LOLMINER_TEMPLATE"
			[[ $i -eq $((host_cnt-1)) ]] && conf+="\n" || conf+=";"
		done
		# PASSWORD
		if [[ ! -z $LOLMINER_PASS ]]; then
			conf+="--pass "
			for ((i=0; i<$host_cnt; i++)); do
				conf+="$LOLMINER_PASS"
				[[ $i -eq $((host_cnt-1)) ]] && conf+="\n" || conf+=";"
			done
		fi
		# TLS and other options
		while read -r line; do 
			[[ -z $line ]] && continue
			local tls_cnt=$(echo "$line" | grep -e "--tls" | awk '{print $2}' | tr ';' ' ' | wc -w)
			if [[ $tls_cnt -eq 1 ]]; then
				local tls_val=$(echo "$line" | grep -e "--tls" | awk '{print $2}')
				conf+="--tls "
				for ((i=0; i<$host_cnt; i++)); do
					conf+="$tls_val"
					[[ $i -eq $((host_cnt-1)) ]] && conf+="\n" || conf+=";"
				done
			else
				conf+="$line\n"
			fi
		done <<< "$LOLMINER_USER_CONFIG"
	else
		[[ ! -z $LOLMINER_SERVER ]]   && conf+="--pool $LOLMINER_SERVER\n"
		[[ ! -z $LOLMINER_PORT ]]     && conf+="--port $LOLMINER_PORT\n"
		[[ ! -z $LOLMINER_TEMPLATE ]] && conf+="--user $LOLMINER_TEMPLATE\n"
		[[ ! -z $LOLMINER_PASS ]]     && conf+="--pass $LOLMINER_PASS\n"
		if [[ ! -z $LOLMINER_USER_CONFIG ]]; then
			conf+="$LOLMINER_USER_CONFIG\n"
		fi
	fi
	conf+="--apiport $MINER_API_PORT\n"
	conf+=`cat $GLOBAL_CONFIG`"\n"
	
	echo -e "$conf" > $MINER_CONFIG
}
