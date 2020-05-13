#!/usr/bin/env bash

if [[ -z $OCTOFAN ]]; then #reread env variables as after upgrade this can be empty
  source /hive/etc/environment
fi

$OCTOFAN get_temp_json | jq -r '.[0]' #rig intake temp

#/hive/sbin/cpu-temp

exit 0
