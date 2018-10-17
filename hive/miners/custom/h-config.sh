#!/usr/bin/env bash

function miner_ver() {
	echo ""
}


function miner_config_echo() {
	if [[ -z $CUSTOM_MINER ]]; then
		echo -e "${RED}\$CUSTOM_MINER is not defined${NOCOLOR}"
		return 1
	fi

	if [[ -e $MINER_DIR/$CUSTOM_MINER/h-manifest.conf ]]; then
		source $MINER_DIR/$CUSTOM_MINER/h-manifest.conf
	fi

	if [[ ! -z $CUSTOM_CONFIG_FILENAME ]]; then
		miner_echo_config_file $CUSTOM_CONFIG_FILENAME
	else
		echo -e "${RED}\$CUSTOM_CONFIG_FILENAME is not defined${NOCOLOR}";
		return 1
	fi

}


function miner_config_gen() {
	[[ -z $CUSTOM_MINER ]] && echo -e "${RED}\$CUSTOM_MINER is not defined${NOCOLOR}" && exit 1

	# Installation attempt ====================

	if [[ ! -z $CUSTOM_INSTALL_URL ]]; then
		$MINER_DIR/custom-get "$CUSTOM_INSTALL_URL"
		[[ $? -ne 0 ]] &&
			message error "Unable to install miner from $CUSTOM_INSTALL_URL" &&
			exit 1


		#Get the name of miner directory. Same as with the installation. To prevent errors similar to "file not found"
		basename=`basename -s .tar.gz "$CUSTOM_INSTALL_URL"`
		version=`echo "$basename" | awk -F '-' '{ print $NF }'`
		DETECTED_CUSTOM_MINER=`echo "$basename" | sed 's/'-$version'$//'`
		[[ $CUSTOM_MINER != $DETECTED_CUSTOM_MINER ]] &&
			echo -e "${RED}Custom miner name should be \"$DETECTED_CUSTOM_MINER\"${NOCOLOR}" &&
			message error "Custom miner name should be \"$DETECTED_CUSTOM_MINER\", \"$CUSTOM_MINER\" is wrong" &&
			exit 1
	fi


	[[ ! -e $MINER_DIR/$CUSTOM_MINER/h-manifest.conf ]] && echo -e "${RED}No $CUSTOM_MINER/h-manifest.conf${NOCOLOR}" && exit 1
	. $MINER_DIR/$CUSTOM_MINER/h-manifest.conf


	# Actual config call ====================

	[[ ! -e $MINER_DIR/$CUSTOM_MINER/h-config.sh ]] && echo -e "${RED}No custom config generator${NOCOLOR}" && return 1
	. $MINER_DIR/$CUSTOM_MINER/h-config.sh
}
