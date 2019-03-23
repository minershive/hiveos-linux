#!/usr/bin/env bash

	threads=`echo "threads" | nc -w $API_TIMEOUT localhost ${MINER_API_PORT}` #&& echo $threads
	if [[ $? -ne 0  || -z $threads ]]; then
		echo -e "${YELLOW}Failed to read $miner stats from localhost:${MINER_API_PORT}${NOCOLOR}"
	else
		summary=`echo "summary" | nc -w $API_TIMEOUT localhost ${MINER_API_PORT}`
		re=';UPTIME=([0-9]+);' && [[ $summary =~ $re ]] && local uptime=${BASH_REMATCH[1]} #&& echo "Matched" || echo "No match"

		local ac=`echo "$summary" | tr ';' '\n' | grep -m1 'ACC=' | sed -e 's/.*=//'`
		local rj=`echo "$summary" | tr ';' '\n' | grep -m1 'REJ=' | sed -e 's/.*=//'`
		local ver=`echo "$summary" | tr ';' '\n' | grep -m1 'VER=' | sed -e 's/.*=//'`
		#stats=`echo $threads | tr '|' '\n' | tr ';' '\n' | tr -cd '\11\12\15\40-\176' | grep -E 'KHS=' | sed -e 's/.*=//' | jq -cs '{khs:.}'`
		striplines=`echo "$threads" | tr '|' '\n' | tr ';' '\n' | tr -cd '\11\12\15\40-\176'`

		#if GPU has 0.0 temp it hanged. ccminer does not mine on this card but shows hashrate
		cctemps=(`echo "$striplines" | grep 'TEMP=' | sed -e 's/.*=//'`) #echo ${cctemps[@]} | tr " " "\n" #print it in lines
		cckhs=(`echo "$striplines" | grep 'KHS=' | sed -e 's/.*=//'`)
		ccbusids=(`echo "$striplines" | grep 'BUS=' | sed -e 's/.*=//'`)


		#local nvidiastats
		for (( i=0; i < ${#cckhs[@]}; i++ )); do
			#if temp is 0 then driver or GPU failed
			[[ ${cctemps[$i]} == "0.0" ]] && cckhs[$i]="0.0"

			#cckhs[$i]="84316579.94" #test
			#check Ghs. 1080ti gives ~64mh (64000kh) on lyra. when it's showing ghs then load is 0 on gpu
			#if [[ `echo ${cckhs[$i]} | awk '{ print ($1 >= 1000000) ? 1 : 0 }'` == 1 ]]; then #hash is in Ghs, >= 1000000 khs
			if [[ `echo ${cckhs[$i]} | awk '{ print ($1 >= 1000) ? 1 : 0 }'` == 1 ]]; then # > 1Mh
			#[[ -z $nvidiastats ]] && nvidiastats=`gpu-stats nvidia` #a bit overhead in calling nvidia-smi again
				local busid=`echo ${ccbusids[$i]} | awk '{ printf("%02x:00.0", $1) }'` #ccbus is decimal
				local load_i=`echo "$gpu_stats" | jq ".busids|index(\"$busid\")"`
				if [[ $load_i != "null" ]]; then #can be null on failed driver
					local load=`echo "$gpu_stats" | jq -r ".load[$load_i]"`
					#load=0 #test
					[[ -z $load || $load -le 10 ]] &&
						echo -e "${RED}Hash on GPU$i is in GH/s (${cckhs[$i]} kH/s) but Load is detected to be only $load%${NOCOLOR}" &&
						cckhs[$i]="0.0"
				fi
			fi

     #khs=`echo $khs ${cckhs[$i]} | awk '{ printf("%.3f", $1 + $2) }'`
			khs=`echo $khs ${cckhs[$i]} | awk '{ printf("%.3f", $1 + $2) }'`
		done

		khs=`echo $khs | sed -E 's/^( *[0-9]+\.[0-9]([0-9]*[1-9])?)0+$/\1/'` #1234.100 -> 1234.1
		hs=''

		stats=$(jq -n \
				--arg uptime "$uptime" --arg algo "$CRYPTODREDGE_ALGO" \
				--argjson hs "`echo ${cckhs[@]} | tr " " "\n" | jq -cs '.'`" \
				--argjson temp "`echo ${cctemps[@]} | tr " " "\n" | jq -cs '.'`" \
				--argjson fan "`echo \"$striplines\" | grep 'FAN=' | sed -e 's/.*=//' | jq -cs '.'`" \
				--arg ac "$ac" --arg rj "$rj" \
				--argjson bus_numbers "`echo ${ccbusids[@]} | tr " " "\n" | jq -cs '.'`" \
				--arg ver "$ver" \
				'{$hs, $temp, $fan, $uptime, $algo, ar: [$ac, $rj], $bus_numbers, $ver}')
	fi

	[[ -z $khs ]] && khs=0
	[[ -z $stats ]] && stats="null"
