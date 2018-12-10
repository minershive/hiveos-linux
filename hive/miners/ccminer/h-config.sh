#!/usr/bin/env bash

# Not required
function miner_fork() {
	local MINER_FORK=$CCMINER_FORK
	[[ -z $MINER_FORK ]] && MINER_FORK=$MINER_DEFAULT_FORK

	echo $MINER_FORK
}


function miner_ver() {
	local MINER_VER=$CCMINER_VER
	local fork=${MINER_FORK^^} #uppercase MINER_FORK
	[[ -z $MINER_VER ]] && eval "MINER_VER=\$MINER_LATEST_VER_${fork//-/_}" #char replace
	echo $MINER_VER
}


function miner_config_echo() {
	export MINER_FORK=`miner_fork`
	local MINER_VER=`miner_ver`
	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_FORK/$MINER_VER/pools.conf"
}


function miner_config_gen() {
	local MINER_CONFIG="$MINER_DIR/$MINER_FORK/$MINER_VER/pools.conf"
	mkfile_from_symlink $MINER_CONFIG

	if [[ -z $CCMINERCONF || $CCMINERCONF = "{}" ]]; then
		echo -e "${YELLOW}WARNING: No CCMINERCONF set, skipping $MINER_CONFIG generation${NOCOLOR}"
	else
		echo "Generating $MINER_CONFIG"
		echo $CCMINERCONF | jq . > $MINER_CONFIG
	fi

	scratch_path="$HOME/.cache/boolberry"
	algo=`cat $MINER_CONFIG | jq ".algo" --raw-output`
	pool_url=`cat $MINER_CONFIG | jq ".pools[].url" --raw-output`
	if [[ ${algo} == "wildkeccak" ]]; then
	  if [[ -f ${scratch_path}/scratchpad.bin ]]; then
		 # check if url changed then remove old scratchpad.bin
		 if [[ -f $scratch_path/pool_url.txt ]]; then
		   # scratchpad file and active pool found
		   url=`cat $scratch_path/pool_url.txt`
		   if [[ $pool_url != $url ]]; then
			 # previous pool and new one are not the same - delete old scratchpad file
			 rm ~/.cache/boolberry/scratchpad.bin
		   fi
		 fi
	  fi
	  if [[ ! -d ${scratch_path} ]]; then
		 mkdir ${scratch_path}
	  fi
	  # update active pool
	  echo $pool_url > $scratch_path/pool_url.txt
	fi
}
