#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$NBMINER_VER
  [[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
  echo $MINER_VER
}

function miner_config_echo() {
  local MINER_VER=`miner_ver`
  miner_echo_config_file "$MINER_DIR/$MINER_VER/config.json"
}

function miner_config_gen() {
  local MINER_CONFIG="$MINER_DIR/$MINER_FORK/$MINER_VER/config.json"
  mkfile_from_symlink $MINER_CONFIG

  config_global=`cat $MINER_DIR/$MINER_FORK/$MINER_VER/config_global.json`



  local conf='{ }'
  local add_param=

  #"algo": "tensority_ethash",
  conf=`jq --null-input --argjson conf "$conf" --arg algo "$NBMINER_ALGO" '$conf + {$algo}'`
  #"api": "127.0.0.1:22333",
  conf=`jq --null-input --argjson conf "$conf" --arg api "127.0.0.1:$MINER_API_PORT" '$conf + {$api}'`

  local i=
  for url in $NBMINER_URL; do
    #"url": "stratum+tcp://btm.f2pool.com:9221",
    #"url1": "",
    #"url2": "",
    grep -q "://" <<< $url
    result=$?
    if [[ -z $NBMINER_TLS ]]; then
       [[ $result -ne 0 ]] && url="stratum+tcp://${url}"
    else
       [[ $result -ne 0 ]] && url="stratum+ssl://${url}"
    fi
    add_param='{ "url'$i'": "'$url'" }'
    conf=`jq --null-input --argjson conf "$conf" --argjson add_param "$add_param" '$conf + $add_param'`

    #"user": "bm1qjce8ml6nruc78kmw3v7m0k67nj39mmwwwketnu.default",
    #"user1": "",
    #"user2": "",
    [[ ! -z $NBMINER_PASS ]] && add_param=":$NBMINER_PASS" || add_param=
    add_param='{ "user'$i'": "'${NBMINER_TEMPLATE}${add_param}'" }'
    conf=`jq --null-input --argjson conf "$conf" --argjson add_param "$add_param" '$conf + $add_param'`

    [[ i == '' ]] && i=1 || let "i++"
    [[ i -eq 3 ]] && break
  done

  if [[ ! -z $NBMINER_URL2 ]]; then
    i=
    for url in $NBMINER_URL2; do
      #"secondary-url": "ethproxy+tcp://eth.f2pool.com:8008",
      #"secondary-url1": "",
      #"secondary-url2": "",
      add_param='{ "secondary-url'$i'": "'$url'" }'
      conf=`jq --null-input --argjson conf "$conf" --argjson add_param "$add_param" '$conf + $add_param'`

      #"secondary-user": "0x4296116d44a4a7259B52B1A756e19083e675062A.default",
      #"secondary-user1": "",
      #"secondary-user2": "",
      [[ ! -z $NBMINER_PASS2 ]] && add_param=":$NBMINER_PASS2" || add_param=
      add_param='{ "secondary-user'$i'": "'${NBMINER_TEMPLATE2}${add_param}'" }'
      conf=`jq --null-input --argjson conf "$conf" --argjson add_param "$add_param" '$conf + $add_param'`

      [[ i == '' ]] && i=1 || let "i++"
      [[ i -eq 3 ]] && break
    done

    #"secondary-intensity": 16,
    [[ -z $NBMINER_INTENSITY ]] && NBMINER_INTENSITY=16
    add_param='{ "secondary-intensity": "'${NBMINER_INTENSITY}'" }'
    conf=`jq --null-input --argjson conf "$conf" --argjson add_param "$add_param" '$conf + $add_param'`
  fi

  #"devices": "",
  if [[ ! -z $NBMINER_USER_CONFIG ]]; then
    while read -r line; do
      [[ -z $line ]] && continue
      #echo "$line," >> $userconf
      conf=`jq --null-input --argjson conf "$conf" --argjson line "{$line}" '$conf + $line'`
    done <<< "$NBMINER_USER_CONFIG"
  fi

  conf=`jq -n --argjson g "$config_global" --argjson c "$conf" '$g * $c'`

  echo "$conf" | jq . > $MINER_CONFIG
}
