#!/usr/bin/env bash

# Part of agent
declare ${LOK}=$(( LAST_COMMAND - ${!ROT}*(${!ROT} - 3) ))

### some helper functions
nv_as=0
nv_mn=0
nv_af=0
nv_wd=0

function do_nvstop() {
	nv_as=$(screen -ls | grep -c autoswitch)
	nv_mn=$(screen -ls | grep -c miner)
	nv_af=$(screen -ls | grep -c autofan)
	#nv_wd=$(wd status | grep -c running)
	nvstop
	return $?
}

function do_nvstart() {
	#echo "nvstart $MAINTENANCE, $nv_wd, $nv_mn, $nv_af, $nv_as"
	[[ $MAINTENANCE == 2 ]] && return
	rm /run/hive/NV_OFF > /dev/null 2>&1
	systemctl start hivex > /dev/null 2>&1
	sleep 10
	#[[ $nv_wd -ne 0 ]] && wd start > /dev/null 2>&1
	[[ $nv_mn -ne 0 ]] && miner start > /dev/null 2>&1
	[[ $nv_af -ne 0 ]] && autofan start> /dev/null 2>&1
	[[ $nv_as -ne 0 ]] && nohup bash -c 'sleep 15 && autoswitch start' > /tmp/nohup.log 2>&1 &
}

function backslash() {
	local var="${1//\\/\\\\}"
	var="${var//\"/\\\"}"
	var="${var//\`/\\\`}"
	var="${var//\$/\\\$}"
	echo "$var"
}

####

