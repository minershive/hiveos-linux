#!/usr/bin/env bash

function miner_ver() {
	local MINER_VER=$FINMINER_VER
	[[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
	echo $MINER_VER
}

function miner_config_echo() {
	local MINER_VER=`miner_ver`
	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/config.xml"
}

function miner_config_gen() {

  #for correct uptime calulation
  [[ -f /home/user/fah/config.xml ]] && rm /home/user/fah/config.xml

  local MINER_CONFIG="$MINER_DIR/$MINER_VER/config.xml"
  mkfile_from_symlink $MINER_CONFIG

  echo "<config>" > $MINER_CONFIG
  echo "  <!-- Client Control -->" >> $MINER_CONFIG
  echo "  <fold-anon v='true'/>" >> $MINER_CONFIG
  echo "  <core-dir v='/home/user/fah/' />" >> $MINER_CONFIG
  echo "  <data-directory v='/home/user/fah/' />" >> $MINER_CONFIG

  echo "  <!-- Folding Core -->" >> $MINER_CONFIG
  [[ ! -z $FAH_CPU_USAGE ]] && echo "  <cpu-usage v='$FAH_CPU_USAGE' />" >> $MINER_CONFIG
  [[ ! -z $FAH_GPU_USAGE ]] && echo "  <gpu-usage v='$FAH_GPU_USAGE' />" >> $MINER_CONFIG

  echo "  <!-- Slot Control -->" >> $MINER_CONFIG
  echo "  <power v='full'/>" >> $MINER_CONFIG

  echo "  <!-- Logging -->" >> $MINER_CONFIG
  echo "  <log v='$MINER_LOG_BASENAME.log' />" >> $MINER_CONFIG
  echo "  <log-color v='false' />" >> $MINER_CONFIG
  echo "  <log-rotate v='false' />" >> $MINER_CONFIG
  echo "  <log-truncate v='true' />" >> $MINER_CONFIG

  echo "  <!-- User Information -->" >> $MINER_CONFIG
  [[ ! -z $FAH_TEAM ]] && echo "  <team v='$FAH_TEAM'/>" >> $MINER_CONFIG
  [[ ! -z $FAH_USER ]] && echo "  <user v='$FAH_USER'/>" >> $MINER_CONFIG
  [[ ! -z $FAH_PASS ]] && echo "  <passkey v='$FAH_PASS'/>" >> $MINER_CONFIG

  local i-0; local j=0
  local line=

  echo "  <!-- Folding Slots -->" >> $MINER_CONFIG

  if [[ $FAH_CUDA -eq 1 ]]; then
    if [[ ! -z $FAH_CUDA_CONFIG ]]; then
      while read -r line; do
        [[ -z $line ]] && continue
        echo $line >> $MINER_CONFIG
        [[ $line =~ "slot id=" ]] && ((j++))
      done <<< "$FAH_CUDA_CONFIG"
    else
      for (( i=0; i < $(gpu-detect NVIDIA); i++ )); do
        echo "  <slot id='$j' type='GPU'/>" >> $MINER_CONFIG
        ((j++))
      done
    fi
  fi

  if [[ $FAH_OPENCL -eq 1 ]]; then
    if [[ ! -z $FAH_OPENCL_CONFIG ]]; then
      while read -r line; do
        [[ -z $line ]] && continue
        echo $line >> $MINER_CONFIG
        [[ $line =~ "slot id=" ]] && ((j++))
      done <<< "$FAH_OPENCL_CONFIG"
    else
      for (( i=0; i < $(gpu-detect AMD); i++ )); do
        echo "  <slot id='$j' type='GPU'/>" >> $MINER_CONFIG
        ((j++))
      done
    fi
  fi

  if [[ $FAH_CPU -eq 1 ]]; then
    if [[ ! -z $FAH_CPU_CONFIG ]]; then
      while read -r line; do
        [[ -z $line ]] && continue
        echo $line >> $MINER_CONFIG
      done <<< "$FAH_CPU_CONFIG"
    else
      echo "  <slot id='$j' type='CPU'/>" >> $MINER_CONFIG
      ((j++))
    fi
  fi

  echo "</config>" >> $MINER_CONFIG


}
