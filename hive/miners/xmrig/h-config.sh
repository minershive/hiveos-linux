#!/usr/bin/env bash


function miner_ver() {
	echo $MINER_LATEST_VER
}


function miner_config_echo() {
	local MINER_VER=`miner_ver`
	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/config.json"
}


function miner_config_gen() {
	local MINER_CONFIG="$MINER_DIR/$MINER_VER/config.json"
	mkfile_from_symlink $MINER_CONFIG

	conf=`cat $MINER_DIR/$MINER_VER/config_global.json | envsubst`
	userconf='{}'
	#merge user config options into main config
	if [[ ! -z $XMRIG_USER_CONFIG ]]; then
		while read -r line; do
			[[ -z $line ]] && continue
			conf=$(jq -s '.[0] * .[1]' <<< "$conf {$line}")
		done <<< "$XMRIG_USER_CONFIG"
	fi

	#merge CPU settings into main config
	if [[ -z $XMRIG_THREADS || $XMRIG_THREADS == '[]' || $XMRIG_THREADS == 'null' ]]; then
		echo -e "${YELLOW}CUSTOM_CPU_CONFIG is empty, useing autoconfig${NOCOLOR}"
	else
		threads="{$XMRIG_THREADS}"
		threads=`jq --null-input --argjson threads "$threads" '$threads'`
		conf=$(jq -s '.[0] * .[1]' <<< "$conf $threads")
	fi

	#merge pools into main config
	pools='[]'
	tls=$(jq -r .tls <<< "$conf")
	[[ -z $tls || $tls == "null" ]] && tls="false"
	tls_fp=$(jq -r '."tls-fingerprint"' <<< "$conf")
	[[ -z $tls_fp || $tls_fp == "null" ]] && tls_fp="null"
	variant=$(jq -r '."variant"' <<< "$conf")
	[[ -z $variant= || $variant= == "null" ]] && variant=-1
	rig_id=$(jq -r '."rig_id"' <<< "$conf")
	[[ -z $rig_id= || $rig_id= == "null" ]] && rig_id=""
	nicehash=$(jq -r .nicehash <<< "$conf")
	[[ -z $nicehash || $nicehash == "null" ]] && nicehash="false"

	for url in $XMRIG_URL; do
		[[ ${nicehash,,} = "true" || ${url,,} = *"nicehash"* ]] && c_nicehash='true' || c_nicehash='false'

		pool=$(cat <<EOF
					{"url": "$url", "user": "$XMRIG_TEMPLATE", "pass": "$XMRIG_PASS", "rig_id": "$rig_id", "use_nicehash": $c_nicehash, "tls": $tls, "tls-fingerprint": $tls_fp, "variant": $variant, "keepalive": true }
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