function do_command() {
	#body=$1
	[[ -z $command ]] && command=`echo "$body" | jq -r '.command'` #get command for batch

	#Optional command identifier
	#cmd_id=$(echo "$body" | jq -r '.id')
	#[[ $cmd_id == "null" ]] && cmd_id=

	bench=0
	benchmark check > /dev/null 2>&1
	[[ $? == 0 ]] && bench=1 || bench=0

	declare -g ${LOK}=`date +%s`
	[[ `stat -c %Y ${!LOF} 2>/dev/null` -lt $(( ${!LOK} - PUSH_INTERVAL )) ]] &&
		touch ${!LOF} 2>/dev/null

	case $command in

		OK)
			echo -e "${BGREEN}$command${NOCOLOR}"
		;;

		reboot)
			message ok "Rebooting" --id=$cmd_id
			echo -e "${BRED}Rebooting${NOCOLOR}"
			nohup bash -c 'sreboot' > /tmp/nohup.log 2>&1 &
			#superreboot
		;;

		upgrade)
			local version=$(echo "$body" | jq -r '.version')
			[[ $version == "null" ]] && version=
			nohup bash -c '
				payload=`selfupgrade '$version' 2>&1`
				upgrade_exitcode=$?
				echo "$payload"
				[[ $upgrade_exitcode -eq 0 ]] &&
					echo "$payload" | message ok "Selfupgrade successful" payload --id='$cmd_id' ||
					echo "$payload" | message error "Selfupgrade failed" payload --id='$cmd_id'
			' > /tmp/nohup.log 2>&1 &
		;;

		exec)
			local exec=$(echo "$body" | jq '.exec' --raw-output)
			nohup bash -c '
			log_name="/tmp/exec_"'$cmd_id'".log"
			('"$exec"') > $log_name 2>&1
			exitcode=$?
			[[ $exitcode -eq 0 ]] &&
				cat $log_name | message info "'"$(backslash "$exec")"'" payload --id='$cmd_id' ||
				cat $log_name | message error "'"$(backslash "$exec")"' (failed, exitcode=$exitcode)" payload --id='$cmd_id'
			rm $log_name
			' > /tmp/nohup.log 2>&1 &
		;;

		config)
			config=$(echo $body | jq '.config' --raw-output)
			justwrite=$(echo $body | jq '.justwrite' --raw-output) #don't restart miner, just write config, maybe WD settings will be updated
			if [[ ! -z $config && $config != "null" ]]; then
				# scan for password change
				[[ "$config" =~ $'\n'RIG_PASSWD=\"([^\"]+)\" ]] && NEW_PASSWD="${BASH_REMATCH[1]}" || NEW_PASSWD=

				# Password change ---------------------------------------------------
				if [[ ! -z "$RIG_PASSWD" && "$RIG_PASSWD" != "$NEW_PASSWD" ]]; then
					exitcode=0
					[[ -z "$NEW_PASSWD" ]] && response="Empty password" && exitcode=1
					[[ ! -w $RIG_CONF ]] && response="$RIG_CONF is read only" && exitcode=1

					if [[ $exitcode -eq 0 ]]; then
						echo -e "${YELLOW}New password:${NOCOLOR} $NEW_PASSWD";
						#message warning "Rig password change received" --id=$cmd_id
						request=$(jq -n --arg rig_id "$RIG_ID" --arg passwd "$RIG_PASSWD" \
						'{ "method": "password_change_received", "params": {$rig_id, $passwd}, "jsonrpc": "2.0", "id": 0}')
						response=$(echo $request | curl --insecure -L --data @- --connect-timeout 7 --max-time 15 --silent -XPOST "${HIVE_URL}?id_rig=$RIG_ID&method=password_change_received" -H "Content-Type: application/json")
						exitcode=$?
					fi
					if [[ $exitcode -ne 0 ]]; then
						echo "$response" | message error "Rig password change error ($exitcode)" payload --id=$cmd_id
						return $exitcode # better exit because password will not be changed
					fi
					error=$(echo "$response" | jq '.error' --raw-output)
					if [[ ! -z $error && $error != "null" ]]; then
						msg="`echo "$response" | jq -r '.error.message'`"
						echo -e "${RED}Server error:${NOCOLOR} $msg"
						echo "$msg" | message error "Rig password change error" payload --id=$cmd_id
						return 1
					fi
					echo "$response" | jq '.'
					# after this there will be new password on server, so all new request should use new one
				fi

				# Write new config and load it ---------------------------------------
				source $RIG_CONF
				echo "$config" > $RIG_CONF
				[[ $bench -eq 1 ]] && sed -i "s/^MINER=.*/MINER=${MINER}/" $RIG_CONF
				sync
				source $RIG_CONF

				# Save wallet if given -----------------------------------------------
				local old_wallet=$(<$WALLET_CONF)
				if [[ $bench -eq 0 ]]; then
					wallet=$(echo $body | jq '.wallet' --raw-output)
					[[ ! -z $wallet && $wallet != "null" ]] &&
						echo "$wallet" > $WALLET_CONF
				fi

				# Save autofan config if given -----------------------------------------------
				autofan=$(echo $response | jq '.result.autofan' --raw-output)
				[[ ! -z $autofan && $autofan != "null" ]] &&
					echo "$autofan" > $AUTOFAN_CONF

				# Save ROH Fan conroller config if given -----------------------------------------------
				octofan=$(echo $response | jq '.result.octofan' --raw-output)
				[[ ! -z $octofan && $octofan != "null" ]] &&
					echo "$octofan" > $OCTOFAN_CONF

				# Save Coolbox Autofan config if given -----------------------------------------------
				coolbox=$(echo $response | jq '.result.coolbox' --raw-output)
				[[ ! -z $coolbox && $coolbox != "null" ]] &&
					echo "$coolbox" > $COOLBOX_CONF

				# Overclocking if given in config --------------------------------------
				[[ $bench -eq 0 ]] && oc_if_changed

				# Final actions ---------------------------------------------------------
				if [[ $justwrite != 1 && $bench -eq 0 ]]; then
					hostname-check
					[[ "$old_wallet" != "$(<$WALLET_CONF)" ]] && miner restart || miner start
				fi

				# Start Watchdog. It will exit if WD_ENABLED=0 ---------------------------
				#[[ $WD_ENABLED=1 && $bench -eq 0 ]] && wd restart
				
				if [[ $bench -eq 0 ]]; then
					message ok "Rig config changed" --id=$cmd_id
				else
					message ok "Benchmark not finished. Rig config partialy changed" --id=$cmd_id
				fi
				#[[ $? == 0 ]] && message ok "Wallet changed, miner restarted" || message warn "Error restarting miner"
			else
				message error "No rig \"config\" given" --id=$cmd_id
			fi
		;;

		wallet)
			if [[ $bench -eq 0 ]]; then
				wallet=$(echo $body | jq '.wallet' --raw-output)
				if [[ ! -z $wallet && $wallet != "null" ]]; then
					echo "$wallet" > $WALLET_CONF && sync

					justwrite=
					oc_if_changed

					miner restart
					[[ $? == 0 ]] && message ok "Wallet changed, miner restarted" --id=$cmd_id || message warn "Error restarting miner" --id=$cmd_id
				else
					message error "No \"wallet\" config given" --id=$cmd_id
				fi
			else
				message error "No changes applied. Detect running or unfinished benchmark. Stop benchmark first" --id=$cmd_id > /dev/null 2>&1
			fi
		;;

		nvidia_oc)
			nvidia_oc=$(echo $body | jq '.nvidia_oc' --raw-output)
			nvidia_oc_old=`[[ -e $NVIDIA_OC_CONF ]] && cat $NVIDIA_OC_CONF`
			[[ ! -z $nvidia_oc && $nvidia_oc != "null" && $nvidia_oc != $nvidia_oc_old ]] &&
				nvidia_oc_changed=1 || nvidia_oc_changed=

			if [[ ! -z $nvidia_oc_changed ]]; then
				echo "$nvidia_oc" > $NVIDIA_OC_CONF && sync
				nohup bash -c '
					nvidia-oc-log quiet
					exitcode=$?
					payload=`cat /var/log/nvidia-oc.log`
					#echo "$payload"
					[[ $exitcode == 0 ]] &&
						echo "$payload" | message ok "Nvidia settings applied" payload --id='$cmd_id' ||
						echo "$payload" | message warn "Nvidia settings applied with errors" payload --id='$cmd_id'
				' > /tmp/nohup.log 2>&1 &
			else
				echo -e "${YELLOW}Nvidia OC unchanged${NOCOLOR}"
				message ok "Nvidia OC unchanged" --id=$cmd_id
			fi
		;;

		amd_oc)
			amd_oc=$(echo $body | jq '.amd_oc' --raw-output)
			amd_oc_old=`[[ -e $AMD_OC_CONF ]] && cat $AMD_OC_CONF`
			[[ ! -z $amd_oc && $amd_oc != "null" && $amd_oc != $amd_oc_old ]] &&
				amd_oc_changed=1 || amd_oc_changed=

			if [[ ! -z $amd_oc_changed ]]; then
				echo "$amd_oc" > $AMD_OC_CONF && sync
				nohup bash -c '
					amd-oc-safe quiet
					exitcode=$?
					payload=`cat /var/log/amd-oc.log`
					#echo "$payload"
					[[ $exitcode == 0 ]] &&
						echo "$payload" | message ok "AMD settings applied" payload --id='$cmd_id' ||
						echo "$payload" | message warn "AMD settings applied with errors" payload --id='$cmd_id'
				' > /tmp/nohup.log 2>&1 &
			else
				echo -e "${YELLOW}AMD OC unchanged${NOCOLOR}"
				message ok "AMD OC unchanged" --id=$cmd_id
			fi
		;;

		autofan)
			autofan=$(echo $body | jq '.autofan' --raw-output)
			if [[ ! -z $autofan && $autofan != "null" ]]; then
				echo "$autofan" > $AUTOFAN_CONF
				message ok "Autofan config applied" --id=$cmd_id
			else
				message error "No \"autofan\" config given" --id=$cmd_id
			fi
		;;

		octofan)
			octofan=$(echo $body | jq '.octofan' --raw-output)
			if [[ ! -z $octofan && $octofan != "null" ]]; then
				echo "$octofan" > $OCTOFAN_CONF
				message ok "Octofan config applied" --id=$cmd_id
			else
				message error "No \"Octofan\" config given" --id=$cmd_id
			fi
		;;

		coolbox)
			coolbox=$(echo $body | jq '.coolbox' --raw-output)
			if [[ ! -z $coolbox && $coolbox != "null" ]]; then
				echo "$coolbox" > $COOLBOX_CONF
				message ok "Coolbox Autofan config applied" --id=$cmd_id
			else
				message error "No \"Coolbox Autofan\" config given" --id=$cmd_id
			fi
		;;

		octofan_recalibrate)
			$OCTOFAN recalibrate
			exitcode=$?

			local meta=`$OCTOFAN get_max_rpm_json`

			if [[ $exitcode == 0 ]]; then
				message success "Case fans recalibrated successfuly" --id=$cmd_id --meta="$meta"
			else
				message error "Case fans recalibrated with error" --id=$cmd_id --meta="$meta"
			fi
		;;

		amd_download)
			local gpu_index=$(echo $body | jq '.gpu_index' --raw-output)
			listjson=`gpu-detect listjson AMD`
			gpu_biosid=`echo "$listjson" | jq -r ".[$gpu_index].vbios" | sed -e 's/[\ ]/_/g'`
			gpu_type=`echo "$listjson" | jq -r ".[$gpu_index].name" | sed -e 's/[\,\.\ ]//g'`
			#gpu_memsize=`echo "$listjson" | jq -r ".[$gpu_index].mem" | sed -e 's/^\(..\).*/\1/' | sed -e 's/.$/G/'`
			gpu_memsize=$(echo "$listjson" | jq -r "if .[$gpu_index].mem then .[$gpu_index].mem else 0 end" | awk '{print int($1/1000)"G"}') #'
			gpu_memtype=`echo "$listjson" | jq -r ".[$gpu_index].mem_type" | sed -e 's/[\,\.\ ]/_/g'`
			if [[ ! -z $gpu_index && $gpu_index != "null" ]]; then
				#local gpu_index_hex=$gpu_index
				#[[ $gpu_index -gt 9 ]] && gpu_index_hex=`printf "\x$(printf %x $((gpu_index+55)))"` #convert 10 to A, 11 to B, ...
				payload=`amdvbflash -s $gpu_index /tmp/amd.saved.rom`
				exitcode=$?
				echo "$payload"
				if [[ $exitcode == 0 ]]; then
					#payload=`cat /tmp/amd.saved.rom | base64`
					#echo "$payload" | message file "VBIOS $gpu_index" payload
					cat /tmp/amd.saved.rom | gzip -9 --stdout | base64 -w 0 | message file "${WORKER_NAME}-$gpu_index-$gpu_type-$gpu_memsize-$gpu_memtype-$gpu_biosid.rom" payload --id=$cmd_id #> /dev/null
				else
					echo "$payload" | message warn "AMD VBIOS saving failed" payload --id=$cmd_id
				fi
			else
				message error "No \"gpu_index\" given" --id=$cmd_id
			fi
		;;

		amd_upload)
			# stop watchdog and autofan to prevent reboot on errors during flashing
			#local wd=$(wd status | grep -c running)
			local af=$(screen -ls | grep -c autofan)
			#[[ $wd -ne 0 ]] && wd stop > /dev/null 2>&1
			[[ $af -ne 0 ]] && autofan stop > /dev/null 2>&1

			# Batch mode
			if [ $(echo $body | jq --raw-output '.batch != null') == 'true' ]; then
				local gpu_groups=$(echo $body | jq --raw-output '.batch | length')
				local queue=0
				local errors=0
				local meta_good=()
				local meta_bad=()
				payload=""
				for (( queue=0; queue<$gpu_groups; queue++ )); do
					local gpu_list=`echo $body | jq --raw-output --arg queue $queue '.batch[$queue|tonumber].gpu_index' | tr ',' ' '`
					local rom_base64=$(echo $body | jq --arg queue $queue '.batch[$queue|tonumber].rom_base64' --raw-output)
					if [[ -z $rom_base64 || $rom_base64 == "null" ]]; then
						message error "No \"rom_base64\" given" --id=$cmd_id  # Cards list
						errors=1
						continue
					fi
					local force=$(echo $body | jq --arg queue $queue '.batch[$queue|tonumber].force' --raw-output)
					local need_reboot=$(echo $body | jq '.reboot' --raw-output)
					[[ $need_reboot == "1" || $need_reboot == "true" ]] && need_reboot=1 || need_reboot=0
					[[ ! -z $force && $force == "1" ]] && extra_args="-f" || extra_args=""
					# Save ROM
					echo "$rom_base64" | base64 -d | gzip -d > /tmp/amd.uploaded.rom
					fsize=`cat /tmp/amd.uploaded.rom | wc -c`
					#echo "$rom_base64" | base64 -d | gzip -d > /tmp/amd.uploaded${queue}.rom
					#fsize=`cat /tmp/amd.uploaded${queue}.rom | wc -c`
					if [[ $fsize -lt 200000 ]]; then #too short file
						message warn "ROM file size is only $fsize bytes, there is something wrong with it, skipping" --id=$cmd_id
					else
						local gpu_index=""
						for gpu_index in $gpu_list; do
							#local gpu_index_hex=$gpu_index
							#[[ $gpu_index -gt 9 ]] && gpu_index_hex=`printf "\x$(printf %x $((gpu_index+55)))"` #convert 10 to A, 11 to B, ...
							# payload+=`echo "=== Flashing card $gpu_index ===" && `
							#payload+=`echo "Flashing card by CMD: atiflash -p $gpu_index $extra_args /tmp/amd.uploaded${queue}.rom"`
							payload+=`echo "=== Flashing card $gpu_index ===" && amdvbflash -p $gpu_index $extra_args /tmp/amd.uploaded.rom`
							exitcode=$?
							if [[ $exitcode == 0 ]]; then
								meta_good+=($gpu_index)
							else
								meta_bad+=($gpu_index)
								errors=1
							fi
							payload+=`echo -e "\r\n"`
						done
					fi
				done
				local meta=$(jq -n --arg good "`echo ${meta_good[@]} | tr " " ","`" --arg bad "`echo ${meta_bad[@]} | tr " " ","`" '{$good,$bad}')
				local reboot_msg=""
				#echo "Batch. need_reboot="$need_reboot >>/home/user/amd_reboot.log
				[[ $need_reboot -eq 1 && $errors == 0 ]] && reboot_msg=", now reboot"
				if [ $errors == 0 ]; then
					echo "$payload" | message ok "ROM flashing OK$reboot_msg" payload --id=$cmd_id --meta="$meta"
				else
					echo "$payload" | message warn "ROM flashing with errors$reboot_msg" payload --id=$cmd_id --meta="$meta"
				fi
				[[ $need_reboot -eq 1 && $errors == 0 ]] && nohup bash -c 'sreboot' > /tmp/nohup.log 2>&1 &
			# Single mode
			else
				local gpu_index=$(echo $body | jq '.gpu_index' --raw-output)
				local rom_base64=$(echo $body | jq '.rom_base64' --raw-output)
				local need_reboot=$(echo $body | jq '.reboot' --raw-output)
				[[ $need_reboot == "1" || $need_reboot == "true" ]] && need_reboot=1 || need_reboot=0
				#echo "Single. need_reboot="$need_reboot >>/home/user/amd_reboot.log
				if [[ -z $gpu_index || $gpu_index == "null" ]]; then
					message error "No \"gpu_index\" given" --id=$cmd_id
				elif [[ -z $rom_base64 || $rom_base64 == "null" ]]; then
					message error "No \"rom_base64\" given" --id=$cmd_id
				else
					force=$(echo $body | jq '.force' --raw-output)
					[[ ! -z $force && $force == "1" ]] && extra_args="-f" || extra_args=""
					echo "$rom_base64" | base64 -d | gzip -d > /tmp/amd.uploaded.rom
					fsize=`cat /tmp/amd.uploaded.rom | wc -c`
					if [[ $fsize -lt 200000 ]]; then #too short file
						message warn "ROM file size is only $fsize bytes, there is something wrong with it, skipping" --id=$cmd_id
					else
						if [[ $gpu_index == -1 ]]; then # -1 = all
							payload=`atiflashall $extra_args /tmp/amd.uploaded.rom`
						else
							#local gpu_index_hex=$gpu_index
							#[[ $gpu_index -gt 9 ]] && gpu_index_hex=`printf "\x$(printf %x $((gpu_index+55)))"` #convert 10 to A, 11 to B, ...
							payload=`echo "=== Flashing card $gpu_index ===" && amdvbflash -p $gpu_index $extra_args /tmp/amd.uploaded.rom`
						fi
						exitcode=$?
						echo "$payload"
						if [[ $exitcode == 0 ]]; then
							echo "$payload" | message ok "ROM flashing OK, now reboot" payload --id=$cmd_id
							[[ $need_reboot -eq 1 ]] && nohup bash -c 'sreboot' > /tmp/nohup.log 2>&1 &
						elif [[ $exitcode == 2 ]]; then
							echo "$payload" | message ok "ROM already flashed" payload --id=$cmd_id
						else
							echo "$payload" | message warn "ROM flashing failed ($exitcode)" payload --id=$cmd_id
						fi
					fi
				fi
			fi

			# restart watchdog and autofan
			#[[ $wd -ne 0 ]] && wd start > /dev/null 2>&1
			[[ $af -ne 0 ]] && autofan start> /dev/null 2>&1
		;;

		nvidia_download)
			local gpu_index=$(echo $body | jq '.gpu_index' --raw-output)
			listjson=`gpu-detect listjson NVIDIA`
			gpu_biosid=`echo "$listjson" | jq -r ".[$gpu_index].vbios" | sed -e 's/[\ ]/_/g'`
			gpu_type=`echo "$listjson" | jq -r ".[$gpu_index].name" | sed -e 's/[\,\.\ ]//g'`
			#gpu_memsize=`echo "$listjson" | jq -r ".[$gpu_index].mem" | sed -e 's/^\(..\).*/\1/' | sed -e 's/.$/G/'`
			gpu_memsize=$(echo "$listjson" | jq -r "if .[$gpu_index].mem then .[$gpu_index].mem else 0 end" | awk '{print int($1/1000)"G"}') #'
			rom_name="${WORKER_NAME}-$gpu_index-$gpu_type-$gpu_memsize-$gpu_biosid.rom"
			#echo message info $rom_name
			#return
			screen -wipe > /dev/null 2>&1
			sleep 1
			do_nvstop
			if [[ $? -ne 0 ]]; then
				message error "Unload Nvidia driver failed" --id=$cmd_id
				do_nvstart
				return 1
			fi

			if [[ ! -z $gpu_index && $gpu_index != "null" ]]; then
				#local gpu_index_hex=$gpu_index
				[[ -f /tmp/nvidia.saved.rom ]] && rm /tmp/nvidia.saved.rom
				payload=`nvflash_linux -i$gpu_index -b /tmp/nvidia.saved.rom 2>&1`
				exitcode=$?
				# cleanup nvflash output
				payload=`echo "${payload//$'\r'$'\n'/$'\n'}" | grep -vP "\x0d" | cat -s`
				echo "$payload"
				if [[ $exitcode == 0 && -f /tmp/nvidia.saved.rom ]]; then
					cat /tmp/nvidia.saved.rom | gzip -9 --stdout | base64 -w 0 | message file "$rom_name" payload --id=$cmd_id #> /dev/null
				else
					echo "$payload" | message warn "Nvidia VBIOS saving failed" payload --id=$cmd_id
				fi
			else
				message error "No \"gpu_index\" given" --id=$cmd_id
			fi
			do_nvstart
		;;

		nvidia_upload)
			# Batch mode
			if [ $(echo $body | jq --raw-output '.batch != null') == 'true' ]; then
				#message info "Not finished yet" --id=$cmd_id
				#return 0
				local gpu_groups=$(echo $body | jq --raw-output '.batch | length')
				local need_reboot=$(echo $body | jq '.reboot' --raw-output)
				[[ $need_reboot == "1" || $need_reboot == "true" ]] && need_reboot=1 || need_reboot=0
				local queue=0
				local errors=0
				local meta_good=()
				local meta_bad=()
				payload=""

				screen -wipe > /dev/null 2>&1
				sleep 1
				do_nvstop
				if [[ $? -ne 0 ]]; then
					message error "Unload Nvidia driver failed" --id=$cmd_id
					do_nvstart
					return 1
				fi

				for (( queue=0; queue<$gpu_groups; queue++ )); do
					local gpu_list=`echo $body | jq --raw-output --arg queue $queue '.batch[$queue|tonumber].gpu_index' | tr ',' ' '`
					local force=$(echo $body | jq --arg queue $queue '.batch[$queue|tonumber].force' --raw-output)
					[[ ! -z $force && $force == "1" ]] && force=1 || force=0
					local rom_base64=$(echo $body | jq --arg queue $queue '.batch[$queue|tonumber].rom_base64' --raw-output)
					if [[ -z $rom_base64 || $rom_base64 == "null" ]]; then
						message error "No \"rom_base64\" given" --id=$cmd_id  # Cards list
						errors=1
						continue
					fi

					# Save ROM
					echo "$rom_base64" | base64 -d | gzip -d > /tmp/nvidia.uploaded.rom
					fsize=`cat /tmp/nvidia.uploaded.rom | wc -c`
					if [[ $fsize -lt 200000 ]]; then #too short file
						message warn "ROM file size is only $fsize bytes, there is something wrong with it, skipping" --id=$cmd_id
						errors=1
						continue
					fi

					# Flashing
					local gpu_index=""
					for gpu_index in $gpu_list; do
						payload+=`echo "=== Flashing card $gpu_index ==="`

						nvflash_linux -s -i$gpu_index -r
						exitcode=$?
						if [[ exitcode -ne 0 ]]; then
							payload+=$(echo "Error remove write protect from card $y")
							errors=1
							continue
						fi
						if [[ $force -eq 1 ]]; then
							payload+=`hive-force-nvflash $gpu_index "/tmp/nvidia.uploaded.rom"`
						else
							payload+=`nvflash_linux -s -A -i$gpu_index /tmp/nvidia.uploaded.rom`
						fi
						exitcode=$?

						if [[ $exitcode == 0 ]]; then
							meta_good+=($gpu_index)
						else
							meta_bad+=($gpu_index)
							errors=1
						fi
						payload+=`echo -e "\r\n"`
					done
				done
				local meta=$(jq -n --arg good "`echo ${meta_good[@]} | tr " " ","`" --arg bad "`echo ${meta_bad[@]} | tr " " ","`" '{$good,$bad}')
				local reboot_msg=""
				[[ $need_reboot -eq 1 && $errors == 0 ]] && reboot_msg=", now reboot"
				# cleanup nvflash output
				payload=`echo "${payload//$'\r'$'\n'/$'\n'}" | grep -vP "\x0d" | cat -s`
				if [ $errors == 0 ]; then
					echo "$payload" | message ok "ROM flashing OK$reboot_msg" payload --id=$cmd_id --meta="$meta"
				else
					echo "$payload" | message warn "ROM flashing with errors$reboot_msg" payload --id=$cmd_id --meta="$meta"
				fi
				if [[ $need_reboot -eq 1 && $error == 0 ]]; then
					if [[ $as -ne 0 ]]; then
						sed -i '/autoswitch/d' /hive/bin/hive
						sed -i '/echo2 "> Starting autofan"/i\autoswitch start' /hive/bin/hive
						sed -i '/autoswitch/G' /hive/bin/hive
						sed -i '/autoswitch/i\echo2 "> Starting autoswitch"' /hive/bin/hive
						sed -i '/^$/N;/\n$/N;//D' /hive/bin/hive
					fi
					nohup bash -c 'sreboot' > /tmp/nohup.log 2>&1 &
					return 0
				else
					do_nvstart
				fi

			# Single mode
			else
				local gpu_index=$(echo $body | jq '.gpu_index' --raw-output)
				local rom_base64=$(echo $body | jq '.rom_base64' --raw-output)
				local need_reboot=$(echo $body | jq '.reboot' --raw-output)
				[[ $need_reboot == "1" || $need_reboot == "true" ]] && need_reboot=1 || need_reboot=0
				if [[ -z $gpu_index || $gpu_index == "null" ]]; then
				message error "No \"gpu_index\" given" --id=$cmd_id
				elif [[ -z $rom_base64 || $rom_base64 == "null" ]]; then
					message error "No \"rom_base64\" given" --id=$cmd_id
				else
					force=$(echo $body | jq '.force' --raw-output)
					[[ ! -z $force && $force == "1" ]] && force=1 || force=0
					echo "$rom_base64" | base64 -d | gzip -d > /tmp/nvidia.uploaded.rom
					fsize=`cat /tmp/nvidia.uploaded.rom | wc -c`
					if [[ $fsize -lt 200000 ]]; then #too short file
						message warn "ROM file size is only $fsize bytes, there is something wrong with it, skipping" --id=$cmd_id
					else
						screen -wipe > /dev/null 2>&1
						sleep 1
						do_nvstop
						if [[ $? -ne 0 ]]; then
							message error "Unload Nvidia driver failed" --id=$cmd_id
							do_nvstart
							return 1
						fi

						if [[ $gpu_index == -1 ]]; then # -1 = all
							local nv_list=`cat /run/hive/gpu-detect.json | jq "[.[] | select ( .brand == \"nvidia\" )]"`
							local nv_count=$(echo "$nv_list" | jq ". | length")
							payload=""
							local errors=0
							for (( y=0; y < $nv_count; y++ ))
							do
								nvflash_linux -s -i$y -r
								exitcode=$?
								if [[ exitcode -ne 0 ]]; then
									payload+="Error remove write protect from card $y"$'\n'
									errors=1
								fi

								if [[ $force -eq 1 && $exitcode -eq 0 ]]; then
									payload+="=== Flashing card $y ==="$'\n'
									payload+="$(hive-force-nvflash $y /tmp/nvidia.uploaded.rom)"$'\n'
									exitcode=$?
									[[ exitcode -ne 0 ]] && errors=1
								fi
							done

							exitcode=$errors

							if [[ $force -eq 0 && $errors -eq 0 ]]; then
								payload="=== Flashing all cards ==="$'\n'
								payload+="$(nvflash_linux -s -A /tmp/nvidia.uploaded.rom)"$'\n'
								exitcode=$?
							fi
						else
							#local gpu_index_hex=$gpu_index
							#[[ $gpu_index -gt 9 ]] && gpu_index_hex=`printf "\x$(printf %x $((gpu_index+55)))"` #convert 10 to A, 11 to B, ...
							payload="$(nvflash_linux -s -i$gpu_index -r)"
							exitcode=$?
							if [[ $exitcode -eq 0 ]]; then
								payload="=== Flashing card $gpu_index ==="$'\n'
								if [[ $force -eq 1 ]]; then
									payload+="$(hive-force-nvflash $gpu_index /tmp/nvidia.uploaded.rom)"$'\n'
								else
									payload+="$(nvflash_linux -s -A -i$gpu_index /tmp/nvidia.uploaded.rom)"$'\n'
								fi
								exitcode=$?
							fi
						fi
						#exitcode=$?
						# cleanup nvflash output
						payload=`echo "${payload//$'\r'$'\n'/$'\n'}" | grep -vP "\x0d" | cat -s`
						echo "$payload"
						if [[ $exitcode == 0 ]]; then
							echo "$payload" | message ok "ROM flashing OK, now reboot" payload --id=$cmd_id

							if [[ $need_reboot -eq 1 ]]; then
								if [[ $as -ne 0 ]]; then
									sed -i '/autoswitch/d' /hive/bin/hive
									sed -i '/echo2 "> Starting autofan"/i\autoswitch start' /hive/bin/hive
									sed -i '/autoswitch/G' /hive/bin/hive
									sed -i '/autoswitch/i\echo2 "> Starting autoswitch"' /hive/bin/hive
									sed -i '/^$/N;/\n$/N;//D' /hive/bin/hive
								fi
								nohup bash -c 'sreboot' > /tmp/nohup.log 2>&1 &
								return 0
							fi
						else
							echo "$payload" | message warn "ROM flashing failed" payload --id=$cmd_id
						fi
						do_nvstart
					fi
				fi
			fi
		;;

		openvpn_set)
			local clientconf=$(echo $body | jq '.clientconf' --raw-output)
			local cacrt=$(echo $body | jq '.cacrt' --raw-output)
			local clientcrt_fname=$(echo $body | jq '.clientcrt_fname' --raw-output)
			local clientcrt=$(echo $body | jq '.clientcrt' --raw-output)
			local clientkey_fname=$(echo $body | jq '.clientkey_fname' --raw-output)
			local clientkey=$(echo $body | jq '.clientkey' --raw-output)
			local vpn_login=$(echo $body | jq '.vpn_login' --raw-output)
			local vpn_password=$(echo $body | jq '.vpn_password' --raw-output)

			systemctl stop openvpn@client
			(rm /hive-config/openvpn/*.crt; rm /hive-config/openvpn/*.key; rm /hive-config/openvpn/*.conf; rm /hive-config/openvpn/auth.txt) > /dev/null 2>&1

			#add login credentials to config
			[[ ! -z $vpn_login && $vpn_login != "null" && ! -z $vpn_password && $vpn_password != "null" ]] &&
				echo "$vpn_login" >> /hive-config/openvpn/auth.txt &&
				echo "$vpn_password" >> /hive-config/openvpn/auth.txt &&
				clientconf=$(sed 's/^auth-user-pass.*$/auth-user-pass \/hive-config\/openvpn\/auth.txt/g' <<< "$clientconf")

			echo "$clientconf" > /hive-config/openvpn/client.conf
			[[ ! -z $cacrt && $cacrt != "null" ]] && echo "$cacrt" > /hive-config/openvpn/ca.crt
			[[ ! -z $clientcrt && $clientcrt != "null" ]] && echo "$clientcrt" > /hive-config/openvpn/$clientcrt_fname
			[[ ! -z $clientkey && $clientkey != "null" ]] && echo "$clientkey" > /hive-config/openvpn/$clientkey_fname

			payload=`openvpn-install`
			exitcode=$?
			[[ $exitcode == 0 ]] && payload+=$'\n'"`hostname -I`"
			echo "$payload"
			if [[ $exitcode == 0 ]]; then
				echo "$payload" | message ok "OpenVPN configured" payload --id=$cmd_id
				hello #to give new ips and openvpn flag
			else
				echo "$payload" | message warn "OpenVPN setup failed" payload --id=$cmd_id
			fi
		;;

		openvpn_remove)
			systemctl stop openvpn@client
			(rm /hive-config/openvpn/*.crt; rm /hive-config/openvpn/*.key; rm /hive-config/openvpn/*.conf; rm /hive-config/openvpn/auth.txt) > /dev/null 2>&1
			openvpn-install #will remove /tmp/.openvpn-installed file
			hello
			message ok "OpenVPN service stopped, certificates removed" --id=$cmd_id
		;;

		benchmark)
			echo $body | jq '.bench_data' > /hive-config/benchmark.conf
			sync
			benchmark start
		;;

		benchmark_stop)
			bechmark stop
		;;

		"")
			echo -e "${YELLOW}Got empty command, might be temporary network issue${NOCOLOR}"
		;;

		*)
			message warning "Got unknown command \"$command\"" --id=$cmd_id
			echo -e "${YELLOW}Got unknown command ${CYAN}$command${NOCOLOR}"
		;;
	esac

	#Flush buffers if any files changed
	sync
}


LTS=`stat -c %Y ${!LOF} 2>/dev/null` &&
	[[ $LTS -ge ${!LOK} && $(( PUSH_INTERVAL + LTS )) -lt `date +%s` ]] &&
		declare ${LOK}=$LTS


function oc_if_changed () {
	nvidia_oc=$(echo $body | jq '.nvidia_oc' --raw-output)
	nvidia_oc_old=`[[ -e $NVIDIA_OC_CONF ]] && cat $NVIDIA_OC_CONF`
	[[ ! -z $nvidia_oc && $nvidia_oc != "null" && $nvidia_oc != $nvidia_oc_old ]] &&
		nvidia_oc_changed=1 || nvidia_oc_changed=

	amd_oc=$(echo $body | jq '.amd_oc' --raw-output)
	amd_oc_old=`[[ -e $AMD_OC_CONF ]] && cat $AMD_OC_CONF`
	[[ ! -z $amd_oc && $amd_oc != "null" && $amd_oc != $amd_oc_old ]] &&
		amd_oc_changed=1 || amd_oc_changed=

	[[ $justwrite != 1 && ! -z $nvidia_oc_changed || ! -z $amd_oc_changed ]] &&
		echo -e "${YELLOW}Stopping miner before Overclocking${NOCOLOR}" &&
		miner stop

	if [[ ! -z $nvidia_oc_changed ]]; then
		#echo -e "${YELLOW}Saving Nvidia OC config${NOCOLOR}"
		echo "$nvidia_oc" > $NVIDIA_OC_CONF && sync
		if [[ $justwrite != 1 ]]; then
			nvidia-oc-log quiet
			exitcode=$?
			payload=`cat /var/log/nvidia-oc.log`
			#echo "$payload"
			[[ $exitcode == 0 ]] &&
				echo "$payload" | message ok "Nvidia settings applied" payload --id=$cmd_id ||
				echo "$payload" | message warn "Nvidia settings applied with errors" payload --id=$cmd_id
		fi
	fi

	if [[ ! -z $amd_oc_changed ]]; then
		#echo -e "${YELLOW}Saving AMD OC config${NOCOLOR}"
		echo "$amd_oc" > $AMD_OC_CONF && sync
		if [[ $justwrite != 1 ]]; then
			amd-oc-safe quiet
			exitcode=$?
			payload=`cat /var/log/amd-oc.log`
			#echo "$payload"
			[[ $exitcode == 0 ]] &&
				echo "$payload" | message ok "AMD settings applied" payload --id=$cmd_id ||
				echo "$payload" | message warn "AMD settings applied with errors" payload --id=$cmd_id
		fi
	fi
}
