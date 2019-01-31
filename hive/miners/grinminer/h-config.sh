#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$GRINMINER_VER
  [[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
  echo $MINER_VER
}


function miner_config_echo() {
  local MINER_VER=`miner_ver`
  miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/grin-miner.toml"
}

function miner_config_gen() {

  local MINER_CONFIG="$MINER_DIR/$MINER_VER/grin-miner.toml"
  mkfile_from_symlink $MINER_CONFIG

  [[ -z $GRINMINER_TEMPLATE ]] && echo -e "${YELLOW}GRINMINER_TEMPLATE is empty${NOCOLOR}" && return 1
  [[ -z $GRINMINER_URL ]] && echo -e "${YELLOW}GRINMINER_URL is empty${NOCOLOR}" && return 1
  [[ -z $MINER_CONFIG ]] && echo -e "${RED}No MINER_CONFIG is set${NOCOLOR}" && return 1
  [[ -z $MINER_LOG_BASENAME ]] && echo -e "${RED}No MINER_LOG_BASENAME is set${NOCOLOR}" && exit 1

  echo "[logging]" > $MINER_CONFIG
  echo "log_to_stdout = true" >> $MINER_CONFIG
  echo "stdout_log_level = \"Debug\"" >> $MINER_CONFIG
  echo "log_to_file = true" >> $MINER_CONFIG
  echo "file_log_level = \"Debug\"" >> $MINER_CONFIG
  echo "log_file_path = \"${MINER_LOG_BASENAME}.log\"" >> $MINER_CONFIG
  echo "log_file_append = true" >> $MINER_CONFIG

  echo "[mining]" >> $MINER_CONFIG
  echo "run_tui = false" >> $MINER_CONFIG
  local pool=`head -n 1 <<< "$GRINMINER_URL"`
  echo "stratum_server_addr = \"$pool\"" >> $MINER_CONFIG
  echo "stratum_server_login = \"$GRINMINER_TEMPLATE\"" >> $MINER_CONFIG
  echo "stratum_server_password = \"$GRINMINER_PASS\"" >> $MINER_CONFIG
  echo "stratum_server_tls_enabled = false" >> $MINER_CONFIG

  if [[ -z $GRINMINER_USER_CONFIG ]]; then
    #autogeneration for all available cards
    #Nvidia
    for (( i=0; i < $(gpu-detect NVIDIA); i++ )); do
      echo '[[mining.miner_plugin_config]]' >> $MINER_CONFIG
      echo 'plugin_name="cuckaroo_cuda_29"' >> $MINER_CONFIG
      echo '[mining.miner_plugin_config.parameters]' >> $MINER_CONFIG
      echo 'device='$i >> $MINER_CONFIG
      if [[ $i -eq 0 ]]; then
        echo 'cpuload=1' >> $MINER_CONFIG
        echo 'ntrims=176' >> $MINER_CONFIG
        echo 'genablocks=4096' >> $MINER_CONFIG
        echo 'genatpb=128' >> $MINER_CONFIG
        echo 'genbtpb=128' >> $MINER_CONFIG
        echo 'trimtpb=512' >> $MINER_CONFIG
        echo 'tailtpb=1024' >> $MINER_CONFIG
        echo 'recoverblocks=1024' >> $MINER_CONFIG
        echo 'recovertpb=1024' >> $MINER_CONFIG
      fi
    done
    #AMD
    for (( i=0; i < $(gpu-detect AMD); i++ )); do
      echo '[[mining.miner_plugin_config]]' >> $MINER_CONFIG
      echo 'plugin_name = "ocl_cuckaroo"' >> $MINER_CONFIG
      echo '[mining.miner_plugin_config.parameters]' >> $MINER_CONFIG
      echo 'platform = 1' >> $MINER_CONFIG
      echo 'device = '$i >> $MINER_CONFIG
    done
  else
    #using user config
    while read -r line; do
      echo $line >> $MINER_CONFIG
    done <<< "$GRINMINER_USER_CONFIG"
  fi
}
