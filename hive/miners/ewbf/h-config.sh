#!/usr/bin/env bash

# Not required
function miner_fork() {
	local MINER_FORK=$EWBF_FORK
	[[ -z $MINER_FORK ]] && MINER_FORK=$MINER_DEFAULT_FORK

	#can be removed later, backward compat
	if [[ $MINER_FORK == "zhash_0.4" ]]; then
		MINER_FORK="zhash"
	fi

	echo $MINER_FORK
}


function miner_ver() {
	[[ -z $MINER_FORK ]] && MINER_FORK=`miner_fork`
	local MINER_VER=$EWBF_VER
	[[ -z $MINER_VER ]] && eval "MINER_VER=\$MINER_LATEST_VER_${MINER_FORK^^}" #uppercase MINER_FORK
	echo $MINER_VER
}


function miner_config_echo() {
	export MINER_FORK=`miner_fork`
	local MINER_VER=`miner_ver`
	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_FORK/$MINER_VER/miner.cfg"
}


function miner_config_gen() {
	local MINER_CONFIG="$MINER_DIR/$MINER_FORK/$MINER_VER/miner.cfg"
	mkfile_from_symlink $MINER_CONFIG

	conf=`cat $MINER_DIR/miner.global.cfg | envsubst`

	if [[ $MINER_FORK == "zhash" ]]; then
		[[ -z $EWBF_ALGO ]] && EWBF_ALGO="192_7"
		[[ $EWBF_ALGO == "210_9" ]] && EWBF_ALGO="aion"
		conf+="\nalgo\t$EWBF_ALGO\n"
	fi


	[[ ! -z $EWBF_USER_CONFIG ]] && conf+="\n#USER CONFIG\n$EWBF_USER_CONFIG\n"

	conf+="\n\n[server]\n"

	[[ ! -z $ZSERVER ]] && conf+="server $ZSERVER\n" || echo -e "${RED}ZSERVER not set${NOCOLOR}"
	[[ ! -z $ZPORT ]] && conf+="port $ZPORT\n" || echo -e "${RED}ZPORT not set${NOCOLOR}"
	[[ ! -z $ZPASS ]] && conf+="pass $ZPASS\n" || echo -e "${RED}ZPASS not set${NOCOLOR}"


	if [[ -z $ZTEMPLATE ]]; then
		echo -e "${RED}ZTEMPLATE not set{NOCOLOR}"
	else
		#escape variable
		#ZTEMPLATE=$(sed 's/[]\/$*.^|[]/\\&/g' <<<"$ZTEMPLATE")
		#sed -i --follow-symlinks "s/^user .*/user $ZTEMPLATE/g" $EWBF_CONFIG
		conf+="user $ZTEMPLATE\n"
	fi

	echo -e "$conf" > $MINER_CONFIG
}
