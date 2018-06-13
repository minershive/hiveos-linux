#!/usr/bin/env bash

function miner_stats {
	local miner=$1
	local mindex=$2 #empty or 2

	khs=0
	stats=
	case $miner in
		claymore)
			stats=`echo '{"id":0,"jsonrpc":"2.0","method":"miner_getstat2"}' | nc -w $API_TIMEOUT localhost 3333 | jq '.result'`
			if [[ $? -ne 0  || -z $stats ]]; then
				echo -e "${YELLOW}Failed to read $miner stats from localhost:3333${NOCOLOR}"
			else
				#[ "10.0 - ETH", "83", "67664;48;0", "28076;27236;12351", "891451;29;0", "421143;408550;61758", "67;40;70;45;69;34", "eth-eu1.nanopool.org:9999;sia-eu1.nanopool.org:7777", "0;0;0;0" ]
				khs=`echo $stats | jq -r '.[2]' | awk -F';' '{print $1}'`
				[[ -z $CLAYMORE_VER ]] && CLAYMORE_VER="latest"
				algo=`cat /hive/claymore/$CLAYMORE_VER/config.txt | grep -m1 --text "^\-dcoin" | sed 's/-dcoin //'`
				stats=`echo "$stats" "[\"$algo\"]" | jq -s '.[0] + .[1]'` # push algo to end of array
			fi
		;;
		claymore-x)
			stats=`echo '{"id":0,"jsonrpc":"2.0","method":"miner_getstat1"}' | nc -w $API_TIMEOUT localhost 3337 | jq '.result'`
			if [[ $? -ne 0  || -z $stats ]]; then
				echo -e "${YELLOW}Failed to read $miner stats from localhost:3337${NOCOLOR}"
			else
				khs=`echo $stats | jq -r '.[2]' | awk -F';' '{print $1/1000}'` #sols to khs
			fi
		;;
		claymore-z)
			stats=`echo '{"id":0,"jsonrpc":"2.0","method":"miner_getstat1"}' | nc -w $API_TIMEOUT localhost 3335 | jq '.result'`
			if [[ $? -ne 0  || -z $stats ]]; then
				echo -e "${YELLOW}Failed to read $miner stats from localhost:3335${NOCOLOR}"
			else
				khs=`echo $stats | jq -r '.[2]' | awk -F';' '{print $1/1000}'` #sols to khs
			fi
		;;
		ewbf)
			#0000:03:00.0, .result[].busid[5:] trims first 5 chars
			#stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://localhost:42000/getstat`
			#curl uses http_proxy env var, we don't need it. --noproxy does not work
			stats_raw=`echo "GET /getstat" | nc -w $API_TIMEOUT localhost 42000 | tail -n 1`
			if [[ $? -ne 0  || -z $stats_raw ]]; then
				echo -e "${YELLOW}Failed to read $miner stats from localhost:42000${NOCOLOR}"
			else
				khs=`echo $stats_raw | jq -r '.result[].speed_sps' | awk '{s+=$1} END {print s/1000}'` #sum up and convert to khs
				local ac=$(jq '[.result[].accepted_shares] | add' <<< "$stats_raw")
				local rj=$(jq '[.result[].rejected_shares] | add' <<< "$stats_raw")
				stats=$(jq -c --arg ac "$ac" --arg rj "$rj" \
					'{speed_sps: [.result[].speed_sps], busid: [.result[].busid[5:]|ascii_downcase], start_time:
					.result[0].start_time, ar: [$ac, $rj]}' <<< "$stats_raw")
			fi
		;;
		ccminer)
			threads=`echo "threads" | nc -w $API_TIMEOUT localhost 4068` #&& echo $threads
			if [[ $? -ne 0  || -z $threads ]]; then
				echo -e "${YELLOW}Failed to read $miner stats from localhost:4068${NOCOLOR}"
			else
				summary=`echo "summary" | nc -w 2 localhost 4068`
				re=';UPTIME=([0-9]+);' && [[ $summary =~ $re ]] && local uptime=${BASH_REMATCH[1]} #&& echo "Matched" || echo "No match"
				#khs will calculate from cards; re=';KHS=([0-9\.]+);' && [[ $summary =~ $re ]] && khs=${BASH_REMATCH[1]} #&& echo "Matched" || echo "No match"
				algo=`echo "$summary" | tr ';' '\n' | grep -m1 'ALGO=' | sed -e 's/.*=//'`
				local ac=`echo "$summary" | tr ';' '\n' | grep -m1 'ACC=' | sed -e 's/.*=//'`
				local rj=`echo "$summary" | tr ';' '\n' | grep -m1 'REJ=' | sed -e 's/.*=//'`
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

				stats=$(jq -n \
					--arg uptime "$uptime", --arg algo "$algo" \
					--argjson khs "`echo ${cckhs[@]} | tr " " "\n" | jq -cs '.'`" \
					--argjson temp "`echo ${cctemps[@]} | tr " " "\n" | jq -cs '.'`" \
					--argjson fan "`echo \"$striplines\" | grep 'FAN=' | sed -e 's/.*=//' | jq -cs '.'`" \
					--arg ac "$ac" --arg rj "$rj" \
					'{$khs, $temp, $fan, $uptime, $algo, ar: [$ac, $rj]}')
			fi
		;;
		ethminer)
			stats_raw=`echo '{"id":0,"jsonrpc":"2.0","method":"miner_getstat1"}' | nc -w $API_TIMEOUT localhost 3334 | jq '.result'`
			if [[ $? -ne 0  || -z $stats_raw ]]; then
				echo -e "${YELLOW}Failed to read $miner stats_raw from localhost:3334${NOCOLOR}"
			else
				khs=`echo $stats_raw | jq -r '.[2]' | awk -F';' '{print $1}'`
				#`echo $stats_raw | jq -r '.[3]' | awk 'gsub(";", "\n")' | jq -cs .` #send only hashes
				local tempfans=`echo $stats_raw | jq -r '.[6]'` #"56;26; 48;42"
				local temp=()
				local fan=()
				for tf in $tempfans; do
					temp+=(`echo $tf | awk -F';' '{print $1}'`)
					fan+=(`echo $tf | awk -F';' '{print $2}'`)
				done
				temp=`printf '%s\n' "${temp[@]}" | jq --raw-input . | jq --slurp -c .`
				fan=`printf '%s\n' "${fan[@]}" | jq --raw-input . | jq --slurp -c .`

				#ethminer API can show hashes, but no load... hard to fix it here
				#local hs=(`echo "$stats_raw" | jq -r '.[3]' | tr ';' ' '`)
				#echo ${hs[0]}

				local hs=`echo "$stats_raw" | jq -r '.[3]' | tr ';' '\n' | jq -cs '.'`

				local ac=`echo $stats_raw | jq -r '.[2]' | awk -F';' '{print $2}'`
				local rj=`echo $stats_raw | jq -r '.[2]' | awk -F';' '{print $3}'`

				stats=$(jq -n \
					--arg uptime "`echo \"$stats_raw\" | jq -r '.[1]' | awk '{print $1*60}'`" \
					--argjson hs "$hs" --argjson temp "$temp" --argjson fan "$fan" \
					--arg ac "$ac" --arg rj "$rj" \
					'{$hs, $temp, $fan, $uptime, ar: [$ac, $rj]}')
			fi
		;;
		sgminer-gm)
			stats_raw=`echo '{"command":"summary+devs"}' | nc -w $API_TIMEOUT localhost 4028`
			if [[ $? -ne 0 || -z $stats_raw ]]; then
				echo -e "${YELLOW}Failed to read $miner from localhost:4028${NOCOLOR}"
			else
				khs=`echo $stats_raw | jq '.["summary"][0]["SUMMARY"][0]["KHS 15s"]'`
				stats=`echo $stats_raw | jq '{khs: [.devs[0].DEVS[]."KHS 15s"], temp: [.devs[0].DEVS[].Temperature], \
						fan: [.devs[0].DEVS[]."Fan Percent"], uptime: .summary[0].SUMMARY[0].Elapsed, algo: "'$SGMINER_GM_ALGO'"}'`
			fi
		;;
		dstm)
			stats_raw=`echo '{"id":1, "method":"getstat"}' | nc -w $API_TIMEOUT localhost 43000`
			if [[ $? -ne 0 || -z $stats_raw ]]; then
				echo -e "${YELLOW}Failed to read $miner from localhost:43000${NOCOLOR}"
			else
				khs=`echo $stats_raw | jq '.result[].sol_ps' | awk '{s+=$1} END {print s/1000}'`
				local uptime=$(( `date +%s` - $(stat -c%X /proc/`pidof zm`) )) #dont think zm will die so soon after getting stats
				#todo: use gpu_stats if busid is known
				#local nvidiastats=`gpu-stats nvidia` #a bit overhead in calling nvidia-smi again, shame on dstm, he gives no temps
				#stats=`echo $stats_raw | jq '{ hs: [.result[].sol_ps], temp: [.result[].temperature], uptime: "'$uptime'"}'`
				#stats=$(jq '{ hs: [.result[].sol_ps], uptime: "'$uptime'"}' <<< $stats_raw)
				#stats=$(jq -s '.[0] * .[1]' <<< "$stats $nvidiastats")
				local fan=$(jq -c "[.fan$nvidia_indexes_array]" <<< $gpu_stats)
				local temp=$(jq -c "[.temp$nvidia_indexes_array]" <<< $gpu_stats)
				local ac=`echo $stats_raw | jq '[.result[].accepted_shares] | add'`
				local rj=`echo $stats_raw | jq '[.result[].rejected_shares] | add'`
				stats=$(jq --argjson temp "$temp" --argjson fan "$fan" --arg uptime "$uptime" --arg ac "$ac" --arg rj "$rj" \
					'{ hs: [.result[].sol_ps], $temp, $fan, $uptime, ar: [$ac, $rj] }' <<< "$stats_raw")
			fi
		;;
		bminer) #@see https://www.bminer.me/references/
			stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:1880/api/status`
			if [[ $? -ne 0 || -z $stats_raw ]]; then
				echo -e "${YELLOW}Failed to read $miner from localhost:1880${NOCOLOR}"
			else
				#fucking bminer sorts it's keys as numerics, not natual, e.g. "1", "10", "11", "2", fix that with sed hack by replacing "1":{ with "01":{
				stats_raw=$(echo "$stats_raw" | sed -E 's/"([0-9])":\s*\{/"0\1":\{/g' | jq -c --sort-keys .)

				khs=`echo $stats_raw | jq '.miners[].solver.solution_rate' | awk '{s+=$1} END {print s/1000}'`
				##bminer did not report fans and uptime before 5.5.0
				##local uptime=$(( `date +%s` - $(stat -c%X /proc/`pidof bminer | awk '{print $1}'`) )) #in seconds
				##local temp=$(jq -c "[.temp$nvidia_indexes_array]" <<< $gpu_stats)
				##local fan=$(jq -c "[.fan$nvidia_indexes_array]" <<< $gpu_stats)

				local uptime=$(( `date +%s` - $(jq '.start_time' <<< "$stats_raw") ))
				#local temp=$(jq -c '[.miners[].device.temperature]' <<< "$stats_raw")
				#local fan=$(jq -c '[.miners[].device.fan_speed]' <<< "$stats_raw")
				#local hs=$(jq -c "[.miners[].solver.solution_rate]" <<< "$stats_raw")
				#stats=$(jq --argjson fan "$fan" --arg uptime "$uptime" '{hs: [.miners[].solver.solution_rate], temp: [.miners[].device.temperature], $fan, $uptime}' <<< $stats_raw)
				#--argjson hs "$hs" --argjson temp "$temp" --argjson fan "$fan"
				stats=$(jq -c --arg uptime "$uptime" \
					'{hs: [.miners[].solver.solution_rate],
							temp: [.miners[].device.temperature], fan: [.miners[].device.fan_speed], $uptime,
							ar: [.stratum.accepted_shares, .stratum.rejected_shares]}' <<< "$stats_raw")
			fi
		;;
		lolminer)
			stats_raw=`/hive/lolminer/lolHelper`
			if [[ $? -ne 0 || -z $stats_raw ]]; then
				echo -e "${YELLOW}Failed to read $miner from lolHelper${NOCOLOR}"
			else
				local platform=`tac /hive/lolminer/pool.cfg | grep -m1 "^\-\-platform" | awk '{print toupper($2)}'`
				khs=`echo $stats_raw | jq '.result[].sol_ps' | awk '{s+=$1} END {print s/1000}'`
				local uptime=$(( `date +%s` - $(stat -c%X /proc/`pidof lolMiner-mnx`) ))
				local fan='[]'
				local temp='[]'
				if [[ $platform = 0 || ($platform = "AUTO" && $amd_indexes_array != "[]") ]]; then #AMD
					fan=$(jq -c "[.fan$amd_indexes_array]" <<< $gpu_stats)
					temp=$(jq -c "[.temp$amd_indexes_array]" <<< $gpu_stats)
				elif [[ $platform = 1 || ($platform = "AUTO" && $nvidia_indexes_array != "[]") ]]; then #Nvidia
					fan=$(jq -c "[.fan$nvidia_indexes_array]" <<< $gpu_stats)
					temp=$(jq -c "[.temp$nvidia_indexes_array]" <<< $gpu_stats)
				fi
				stats=$(jq --argjson temp "$temp" --argjson fan "$fan" --arg uptime "$uptime" '{ hs: [.result[].sol_ps], $temp, $fan, $uptime}' <<< $stats_raw)
			fi
		;;
		optiminer)
			stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://localhost:52749`
			if [[ $? -ne 0 || -z $stats_raw ]]; then
				echo -e "${YELLOW}Failed to read $miner from localhost:52749${NOCOLOR}"
			else
				#optiminer sorts it's keys incorrectly, e.g. "GPU1", "GPU10", "GPU2", fixing that with sed hack by replacing "1":{ with "01":{
				stats_raw=$(echo "$stats_raw" | sed -E 's/"GPU([0-9])"/"GPU0\1"/g' | jq -c --sort-keys .)
				khs=`echo $stats_raw | jq '.solution_rate.Total."60s"' | awk '{print $1/1000}'`
				local uptime=`echo $stats_raw | jq '.uptime'`
				local hs=$(jq -c '[.solution_rate[]."60s"]' <<< "$stats_raw" | sed -E "s/^(\[.*)(,[0-9]+\.[0-9]+)]$/\1]/")
				[[ -z $OPTIMINER_ALGORITHM ]] && OPTIMINER_ALGORITHM="equihash96_5"

				#TODO: check on mixed rig, maybe amd first, then nvidia
				local temp=$(jq '.temp' <<< $gpu_stats)
				local fan=$(jq '.fan' <<< $gpu_stats)
				[[ $cpu_indexes_array != '[]' ]] && #remove Internal Gpus
					temp=$(jq -c "del(.$cpu_indexes_array)" <<< $temp) &&
					fan=$(jq -c "del(.$cpu_indexes_array)" <<< $fan)

				stats=$(jq -nc --arg algo "$OPTIMINER_ALGORITHM" --argjson hs "$hs" --argjson temp "$temp" --argjson fan "$fan" --arg uptime "$uptime" '{$algo, $hs, $temp, $fan, $uptime}')
			fi
		;;
		xmr-stak)
			stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:60045/api.json`
			#echo $stats_raw | jq .
			if [[ $? -ne 0 || -z $stats_raw ]]; then
				echo -e "${YELLOW}Failed to read $miner from localhost:60045${NOCOLOR}"
			else
				khs=`echo $stats_raw | jq -r '.hashrate.total[0]' | awk '{print $1/1000}'`
				local cpu_temp=`cat /sys/class/hwmon/hwmon0/temp*_input | head -n $(nproc) | awk '{print $1/1000}' | jq -rsc .` #just a try to get CPU temps
				local gpus_disabled=
				(head -n 40 /var/log/miner/xmr-stak/xmr-stak.log | grep -q "WARNING: backend AMD (OpenCL) disabled") && #AMD disabled found
				(head -n 40 /var/log/miner/xmr-stak/xmr-stak.log | grep -q "WARNING: backend NVIDIA disabled") && #and nvidia disabled
				gpus_disabled=1
				#local amd_on=$(head /hive/xmr-stak/xmr-stak.log | grep -q -E "WARNING: backend (NVIDIA|AMD) disabled")
				if [[ $gpus_disabled == 1 ]]; then #gpus disabled
					local temp='[]'
					local fan='[]'
				else
					local temp=$(jq '.temp' <<< $gpu_stats)
					local fan=$(jq '.fan' <<< $gpu_stats)
					[[ $cpu_indexes_array != '[]' ]] && #remove Internal Gpus
						temp=$(jq -c "del(.$cpu_indexes_array)" <<< $temp) &&
						fan=$(jq -c "del(.$cpu_indexes_array)" <<< $fan)
				fi
				#temp=$(jq -sc '.[0] + .[1]'  <<< "$temp $cpu_temp")
				#fan=$(jq -sc '.[0] + .[1]'  <<< "$fan [-1]")
				local ac=$(jq '.results.shares_good' <<< "$stats_raw")
				local rj=$(( $(jq '.results.shares_total' <<< "$stats_raw") - $ac ))
				stats=$(jq --argjson temp "$temp" --argjson fan "$fan" --argjson cpu_temp "$cpu_temp" --arg ac "$ac" --arg rj "$rj" \
					'{hs: [.hashrate.threads[][0]], $temp, $fan, $cpu_temp, uptime: .connection.uptime, ar: [$ac, $rj]}' <<< "$stats_raw")
			fi
		;;
		xmrig)
			stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:60050`
			#echo $stats_raw | jq .
			if [[ $? -ne 0 || -z $stats_raw ]]; then
				echo -e "${YELLOW}Failed to read $miner from localhost:60050${NOCOLOR}"
			else
				khs=`echo $stats_raw | jq -r '.hashrate.total[0]' | awk '{print $1/1000}'`
				local cpu_temp=`cat /sys/class/hwmon/hwmon0/temp*_input | head -n $(nproc) | awk '{print $1/1000}' | jq -rsc .` #just a try to get CPU temps
				stats=`echo $stats_raw | jq '{hs: [.hashrate.threads[][0]], temp: '$cpu_temp', uptime: .connection.uptime}'`
			fi
		;;
		cpuminer-opt)
			threads=`echo "threads" | nc -w $API_TIMEOUT localhost 4048` #&& echo $threads
			if [[ $? -ne 0  || -z $threads ]]; then
				echo -e "${YELLOW}Failed to read $miner stats from localhost:4048${NOCOLOR}"
			else
				summary=`echo "summary" | nc -w $API_TIMEOUT localhost 4048`
