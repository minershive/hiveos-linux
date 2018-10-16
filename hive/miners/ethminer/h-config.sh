#!/usr/bin/env bash

# Not required
function miner_fork() {
	local MINER_FORK=$ETHMINER_VER
	[[ -z $MINER_FORK ]] && MINER_FORK=$MINER_DEFAULT_FORK
	echo $MINER_FORK
}


function miner_ver() {
	if [[ $MINER_FORK == "ethash" ]]; then
		echo $MINER_LATEST_VER_ETHASH
	elif [[ $MINER_FORK == "progpow" ]]; then
		echo $MINER_LATEST_VER_PROGPOW
	fi
}


function miner_config_echo() {
	export MINER_FORK=`miner_fork`
	local MINER_VER=`miner_ver`
	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_FORK/$MINER_VER/ethminer.conf"
}


function miner_config_gen() {
	local MINER_CONFIG="$MINER_DIR/$MINER_FORK/$MINER_VER/ethminer.conf"
	mkfile_from_symlink $MINER_CONFIG

	#put default config settings
	#\n--farm-recheck 2000
	echo -e "--report-hashrate --api-port 3334" > $MINER_CONFIG
	if [[ $ETHMINER_VER == "0.14.0" ]]; then
		echo -e "-HWMON" >> $MINER_CONFIG
	else #0.15.0 and later
		echo -e "--HWMON 1" >> $MINER_CONFIG
	fi

	[[ $ETHMINER_OPENCL == 0 ]] && ETHMINER_OPENCL=
	[[ $ETHMINER_CUDA == 0 ]] && ETHMINER_CUDA=

	if [[ $ETHMINER_OPENCL == 1 && $ETHMINER_CUDA == 1 ]]; then #|| [[ -z $ETHMINER_OPENCL && -z $ETHMINER_CUDA ]]
		#autodetect gpu types
		[[ -z $GPU_COUNT_AMD ]] && GPU_COUNT_AMD=`gpu-detect AMD`
		[[ -z $GPU_COUNT_NVIDIA ]] && GPU_COUNT_NVIDIA=`gpu-detect NVIDIA`

		echo "Detected $GPU_COUNT_AMD AMD"
		echo "Detected $GPU_COUNT_NVIDIA Nvidia"
		[[ $GPU_COUNT_AMD > 0 ]] && ETHMINER_OPENCL=1 || ETHMINER_OPENCL=
		[[ $GPU_COUNT_NVIDIA > 0 ]] && ETHMINER_CUDA=1 || ETHMINER_CUDA=
	fi

	[[ -z $ETHMINER_OPENCL && -z $ETHMINER_CUDA ]] && echo "--cuda-opencl --opencl-platform 1" >> $MINER_CONFIG
	[[ $ETHMINER_OPENCL == 1 && $ETHMINER_CUDA == 1 ]] && echo "--cuda-opencl" >> $MINER_CONFIG
	[[ $ETHMINER_OPENCL == 1 && -z $ETHMINER_CUDA ]] && echo "--opencl" >> $MINER_CONFIG
	[[ -z $ETHMINER_OPENCL && $ETHMINER_CUDA == 1 ]] && echo "--cuda" >> $MINER_CONFIG

#pre 0.14.0rc0
#	if [[ ! -z $ETHMINER_TEMPLATE ]]; then
#		echo -n "-O $ETHMINER_TEMPLATE" >> $MINER_CONFIG
#		[[ ! -z $ETHMINER_PASS ]] && echo -n ":$ETHMINER_PASS" >> $MINER_CONFIG
#		echo -en "\n" >> $MINER_CONFIG
#	fi
#
#	if [[ ! -z $ETHMINER_SERVER ]]; then
#		echo -n "-S $ETHMINER_SERVER" >> $MINER_CONFIG
#		[[ ! -z $ETHMINER_PORT ]] && echo -n ":$ETHMINER_PORT" >> $MINER_CONFIG
#		echo -en "\n" >> $MINER_CONFIG
#	fi

	if [[ ! -z $ETHMINER_TEMPLATE && ! -z $ETHMINER_SERVER ]]; then
		local url=
		local protocol=
		local server=
		grep -q -E '^(stratum|http).*://' <<< $ETHMINER_SERVER
		if [[ $? == 0 ]]; then
			protocol=$(awk -F '://' '{print $1"://"}' <<< $ETHMINER_SERVER)
			server=$(awk -F '://' '{print $2}' <<< $ETHMINER_SERVER)
		else #no protocol in server
			protocol="stratum+tcp://"
			server=$ETHMINER_SERVER
		fi

		url+=$protocol

		ETHMINER_TEMPLATE=$(sed 's/\//%2F/g' <<< $ETHMINER_TEMPLATE) #HTML special chars
		EMAIL=$(sed 's/@/%40/g' <<< $EMAIL) #HTML special chars

		url+=$ETHMINER_TEMPLATE
		[[ ! -z $ETHMINER_PASS ]] && url+=":$ETHMINER_PASS"

		url+="@$server:$ETHMINER_PORT"

		echo "-P $url" >> $MINER_CONFIG
	fi

	[[ ! -z $ETHMINER_USER_CONFIG ]] && echo "$ETHMINER_USER_CONFIG" >> $MINER_CONFIG

	#remove deprecated option
	sed -i '/--stratum-protocol/d' $MINER_CONFIG

	#replace tpl values in whole file
	#Don't remove until Hive 1 is gone
#	[[ -z $EWAL && -z $ZWAL && -z $DWAL ]] && echo -e "${RED}No WAL address is set${NOCOLOR}"
	[[ ! -z $EWAL ]] && sed -i --follow-symlinks "s/%EWAL%/$EWAL/g" $MINER_CONFIG #|| echo -e "${RED}EWAL not set${NOCOLOR}"
	[[ ! -z $DWAL ]] && sed -i --follow-symlinks "s/%DWAL%/$DWAL/g" $MINER_CONFIG #|| echo -e "${RED}DWAL not set${NOCOLOR}"
	[[ ! -z $ZWAL ]] && sed -i --follow-symlinks "s/%ZWAL%/$ZWAL/g" $MINER_CONFIG #|| echo -e "${RED}ZWAL not set${NOCOLOR}"
	[[ ! -z $WORKER_NAME ]] && sed -i --follow-symlinks "s/%WORKER_NAME%/$WORKER_NAME/g" $MINER_CONFIG || echo "${RED}WORKER_NAME not set${NOCOLOR}"
	[[ ! -z $EMAIL ]] && sed -i --follow-symlinks "s/%EMAIL%/$EMAIL/g" $MINER_CONFIG
}
