#!/usr/bin/env bash

# Not required
function miner_fork() {
	local MINER_FORK=$SGMINER_FORK
	[[ -z $MINER_FORK ]] && MINER_FORK=$MINER_DEFAULT_FORK

	echo $MINER_FORK
}


function miner_ver() {
	local MINER_VER=$SGMINER_VER
	[[ -z $MINER_VER ]] && eval "MINER_VER=\$MINER_LATEST_VER_${MINER_FORK^^}" #uppercase MINER_FORK
	echo $MINER_VER
}


function miner_config_echo() {
	export MINER_FORK=`miner_fork`
	local MINER_VER=`miner_ver`
	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_FORK/$MINER_VER/sgminer.conf"
}


function miner_config_gen() {
	local MINER_CONFIG="$MINER_DIR/$MINER_FORK/$MINER_VER/sgminer.conf"
	mkfile_from_symlink $MINER_CONFIG

	pools='[]'
	for url in $SGMINER_URL; do
		pool='{}'
		pool=`jq --null-input --argjson pool "$pool" --arg user "$SGMINER_TEMPLATE" '$pool + {$user}'`
		pool=`jq --null-input --argjson pool "$pool" --arg url "$url" '$pool + {$url}'`
		[[ ! -z $SGMINER_PASS ]] &&
			pool=`jq --null-input --argjson pool "$pool" --arg pass "$SGMINER_PASS" '$pool + {$pass}'`
		pools=`jq --null-input --argjson pools "$pools" --argjson pool "$pool" '$pools + [$pool]'`
	done

	pools=`jq --null-input --argjson pools "$pools" '{$pools}'`

	if [[ ! -z $SGMINER_USER_CONFIG ]]; then
		while read -r line; do
			[[ -z $line ]] && continue
			#echo "$line," >> $userconf
			pools=`jq --null-input --argjson pools "$pools" --argjson line "{$line}" '$pools + $line'`
		done <<< "$SGMINER_USER_CONFIG"
	fi

	[[ ! -z $SGMINER_ALGO ]] &&
		pools=`jq --null-input --argjson pools "$pools" --arg algorithm "$SGMINER_ALGO" '$pools + {$algorithm}'`

	config_global=`cat $MINER_DIR/$MINER_FORK/$MINER_VER/config_global.json`

	conf=`jq -n --argjson g "$config_global" --argjson p "$pools" '$g * $p'`

	echo "$conf" | jq . > $MINER_CONFIG
}
