#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$KBMINER_VER
  [[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
  echo $MINER_VER
}

function miner_config_echo() {
  local MINER_VER=`miner_ver`
  miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/${MINER_NAME}.conf"
}

function miner_config_gen() {
  local MINER_CONFIG="$MINER_DIR/$MINER_VER/${MINER_NAME}.conf"
  mkfile_from_symlink $MINER_CONFIG

  [[ -z $KBMINER_TEMPLATE ]] && echo -e "${YELLOW}KBMINER_TEMPLATE is empty${NOCOLOR}" && return 1
  [[ -z $KBMINER_URL ]] && echo -e "${YELLOW}KBMINER_URL is empty${NOCOLOR}" && return 1

  local conf=
  local pool=`head -n 1 <<< "$KBMINER_URL"`
  local psw=
  local tls=

  [[ -z $KBMINER_ALGO ]] && $KBMINER_ALGO="grin-cuckaroo29"

  [[ ! -z $KBMINER_PASS ]] && psw=" -pass $KBMINER_PASS"
  [[ $KBMINER_TLS -eq 1 ]] && tls=" --enabletls"

  conf="--algorithm ${KBMINER_ALGO} --pool $pool --user ${KBMINER_TEMPLATE}${psw} ${KBMINER_USER_CONFIG}${tls}"

  echo "$conf" > $MINER_CONFIG
}

# Usage: kbminer [--verbose] --pool POOL --user USER [--pass PASS] [--agent AGENT] [--gpu GPU] [--params PARAMS] [--enableapi] [--apiaddr APIADDR] [--disablewatchdog] [--algorithm ALGORITHM] [--checkdifficulty] [--enabletls] [--delayonupdate] [--timeout TIMEOUT] [--connecttimeout CONNECTTIMEOUT] [--readtimeout READTIMEOUT] [--writetimeout WRITETIMEOUT] [--retryinterval RETRYINTERVAL] [--maxretry MAXRETRY]
#
# Options:
#   --verbose, -v          print debug message
#   --pool POOL            pool addrs, eg: '--pool addr1 --pool addr2 ...'
#   --user USER            login identifier for mining pool. there is usually some constrains defined by mining pool, ask maintainer for detail
#   --pass PASS            login password.  ask pool maintainer for detail if your pool requires a strong password  [default: x]
#   --agent AGENT          name of mining software passing to pool [default: kbminer]
#   --gpu GPU              enabled gpu, eg: '--gpu 0 --gpu 2' means miner would only work with gpu 0 and gpu 2
#   --params PARAMS        params passing to gpu. DO NOT change them unless you know what you are doing
#   --enableapi            if set to true, and API server will be start on port [APIAddr], serving mining status queries [default: true]
#   --apiaddr APIADDR      see EnableAPI. no effect if EnableAPI set to false [default: :3333]
#   --disablewatchdog      with watchdog, miner will quit when all gpus stopped working for more then 5-minutes
#   --algorithm ALGORITHM
#                          grin-cuckaroo29, grin-cuckatoo31 [default: grin-cuckaroo29]
#   --checkdifficulty      check difficulty before submit
#   --enabletls
#   --delayonupdate        apply delay on update strategy, to smooth power consuming peeks
#   --timeout TIMEOUT      this timeout option will overwrite all unset timeout for connect/read/write [default: 1m0s]
#   --connecttimeout CONNECTTIMEOUT
#   --readtimeout READTIMEOUT [default: 5m0s]
#   --writetimeout WRITETIMEOUT
#   --retryinterval RETRYINTERVAL [default: 10s]
#   --maxretry MAXRETRY    max retires before successfully connected to pool [default: 10]
#   --help, -h             display this help and exit
