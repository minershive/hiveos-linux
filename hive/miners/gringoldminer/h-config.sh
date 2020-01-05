#!/usr/bin/env bash

function miner_fork() {
	local MINER_FORK=$GRINGOLDMINER_FORK
	[[ -z $MINER_FORK ]] && MINER_FORK=$MINER_DEFAULT_FORK
	echo $MINER_FORK
}

function miner_ver() {
  local MINER_VER=$GRINGOLDMINER_VER
  local fork=`miner_fork`
  fork=${fork^^} #uppercase MINER_FORK
	[[ -z $MINER_VER ]] && eval "MINER_VER=\$MINER_LATEST_VER_${fork//-/_}" #char replace
	echo $MINER_VER
}


function miner_config_echo() {
  local MINER_VER=`miner_ver`
	local MINER_FORK=`miner_fork`
  miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_FORK/$MINER_VER/config.xml"
}

function miner_config_gen() {

  local MINER_CONFIG="$MINER_DIR/$MINER_FORK/$MINER_VER/config.xml"
  mkfile_from_symlink $MINER_CONFIG

  [[ -z $GRINGOLDMINER_TEMPLATE ]] && echo -e "${YELLOW}GRINGOLDMINER_TEMPLATE is empty${NOCOLOR}" && return 1
  [[ -z $GRINGOLDMINER_URL ]] && echo -e "${YELLOW}GRINGOLDMINER_URL is empty${NOCOLOR}" && return 1
  [[ -z $MINER_CONFIG ]] && echo -e "${RED}No MINER_CONFIG is set${NOCOLOR}" && return 1
  [[ -z $MINER_LOG_BASENAME ]] && echo -e "${RED}No MINER_LOG_BASENAME is set${NOCOLOR}" && exit 1

  local pool1=`head -n 1 <<< "$GRINGOLDMINER_URL" | cut -f 1 -d ":" -s`
  local port1=`head -n 1 <<< "$GRINGOLDMINER_URL" | cut -f 2 -d ":" -s`
  local pool2=`head -n 2 <<< "$GRINGOLDMINER_URL" | tail -n 1 | cut -f 1 -d ":" -s`
  local port2=`head -n 2 <<< "$GRINGOLDMINER_URL" | tail -n 1 | cut -f 2 -d ":" -s`

  [[ $GRINGOLDMINER_TLS -eq 1 ]] && GRINGOLDMINER_TLS=true || GRINGOLDMINER_TLS=false

  echo '<?xml version="1.0" encoding="utf-8"?>' > $MINER_CONFIG
  echo '<Config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">' >> $MINER_CONFIG
  echo '  <PrimaryConnection>' >> $MINER_CONFIG
  echo '    <ConnectionAddress>'$pool1'</ConnectionAddress>' >> $MINER_CONFIG
  echo '    <ConnectionPort>'$port1'</ConnectionPort>' >> $MINER_CONFIG
  echo '    <Ssl>'$GRINGOLDMINER_TLS'</Ssl>' >> $MINER_CONFIG
  echo '    <Login>'$GRINGOLDMINER_TEMPLATE'</Login>' >> $MINER_CONFIG
  echo '    <Password>'$GRINGOLDMINER_PASS'</Password>' >> $MINER_CONFIG
  echo '  </PrimaryConnection>' >> $MINER_CONFIG
  echo '  <SecondaryConnection>' >> $MINER_CONFIG
  echo '    <ConnectionAddress>'$pool2'</ConnectionAddress>' >> $MINER_CONFIG
  echo '    <ConnectionPort>'$port2'</ConnectionPort>' >> $MINER_CONFIG
  echo '    <Ssl>'$GRINGOLDMINER_TLS'</Ssl>' >> $MINER_CONFIG
  echo '    <Login>'$GRINGOLDMINER_TEMPLATE'</Login>' >> $MINER_CONFIG
  echo '    <Password>'$GRINGOLDMINER_PASS'</Password>' >> $MINER_CONFIG
  echo '  </SecondaryConnection>' >> $MINER_CONFIG
  echo '  <LogOptions>' >> $MINER_CONFIG
  echo '    <FileMinimumLogLevel>ERROR</FileMinimumLogLevel>' >> $MINER_CONFIG
  echo '    <ConsoleMinimumLogLevel>DEBUG</ConsoleMinimumLogLevel>' >> $MINER_CONFIG
  echo '  </LogOptions>' >> $MINER_CONFIG
  [[ -z $GRINGOLDMINER_CPULOAD ]] && GRINGOLDMINER_CPULOAD=0
  echo '  <CPUOffloadValue>'$GRINGOLDMINER_CPULOAD'</CPUOffloadValue>' >> $MINER_CONFIG
  echo '  <GPUOptions>' >> $MINER_CONFIG

  if [[ -z $GRINGOLDMINER_USER_CONFIG ]]; then
    #autogeneration for all available cards
    if [[ $(gpu-detect NVIDIA) -gt 0 ]]; then
      if [[ $(gpu-detect AMD) -gt 0 ]]; then
      #mix rig
        #Nvidia
        for (( i=0; i < $(gpu-detect NVIDIA); i++ )); do
          echo '    <GPUOption>' >> $MINER_CONFIG
          echo '      <GPUName>Nvidia_'$i'</GPUName>' >> $MINER_CONFIG
          echo '      <GPUType>NVIDIA</GPUType>' >> $MINER_CONFIG
          echo '      <DeviceID>'$i'</DeviceID>' >> $MINER_CONFIG
          echo '      <PlatformID>0</PlatformID>' >> $MINER_CONFIG
          echo '      <Enabled>true</Enabled>' >> $MINER_CONFIG
          echo '    </GPUOption>' >> $MINER_CONFIG
        done
        #AMD
        for (( i=0; i < $(gpu-detect AMD); i++ )); do
          echo '    <GPUOption>' >> $MINER_CONFIG
          echo '      <GPUName>AMD'$i'</GPUName>' >> $MINER_CONFIG
          echo '      <GPUType>AMD</GPUType>' >> $MINER_CONFIG
          echo '      <DeviceID>'$i'</DeviceID>' >> $MINER_CONFIG
          echo '      <PlatformID>1</PlatformID>' >> $MINER_CONFIG
          echo '      <Enabled>true</Enabled>' >> $MINER_CONFIG
          echo '    </GPUOption>' >> $MINER_CONFIG
        done
      else
      #Nvidia only
        for (( i=0; i < $(gpu-detect NVIDIA); i++ )); do
          echo '    <GPUOption>' >> $MINER_CONFIG
          echo '      <GPUName>Nvidia_'$i'</GPUName>' >> $MINER_CONFIG
          echo '      <GPUType>NVIDIA</GPUType>' >> $MINER_CONFIG
          echo '      <DeviceID>'$i'</DeviceID>' >> $MINER_CONFIG
          echo '      <PlatformID>0</PlatformID>' >> $MINER_CONFIG
          echo '      <Enabled>true</Enabled>' >> $MINER_CONFIG
          echo '    </GPUOption>' >> $MINER_CONFIG
        done
      fi
    else
    #AMD only
      for (( i=0; i < $(gpu-detect AMD); i++ )); do
        echo '    <GPUOption>' >> $MINER_CONFIG
        echo '      <GPUName>AMD_'$i'</GPUName>' >> $MINER_CONFIG
        echo '      <GPUType>AMD</GPUType>' >> $MINER_CONFIG
        echo '      <DeviceID>'$i'</DeviceID>' >> $MINER_CONFIG
        echo '      <PlatformID>0</PlatformID>' >> $MINER_CONFIG
        echo '      <Enabled>true</Enabled>' >> $MINER_CONFIG
        echo '    </GPUOption>' >> $MINER_CONFIG
      done
    fi
  else
    #using user config
    while read -r line; do
      echo $line >> $MINER_CONFIG
    done <<< "$GRINGOLDMINER_USER_CONFIG"
  fi

  echo '  </GPUOptions>' >> $MINER_CONFIG
  echo '</Config>' >> $MINER_CONFIG
}
