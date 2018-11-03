#!/usr/bin/env bash


[[ `ps aux | grep "./CryptoDredge" | grep -v grep | wc -l` != 0 ]] &&
	echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
	exit 1

#try to release TIME_WAIT sockets
while true; do
	for con in `netstat -anp | grep TIME_WAIT | grep $MINER_API_PORT | awk '{print $5}'`; do
		killcx $con lo
	done
	netstat -anp | grep TIME_WAIT | grep $MINER_API_PORT &&
		continue ||
		break
done

#installing libc-ares2 if necessary
[[ `dpkg -s libc-ares2 2>/dev/null | grep -c "ok installed"` -eq 0 ]] && apt-get install -y libc-ares2

cd $MINER_DIR/$MINER_VER

# #switching cuda version
# DRV_VERS=`nvidia-smi --help | head -n 1 | awk '{print $NF}' | sed 's/v//' | tr '.' ' ' | awk '{print $1}'`
#
# echo -e -n "${GREEN}NVidia${NOCOLOR} driver ${GREEN}${DRV_VERS}${NOCOLOR}-series detected "
# if [ ${DRV_VERS} -ge 396 ]; then
#    echo -e "(${BCYAN}CUDA 9.2${NOCOLOR} compatible)"
#    ln -fs CryptoDredge_с92 CryptoDredge
# else
#    echo -e "(${BCYAN}CUDA 9.1${NOCOLOR} compatible)"
#    ln -fs CryptoDredge_с91 CryptoDredge
# fi

./CryptoDredge $(< ${MINER_NAME}.conf) --log $MINER_LOG_BASENAME.log -b 127.0.0.1:${MINER_API_PORT}