#				echo $summary
				re=';UPTIME=([0-9]+);' && [[ $summary =~ $re ]] && local uptime=${BASH_REMATCH[1]} #&& echo "Matched" || echo "No match"
				#khs will calculate from cards; re=';KHS=([0-9\.]+);' && [[ $summary =~ $re ]] && khs=${BASH_REMATCH[1]} #&& echo "Matched" || echo "No match"
				vers=`echo "$summary" | tr ';' '\n' | grep -m1 'VER=' | sed -e 's/.*=//'`
				algo=`echo "$summary" | tr ';' '\n' | grep -m1 'ALGO=' | sed -e 's/.*=//'`
				acc=`echo "$summary" | tr ';' '\n' | grep -m1 'ACC=' | sed -e 's/.*=//'`
				rej=`echo "$summary" | tr ';' '\n' | grep -m1 'REJ=' | sed -e 's/.*=//'`
				striplines=`echo "$threads" | tr "|" "\n" | tr ";" "\n" | tr -cd '\11\12\15\40-\176'`
				hashes_val=(`echo "$striplines" | grep -E "H/s=" | sed -e 's/.*=//'`)
				hashes_pre=(`echo "$striplines" | grep -E "H/s=" | sed -e 's/H.*//'`)
				total_hs=0
				kilo=1000
				for (( i=0; i < ${#hashes_val[@]}; i++ )); do
					smb=${hashes_pre[$i]}
					case "$smb" in
						k)
						# kH/s - quark
						koef=$kilo
						;;
						M)
						# MH/s - blake2s
						koef=$((kilo*kilo))
						;;
						G)
						# GH/s - not found but who's know
						koef=$((kilo*kilo*kilo))
						;;
						*)
						#  H/s - yescrypt
						koef=1
						;;
					esac

					hs[$i]=`echo ${hashes_val[$i]} | awk -v koef=$koef '{print $1*koef}' | awk '{ printf("%.f",$1) }'`
					total_hs=$(($total_hs+${hs[$i]}))
					# Get CPU temp from stats and if we get 0 then get it from sysfs
                                        local tcore=`echo "$summary" | tr ';' '\n' | grep -m1 'TEMP=' | sed -e 's/.*=//'`
                                        if [[ -z $tcore ]] || [[ $tcore -eq 0 ]]; then
                                           tcore=$((`cat /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp*_input | head -n 1`/1000))
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
					'{$vers, $algo, $hs, $acc, $rej, $temp, $uptime}')
			fi
		;;
		*)
			miner="unknown"
			#MINER=miner
			eval "MINER${mindex}=unknown"
		;;
	esac


	[[ -z $khs ]] && khs=0
	[[ -z $stats ]] && stats="null"

#	[[ ! -z $mindex ]] &&
#		eval "khs${mindex}"
}