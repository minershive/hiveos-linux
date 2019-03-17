#!/usr/bin/env bash

#######################
# Functions
#######################

get_hs(){
  echo \$$2 | tr "|" "\n" | grep Gpu$1 | awk 'NF>1{print $NF}'
}

get_cards_hashes(){
  local str=
  local mhs=0
  hs=(0)
  for (( i=0; i < ${gpu_count}; i++ )); do
    let "pos= 5 + ($i * 3)"
    #2019-03-17 01:10:40 Gpu0 (Ellesmere): 744.7 | Gpu1 (Ellesmere): 743.4 | Gpu2 (Ellesmere): 746.8 | Gpu3 (Ellesmere): 666.0 | Gpu4 (Ellesmere): 633.1 |  (MH/s)
    str=`cat $log_name | tail -n 50 | grep "Gpu$i " | tail -n 1`
    mhs=`get_hs $i "$str"`
    hs[$i]=`echo $mhs | awk '{ printf("%.d",$1*1000) }'`
  done
}

get_miner_uptime(){
  local a=0
  let a=`stat --format='%Y' $log_name`-`stat --format='%Y' $conf_name`
  echo $a
}

get_total_hashes(){
  #2019-03-17 01:18:41 [STATUS] Total HashRate: 3.53 GH/s - Uptime 00:26:18. Ver 4.0.100L
  cat ${log_name} | tail -n 50 | grep "Total HashRate:" | tail -n 1 | cut -d " " -f6 | awk '{printf "%.f",$1*1000000}'
}

get_miner_ver(){
  #2019-03-17 01:18:41 [STATUS] Total HashRate: 3.53 GH/s - Uptime 00:26:18. Ver 4.0.100L
  cat ${log_name} | tail -n 50 | grep "Total HashRate:" | tail -n 1 | cut -d " " -f12
}

get_log_time_diff(){
  local a=0
  let a=`date +%s`-`stat --format='%Y' $log_name`
  echo $a
}

#######################
# MAIN script body
#######################

[[ -z $GPU_COUNT_NVIDIA ]] &&
  GPU_COUNT_NVIDIA=`gpu-detect NVIDIA`
[[ -z $GPU_COUNT_AMD ]] &&
  GPU_COUNT_AMD=`gpu-detect AMD`

gpu_count=`expr $GPU_COUNT_NVIDIA + $GPU_COUNT_AMD`

log_name="$MINER_LOG_BASENAME.log"
conf_name="/hive/miners/$MINER_NAME/`miner_ver`/miner.cfg"

diffTime=$(get_log_time_diff)
maxDelay=250

# If log is fresh the calc miner stats or set to null if not
# if [ "$diffTime" -lt "$maxDelay" ]; then
if [ "$diffTime" -lt "$maxDelay" ]; then
  get_cards_hashes
  hs_units='khs'
  uptime=$(get_miner_uptime)
  algo="sha224"

  # A/R shares by pool
  ac=`cat $log_name | tail -n 50 | grep " Ok Shares " | tail -n 1 | cut -d " " -f12`
  rj=0 #no rejected shares at current version

  stats=$(jq -nc \
            --argjson hs "`echo ${hs[@]} | tr " " "\n" | jq -cs '.'`" \
            --arg hs_units "$hs_units" \
            --arg uptime "$uptime" \
            --arg ac "$ac" --arg rj "$rj" \
            --arg algo "$algo" \
            --arg ver `get_miner_ver` \
            '{$hs, $hs_units, $uptime, ar: [$ac, $rj], $algo, $ver}')
  #total hashrate in khs
  khs=$(get_total_hashes)
else
  stats=""
  khs=0
fi

# debug output

#echo stats: $stats
#echo khs:   $khs
