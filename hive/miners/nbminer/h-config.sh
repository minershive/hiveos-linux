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
    add_param='{ "secondary-intensity": '${NBMINER_INTENSITY}' }'
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

  if [[ $USE_COMMAND_LINE -ne 1 ]]; then
    echo "$conf" | jq . > $MINER_CONFIG
  else
    local conf_line=
    [[ ! -z `echo $conf | jq -r '.algo'` && `echo $conf | jq -r '.algo'` != "null" ]] && conf_line+=" --algo `echo $conf | jq -r '.algo'`"
    [[ ! -z `echo $conf | jq -r '.api'` && `echo $conf | jq -r '.api'` != "null" ]] && conf_line+=" --api `echo $conf | jq -r '.api'`"
    [[ ! -z `echo $conf | jq -r '.coin'` && `echo $conf | jq -r '.coin'` != "null" ]] && conf_line+=" --coin `echo $conf | jq -r '.coin'`"
    [[ `echo $conf | jq -r '."cuckatoo-power-optimize"'` == "true" && `echo $conf | jq -r '."cuckatoo-power-optimize"'` != "null" ]] && conf_line+=" --cuckatoo-power-optimize"
    [[ ! -z `echo $conf | jq -r '."cuckoo-intensity"'` && `echo $conf | jq -r '."cuckoo-intensity"'` != "null" ]] && conf_line+=" --cuckoo-intensity `echo $conf | jq -r '."cuckoo-intensity"'`"
    [[ ! -z `echo $conf | jq -r '.devices'` && `echo $conf | jq -r '.devices'` != "null" ]] && conf_line+=" --devices `echo $conf | jq -r '.devices'`"
    [[ ! -z `echo $conf | jq -r '."fidelity-timeframe"'` && `echo $conf | jq -r '."fidelity-timeframe"'` != "null" ]] && conf_line+=" --fidelity-timeframe `echo $conf | jq -r '."fidelity-timeframe"'`"
    [[ ! -z `echo $conf | jq -r '.intensity'` && `echo $conf | jq -r '.intensity'` != "null" ]] && conf_line+=" --intensity `echo $conf | jq -r '.intensity'`"
    [[ ! -z `echo $conf | jq -r '."no-nvml"'` && `echo $conf | jq -r '."no-nvml"'` != "null" ]] && conf_line+=" --no-nvml `echo $conf | jq -r '."no-nvml"'`"
    [[ ! -z `echo $conf | jq -r '.platform'` && `echo $conf | jq -r '.platform'` != "null" ]] && conf_line+=" --platform `echo $conf | jq -r '.platform'`"
    [[ ! -z `echo $conf | jq -r '."secondary-intensity"'` && `echo $conf | jq -r '."secondary-intensity"'` != "null" ]] && conf_line+=" -di `echo $conf | jq -r '."secondary-intensity"'`"
    [[ ! -z `echo $conf | jq -r '."secondary-url"'` && `echo $conf | jq -r '."secondary-url"'` != "null" ]] && conf_line+=" --secondary-url `echo $conf | jq -r '."secondary-url"'`"
    [[ ! -z `echo $conf | jq -r '."secondary-user"'` && `echo $conf | jq -r '."secondary-user"'` != "null" ]] && conf_line+=" --secondary-user `echo $conf | jq -r '."secondary-user"'`"
    [[ ! -z `echo $conf | jq -r '."secondary-url1"'` && `echo $conf | jq -r '."secondary-url1"'` != "null" ]] && conf_line+=" --secondary-url1 `echo $conf | jq -r '."secondary-url1"'`"
    [[ ! -z `echo $conf | jq -r '."secondary-user1"'` && `echo $conf | jq -r '."secondary-user1"'` != "null" ]] && conf_line+=" --secondary-user1 `echo $conf | jq -r '."secondary-user1"'`"
    [[ ! -z `echo $conf | jq -r '."secondary-url2"'` && `echo $conf | jq -r '."secondary-url2"'` != "null" ]] && conf_line+=" --secondary-url2 `echo $conf | jq -r '."secondary-url2"'`"
    [[ ! -z `echo $conf | jq -r '."secondary-user2"'` && `echo $conf | jq -r '."secondary-user2"'` != "null" ]] && conf_line+=" --secondary-user2 `echo $conf | jq -r '."secondary-user2"'`"
    [[ `echo $conf | jq -r '."strict-ssl"'` == "true" && `echo $conf | jq -r '."strict-ssl"'` != "null" ]] && conf_line+=" --strict-ssl"
    [[ ! -z `echo $conf | jq -r '."temperature-limit"'` && `echo $conf | jq -r '."temperature-limit"'` != "null" ]] && conf_line+=" --temperature-limit `echo $conf | jq -r '."temperature-limit"'`"
    [[ ! -z `echo $conf | jq -r '.url'` && `echo $conf | jq -r '.url'` != "null" ]] && conf_line+=" --url `echo $conf | jq -r '.url'`"
    [[ ! -z `echo $conf | jq -r '.user'` && `echo $conf | jq -r '.user'` != "null" ]] && conf_line+=" --user `echo $conf | jq -r '.user'`"
    [[ ! -z `echo $conf | jq -r '.url1'` && `echo $conf | jq -r '.url1'` != "null" ]] && conf_line+=" --url1 `echo $conf | jq -r '.url1'`"
    [[ ! -z `echo $conf | jq -r '.user1'` && `echo $conf | jq -r '.user1'` != "null" ]] && conf_line+=" --user1 `echo $conf | jq -r '.user1'`"
    [[ ! -z `echo $conf | jq -r '.url2'` && `echo $conf | jq -r '.url2'` != "null" ]] && conf_line+=" --url2 `echo $conf | jq -r '.url2'`"
    [[ ! -z `echo $conf | jq -r '.user2'` && `echo $conf | jq -r '.user2'` != "null" ]] && conf_line+=" --user2 `echo $conf | jq -r '.user2'`"

    echo $conf_line > $MINER_CONFIG
  fi
}
