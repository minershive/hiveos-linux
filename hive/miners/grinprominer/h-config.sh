#!/usr/bin/env bash

function miner_ver() {
  local MINER_VER=$GRINPROMINER_VER
  [[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
  echo $MINER_VER
}


function miner_config_echo() {
  local MINER_VER=`miner_ver`
  miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/config.xml"
}

function miner_config_gen() {

  local MINER_CONFIG="$MINER_DIR/$MINER_VER/config.xml"
  mkfile_from_symlink $MINER_CONFIG

  [[ -z $GRINPROMINER_TEMPLATE ]] && echo -e "${YELLOW}GRINPROMINER_TEMPLATE is empty${NOCOLOR}" && return 1
  [[ -z $GRINPROMINER_URL ]] && echo -e "${YELLOW}GRINPROMINER_URL is empty${NOCOLOR}" && return 1
  [[ -z $MINER_CONFIG ]] && echo -e "${RED}No MINER_CONFIG is set${NOCOLOR}" && return 1
  [[ -z $MINER_LOG_BASENAME ]] && echo -e "${RED}No MINER_LOG_BASENAME is set${NOCOLOR}" && exit 1

  local pool1=`head -n 1 <<< "$GRINPROMINER_URL" | cut -f 1 -d ":" -s`
  local port1=`head -n 1 <<< "$GRINPROMINER_URL" | cut -f 2 -d ":" -s`
  local pool2=`head -n 2 <<< "$GRINPROMINER_URL" | tail -n 1 | cut -f 1 -d ":" -s`
  local port2=`head -n 2 <<< "$GRINPROMINER_URL" | tail -n 1 | cut -f 2 -d ":" -s`

  [[ $GRINPROMINER_TLS -eq 1 ]] && GRINPROMINER_TLS=true || GRINPROMINER_TLS=false

  echo '<?xml version="1.0" encoding="utf-8"?>' > $MINER_CONFIG
  echo '<Config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">' >> $MINER_CONFIG
  echo '  <PrimaryConnection>' >> $MINER_CONFIG
  echo '    <ConnectionAddress>'$pool1'</ConnectionAddress>' >> $MINER_CONFIG
  echo '    <ConnectionPort>'$port1'</ConnectionPort>' >> $MINER_CONFIG
  echo '    <Ssl>'$GRINPROMINER_TLS'</Ssl>' >> $MINER_CONFIG
  echo '    <Login>'$GRINPROMINER_TEMPLATE'</Login>' >> $MINER_CONFIG
  echo '    <Password>'$GRINPROMINER_PASS'</Password>' >> $MINER_CONFIG
  echo '  </PrimaryConnection>' >> $MINER_CONFIG
  echo '  <SecondaryConnection>' >> $MINER_CONFIG
  echo '    <ConnectionAddress>'$pool2'</ConnectionAddress>' >> $MINER_CONFIG
  echo '    <ConnectionPort>'$port2'</ConnectionPort>' >> $MINER_CONFIG
  echo '    <Ssl>'$GRINPROMINER_TLS'</Ssl>' >> $MINER_CONFIG
  echo '    <Login>'$GRINPROMINER_TEMPLATE'</Login>' >> $MINER_CONFIG
  echo '    <Password>'$GRINPROMINER_PASS'</Password>' >> $MINER_CONFIG
  echo '  </SecondaryConnection>' >> $MINER_CONFIG
  echo '  <LogOptions>' >> $MINER_CONFIG
  echo '    <FileMinimumLogLevel>DEBUG</FileMinimumLogLevel>' >> $MINER_CONFIG
  echo '    <ConsoleMinimumLogLevel>DEBUG</ConsoleMinimumLogLevel>' >> $MINER_CONFIG
  echo '    <KeepDays>1</KeepDays>' >> $MINER_CONFIG
  echo '    <DisableLogging>false</DisableLogging>' >> $MINER_CONFIG
  echo '  </LogOptions>' >> $MINER_CONFIG
  [[ -z $GRINPROMINER_CPULOAD ]] && GRINPROMINER_CPULOAD=0
  echo '  <CPUOffloadValue>'$GRINPROMINER_CPULOAD'</CPUOffloadValue>' >> $MINER_CONFIG
  echo '  <GPUOptions>' >> $MINER_CONFIG

  while read -r line; do
    echo $line >> $MINER_CONFIG
  done <<< "$GRINPROMINER_USER_CONFIG"

  echo '  </GPUOptions>' >> $MINER_CONFIG
  echo '</Config>' >> $MINER_CONFIG
}
