#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$DAMOMINER_VER
  [[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
  echo $MINER_VER
}

function miner_config_echo() {
  local MINER_VER=`miner_ver`
  miner_echo_config_file "$MINER_DIR/$MINER_VER/miner.conf"
}

function miner_config_gen() {
  local MINER_CONFIG="$MINER_DIR/$MINER_VER/miner.conf"
  mkfile_from_symlink $MINER_CONFIG

  local conf=

  conf="-A $DAMOMINER_ALGO"
  conf+=" --api-bind 127.0.0.1:-$MINER_API_PORT"

  local prefix1=$DAMOMINER_TEMPLATE
  local postfix1=
  if [[ ! -z $DAMOMINER_WORKER ]]; then
    if [[ $DAMOMINER_WORKER =~ "@" || $DAMOMINER_WORKER =~ "%40" ]]; then
      #email found, adding workername/email to postfix
      postfix1+="/${DAMOMINER_WORKER//@/%40}" #replace "@" with "%40"
    else
      #email not found, adding workername to prefix
      prefix1+=".$DAMOMINER_WORKER"
    fi
  fi
  [[ ! -z $DAMOMINER_PASS ]] && prefix1+=":$DAMOMINER_PASS"

  if [[ ! -z $DAMOMINER_URL ]]; then
    if [[ $DAMOMINER_ALGO =~ "_" ]]; then #dual mode
      conf+=" -E "
    else #single mode
      conf+=" -P "
    fi
    local epool=`head -n 1 <<< "$DAMOMINER_URL"`
    if [[ ! ${epool,,} =~ "://" ]]; then
      if [[ $DAMOMINER_NICEHASH -eq 1 ]]; then
        conf+="nicehash+tcp://$prefix1@$epool$postfix1"
      else
        conf+="stratum1+tcp://$prefix1@$epool$postfix1"
      fi
    else
      epool=${epool/:\/\//:\/\/$prefix1@} #replace "://" with "://prefix"
      conf+="$epool$posfix1"
    fi
  fi

  local prefix2=$DAMOMINER_TEMPLATE2
  local postfix2=
  if [[ ! -z $DAMOMINER_WORKER2 ]]; then
    if [[ $DAMOMINER_WORKER2 =~ "@" || $DAMOMINER_WORKER2 =~ "%40" ]]; then
      #email found, adding workername/email to postfix
      postfix2+="/${DAMOMINER_WORKER2//@/%40}" #replace "@" with "%40"
    else
      #email not found, adding workername to prefix
      prefix2+=".$DAMOMINER_WORKER2"
    fi
  fi
  [[ ! -z $DAMOMINER_PASS2 ]] && prefix2+=":$DAMOMINER_PASS2"

  if [[ ! -z $DAMOMINER_URL2 ]]; then
    local ppool=`head -n 1 <<< "$DAMOMINER_URL2"`
    if [[ ! ${ppool,,} =~ "://" ]]; then
        conf+=" -P stratum+tcp://$prefix2@$ppool$postfix2"
    else
      ppool=${ppool/:\/\//:\/\/$prefix2@} #replace "://" with "://prefix"
      conf+=" -P $ppool$postfix2"
    fi

    [[ ! -z $DAMOMINER_INTENSITY ]] &&
      conf+=" -I $DAMOMINER_INTENSITY"
  fi

  #"devices": "",
  if [[ ! -z $DAMOMINER_USER_CONFIG ]]; then
    conf+="$DAMOMINER_USER_CONFIG"
  fi

  echo $conf > $MINER_CONFIG
}
