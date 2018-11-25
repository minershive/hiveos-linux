#!/usr/bin/env bash

threads=`echo "threads" | nc -w $API_TIMEOUT localhost ${MINER_API_PORT}` #&& echo $threads
if [[ $? -ne 0  || -z $threads ]]; then
	echo -e "${YELLOW}Failed to read $miner stats from localhost:${MINER_API_PORT}${NOCOLOR}"
else
	summary=`echo "summary" | nc -w $API_TIMEOUT localhost ${MINER_API_PORT}`
#				echo $summary
	re=';UPTIME=([0-9]+);' && [[ $summary =~ $re ]] && local uptime=${BASH_REMATCH[1]} #&& echo "Matched" || echo "No match"
	#khs will calculate from cards; re=';KHS=([0-9\.]+);' && [[ $summary =~ $re ]] && khs=${BASH_REMATCH[1]} #&& echo "Matched" || echo "No match"
	local vers=`echo "$summary" | tr ';' '\n' | grep -m1 'VER=' | sed -e 's/.*=//'`
	local algo=`echo "$summary" | tr ';' '\n' | grep -m1 'ALGO=' | sed -e 's/.*=//'`
	local acc=`echo "$summary" | tr ';' '\n' | grep -m1 'ACC=' | sed -e 's/.*=//'`
	local rej=`echo "$summary" | tr ';' '\n' | grep -m1 'REJ=' | sed -e 's/.*=//'`
	local ver=`echo "$summary" | tr ';' '\n' | grep -m1 'VER=' | sed -e 's/.*=//'`
	local striplines=`echo "$threads" | tr "|" "\n" | tr ";" "\n" | tr -cd '\11\12\15\40-\176'`
	local hashes_val=(`echo "$striplines" | grep -E "H/s=" | sed -e 's/.*=//'`)
	local hashes_pre=(`echo "$striplines" | grep -E "H/s=" | sed -e 's/H.*//'`)
	local total_hs=0
	local hs=0
	local temp=0
	kilo=1000
	for (( i=0; i < ${#hashes_val[@]}; i++ )); do
		smb=${hashes_pre[$i]}
		case "$smb" in
			k) # kH/s - quark
			koef=$kilo
			;;
			M) # MH/s - blake2s
			koef=$((kilo*kilo))
			;;
			G) # GH/s - not found but who's know
			koef=$((kilo*kilo*kilo))
			;;
			*) #  H/s - yescrypt
			koef=1
			;;
		esac

		hs[$i]=`echo ${hashes_val[$i]} | awk -v koef=$koef '{print $1*koef}' | awk '{ printf("%.f",$1) }'`
		total_hs=$(($total_hs+${hs[$i]}))
		# Get CPU temp from stats and if we get 0 then get it from sysfs
		local tcore=`echo "$summary" | tr ';' '\n' | grep -m1 'TEMP=' | sed -e 's/.*=//' | awk '{printf("%.0f",$1)}'`
		if [[ -z $tcore || $tcore -eq 0 ]]; then
			local coretemp0=`cat /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp*_input 2>/dev/null`
			[[ ! -z $coretemp0 ]] && #may not work with AMD cpous
				tcore=$((`cat /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp*_input | head -n 1`/1000)) ||
				tcore=`cat /sys/class/hwmon/hwmon0/temp*_input | head -n 1 | awk '{print $1/1000}'` #maybe we will need to detect AMD cores
		fi
		temps[$i]=$tcore
	done
	# Convert total H/s to kH/s
	khs=`echo $total_hs | awk -F';' '{print $1/1000}'` #hashes to khs

	stats=$(jq -n \
		--arg vers "$vers" \
		--arg acc "$acc" --arg rej "$rej" \
		--arg uptime "$uptime" --arg algo "$algo" \
		--argjson hs "`echo ${hs[@]} | tr " " "\n" | jq -cs '.'`" \
		--argjson temp "`echo ${temps[@]} | tr " " "\n" | jq -cs '.'`" \
		--arg ver "$ver" \
		'{$vers, $algo, $hs, ar: [$acc, $rej], $temp, $uptime, $ver}')
fi
