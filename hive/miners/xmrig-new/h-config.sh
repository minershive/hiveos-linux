#!/usr/bin/env bash

function miner_fork() {
	local MINER_FORK=$XMRIG_NEW_FORK
	[[ -z $MINER_FORK ]] && MINER_FORK=$MINER_DEFAULT_FORK
	echo $MINER_FORK
}


function miner_ver() {
	local MINER_VER=$XMRIG_NEW_VER
	local MINER_FORK=`miner_fork`
	local fork=${MINER_FORK^^} #uppercase MINER_FORK
	[[ -z $MINER_VER ]] && eval "MINER_VER=\$MINER_LATEST_VER_${fork//-/_}" #char replace
	echo $MINER_VER
}


function miner_config_echo() {
	local MINER_FORK=`miner_fork`
	local MINER_VER=`miner_ver`
	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_FORK/$MINER_VER/config.json"
}

function miner_config_gen() {
	local MINER_CONFIG="$MINER_DIR/$MINER_FORK/$MINER_VER/config.json"
	mkfile_from_symlink $MINER_CONFIG

	conf=`cat $MINER_DIR/$MINER_FORK/$MINER_VER/config_global.json | envsubst`
	userconf='{}'
	local ver=`miner_ver`
	#local fork=`miner_fork`
	#merge user config options into main config
	if [[ ! -z $XMRIG_NEW_USER_CONFIG ]]; then
		while read -r line; do
			[[ -z $line ]] && continue
			conf=$(jq -s '.[0] * .[1]' <<< "$conf {$line}")
		done <<< "$XMRIG_NEW_USER_CONFIG"
	fi

	if [[ $XMRIG_NEW_CPU -eq 1 ]]; then
		#merge CPU settings into main config
		if [[ -z $XMRIG_NEW_CPU_CONFIG || $XMRIG_NEW_CPU_CONFIG == '[]' || $XMRIG_NEW_CPU_CONFIG == 'null' ]]; then
			echo -e "${YELLOW}XMRIG_NEW_CPU_CONFIG is empty, useing autoconfig${NOCOLOR}"
		else
			local cpu="{$XMRIG_NEW_CPU_CONFIG}"
			cpu=`jq --null-input --argjson cpu "$cpu" '$cpu'`
			conf=$(jq -s '.[0] * .[1]' <<< "$conf $cpu")
		fi
	else
		echo -e "${YELLOW}CPU is disabled${NOCOLOR}"
		local cpu='{"cpu": {"enabled": false}}'
		cpu=`jq --null-input --argjson cpu "$cpu" '$cpu'`
		conf=$(jq -s '.[0] * .[1]' <<< "$conf $cpu")
	fi

	if [[ $XMRIG_NEW_OPENCL -eq 1 ]]; then
		#merge GPU settings into main config
		if [[ -z $XMRIG_NEW_OPENCL_CONFIG || $XMRIG_NEW_OPENCL_CONFIG == '[]' || $XMRIG_NEW_OPENCL_CONFIG == 'null' ]]; then
			echo -e "${YELLOW}XMRIG_NEW_OPENCL_CONFIG is empty, useing autoconfig${NOCOLOR}"
		else
			local opencl="{$XMRIG_NEW_OPENCL_CONFIG}"
			opencl=`jq --null-input --argjson opencl "$opencl" '$opencl'`
			conf=$(jq -s '.[0] * .[1]' <<< "$conf $opencl")
		fi
	else
		echo -e "${YELLOW}OPENCL is disabled${NOCOLOR}"
		local opencl='{"opencl": {"enabled": false}}'
		opencl=`jq --null-input --argjson opencl "$opencl" '$opencl'`
		conf=$(jq -s '.[0] * .[1]' <<< "$conf $opencl")
	fi

	#merge pools into main config
	pools='[]'
	[[ $XMRIG_NEW_TLS -eq 1 ]] && local tls="true" || tls="false"
	tls_fp=$(jq -r '."tls-fingerprint"' <<< "$conf")
	[[ -z $tls_fp ]] && tls_fp="null"
	nicehash=$(jq -r .nicehash <<< "$conf")
	[[ -z $nicehash || $nicehash == "null" ]] && nicehash="false"

	[[ -z $XMRIG_NEW_ALGO ]] && XMRIG_NEW_ALGO="cn/r"

	# local coin=`echo $META | jq -r .${MINER_NAME}.coin`
	# [[ -z $coin ]] && coin="null"

	for url in $XMRIG_NEW_URL; do
		[[ ${nicehash,,} = "true" || ${url,,} = *"nicehash"* ]] && c_nicehash='true' || c_nicehash='false'
		pool=$(cat <<EOF
				{"algo": "$XMRIG_NEW_ALGO", "coin": null, "url": "$url", "user": "$XMRIG_NEW_TEMPLATE", "pass": "$XMRIG_NEW_PASS", "rig_id": "$XMRIG_NEW_WORKER", "nicehash": $c_nicehash, "keepalive": true, "enabled": true, "tls": $tls, "tls-fingerprint": $tls_fp, "daemon": false }
EOF
)
		pools=`jq --null-input --argjson pools "$pools" --argjson pool "$pool" '$pools + [$pool]'`
	done


	if [[ -z $pools || $pools == '[]' || $pools == 'null' ]]; then
		echo -e "${RED}No pools configured, using default${NOCOLOR}"
	else
		pools=`jq --null-input --argjson pools "$pools" '{"pools": $pools}'`
		conf=$(jq -s '.[0] * .[1]' <<< "$conf $pools")
	fi


	echo "$conf" | jq . > $MINER_CONFIG
}
