#!/usr/bin/env bash

# Not required
function miner_fork() {
	local MINER_FORK=$CCMINER_FORK
	[[ -z $MINER_FORK ]] && MINER_FORK=$MINER_DEFAULT_FORK

	echo $MINER_FORK
}


function miner_ver() {
  case $MINER_FORK in
	alexis )
		echo $MINER_LATEST_VER_ALEXIS
		;;
	allium )
		echo $MINER_LATEST_VER_ALLIUM
		;;
	bcd	)
		echo $MINER_LATEST_VER_BCD
		;;
	"dace-cryptonight" )
		echo $MINER_LATEST_VER_DACE_CRYPTONIGHT
		;;
	djm34 )
		echo $MINER_LATEST_VER_DJM34
		;;
	enemy )
		echo $MINER_LATEST_VER_ENEMY
		;;
	klaust )
		echo $MINER_LATEST_VER_KLAUST
		;;
	nanashi )
		echo $MINER_LATEST_VER_NANASHI
		;;
	nevermore )
		echo $MINER_LATEST_VER_NEVERMORE
		;;
	"nevermore-x16s" )
		echo $MINER_LATEST_VER_NEVERMORE_X16S
		;;
	"phi-anxmod" )
		echo $MINER_LATEST_VER_PHI_ANXMOD
		;;
	rvn )
		echo $MINER_LATEST_VER_RVN
		;;
	"sp-mod" )
		echo $MINER_LATEST_VER_SP_MOD
		;;
	suprminer )
		echo $MINER_LATEST_VER_SUPRMINER
		;;
	tpruvot )
		echo $MINER_LATEST_VER_TPRUVOT
		;;
	vertminer )
		echo $MINER_LATEST_VER_VERTMINER
		;;
	xevan )
		echo $MINER_LATEST_VER_XEVAN
		;;
	zp )
		echo $MINER_LATEST_VER_ZP
		;;
  esac
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
		echo $CCMINERCONF | jq . > $MINER_CONFIG

		echo "Generating $MINER_CONFIG"

		#Don't remove until Hive 1 is gone
		[[ ! -z $EWAL ]] && sed -i --follow-symlinks "s/%EWAL%/$EWAL/g" $MINER_CONFIG #|| echo "EWAL not set"
		[[ ! -z $ZWAL ]] && sed -i --follow-symlinks "s/%ZWAL%/$ZWAL/g" $MINER_CONFIG #|| echo "ZWAL not set"
		[[ ! -z $DWAL ]] && sed -i --follow-symlinks "s/%DWAL%/$DWAL/g" $MINER_CONFIG #|| echo "DWAL not set"
		[[ ! -z $EMAIL ]] && sed -i --follow-symlinks "s/%EMAIL%/$EMAIL/g" $MINER_CONFIG #|| echo "EMAIL not set"
		[[ ! -z $WORKER_NAME ]] && sed -i --follow-symlinks "s/%WORKER_NAME%/$WORKER_NAME/g" $MINER_CONFIG #||  "WORKER_NAME not set"
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