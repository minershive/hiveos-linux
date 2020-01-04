#!/usr/bin/env bash

export GPU_MAX_WORKGROUP_SIZE=1024

cd $MINER_DIR/$MINER_FORK/$MINER_VER

case $MINER_FORK in
	"monerov" )
		[[ `ps aux | grep "./MoneroVMiner" | grep -v grep | wc -l` != 0 ]] &&
			echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
			exit 1
		./MoneroVMiner mode=rolling | tee $MINER_LOG_BASENAME.log
		;;
	* )
		if [[ "$MINER_VER" < "3.0" ]]; then
			[[ `ps aux | grep "./GrinGoldMinerCLI" | grep -v grep | wc -l` != 0 ]] &&
				echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
				exit 1
			./GrinGoldMinerCLI mode=rolling | tee $MINER_LOG_BASENAME.log
		else
			[[ `ps aux | grep "./GrinGoldMinerAPI" | grep -v grep | wc -l` != 0 ]] &&
				echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
				exit 1
			./GrinGoldMinerAPI mode=rolling | tee $MINER_LOG_BASENAME.log
		fi
		;;
esac

fi
