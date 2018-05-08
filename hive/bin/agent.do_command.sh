#!/usr/bin/env bash

function do_command () {
	#body=$1
	[[ -z $command ]] && command=`echo $body | jq -r '.command'` #get command for batch

	case $command in
		OK)
			echo -e "${BGREEN}$command${NOCOLOR}"
		;;
		reboot)
			message ok "Rebooting" 120
			echo -e "${BRED}Rebooting${NOCOLOR}"
			nohup bash -c 'sreboot' > /tmp/nohup.log 2>&1 &
			#superreboot
		;;
		upgrade)
			nohup bash -c '
				payload=`selfupgrade 2>&1`
				upgrade_exitcode=$?
				echo "$payload"
				[[ $upgrade_exitcode -eq 0 ]] &&
					echo "$payload" | message ok "Selfupgrade successful" payload ||
					echo "$payload" | message error "Selfupgrade failed" payload
			' > /tmp/nohup.log 2>&1 &
		;;
		exec)
			exec=$(echo $body | jq '.exec' --raw-output)
			payload=`timeout 360 bash -c "$exec" 2>&1`
			exitcode=$?
			echo "$payload"
			[[ $exitcode -eq 0 ]] &&
				echo "$payload" | message info "$exec" payload ||
				echo "$payload" | message error "Exec failed, exitcode=$exitcode" payload
		;;
		config)
			config=$(echo $body | jq '.config' --raw-output)
			justwrite=$(echo $body | jq '.justwrite' --raw-output) #don't restart miner, just write config, maybe WD settings will be updated
			if [[ ! -z $config && $config != "null" ]]; then
				#scan for password change
				echo "$config" > /tmp/rig.conf.new
				while read line; do
					[[ $line =~ ^RIG_PASSWD=\"(.*)\" ]] && NEW_PASSWD=${BASH_REMATCH[1]} && break
				done < /tmp/rig.conf.new
				rm /tmp/rig.conf.new

				# Password change ---------------------------------------------------
				if [[ $RIG_PASSWD != $NEW_PASSWD ]]; then
					echo -e "${RED}New password:${NOCOLOR} $NEW_PASSWD";

					message warning "Password change received, wait for next message..." 120
					request=$(jq -n --arg rig_id "$RIG_ID" --arg passwd "$RIG_PASSWD" \
					'{ "method": "password_change_received", "params": {$rig_id, $passwd}, "jsonrpc": "2.0", "id": 0}')
					response=$(echo $request | curl --insecure -L --data @- --connect-timeout 7 --max-time 15 --silent -XPOST "${HIVE_URL}?id_rig=$RIG_ID&method=password_change_received" -H "Content-Type: application/json")

					exitcode=$?
					[ $exitcode -ne 0 ] &&
						message error "Error notifying hive about \"password_change_received\"" &&
						return $exitcode #better exit because password will not be changed

					error=$(echo $response | jq '.error' --raw-output)
					[[ ! -z $error && $error != "null" ]] && echo -e "${RED}Server error:${NOCOLOR} `echo $response | jq '.error.message' -r`" && return 1

					echo "$response" | jq '.'
					#after this there will be new password on server, so all new request should use new one
				fi

				# Write new config and load it ---------------------------------------
				echo "$config" > $RIG_CONF && sync
				. $RIG_CONF

				# Save wallet if given -----------------------------------------------
				wallet=$(echo $body | jq '.wallet' --raw-output)
				[[ ! -z $wallet && $wallet != "null" ]] &&
					echo "$wallet" > $WALLET_CONF


				# Overclocking if given in config --------------------------------------
				oc_if_changed


				# Final actions ---------------------------------------------------------
				if [[ $justwrite != 1 ]]; then
					hostname-check
					miner restart
				fi

				# Start Watchdog. It will exit if WD_ENABLED=0 ---------------------------
				[[ $WD_ENABLED=1 ]] && wd restart

				message ok "Rig config changed" 120
				#[[ $? == 0 ]] && message ok "Wallet changed, miner restarted" 120 || message warn "Error restarting miner"
			else
				message error "No rig \"config\" given"
			fi
		;;
		wallet)
			wallet=$(echo $body | jq '.wallet' --raw-output)
			if [[ ! -z $wallet && $wallet != "null" ]]; then
				echo "$wallet" > $WALLET_CONF && sync

				justwrite=
				oc_if_changed

				miner restart
				[[ $? == 0 ]] && message ok "Wallet changed, miner restarted" 120 || message warn "Error restarting miner"
			else
				message error "No \"wallet\" config given"
			fi
		;;
		nvidia_oc)
			nvidia_oc=$(echo $body | jq '.nvidia_oc' --raw-output)
			#nvidia_oc_old=`[[ -e $NVIDIA_OC_CONF ]] && cat $NVIDIA_OC_CONF`
			#if [[ $nvidia_oc == $nvidia_oc_old ]]; then
			#	echo -e "${YELLOW}Nvidia OC config did not change, skipping${NOCOLOR}";
			if [[ ! -z $nvidia_oc && $nvidia_oc != "null" ]]; then
				echo "$nvidia_oc" > $NVIDIA_OC_CONF && sync
				nohup bash -c '
					nvidia-oc-log
					exitcode=$?
					payload=`cat /var/log/nvidia-oc.log`
					echo "$payload"
					[[ $exitcode == 0 ]] &&
						echo "$payload" | message ok "Nvidia settings applied" payload ||
						echo "$payload" | message warn "Nvidia settings applied with errors, check X server running" payload
				' > /tmp/nohup.log 2>&1 &
			else
				message error "No \"nvidia_oc\" config given"
			fi
		;;
		amd_oc)
			amd_oc=$(echo $body | jq '.amd_oc' --raw-output)
			#amd_oc_old=`[[ -e $AMD_OC_CONF ]] && cat $AMD_OC_CONF`
			#if [[ $amd_oc == $amd_oc_old ]]; then
			#	echo -e "${YELLOW}AMD OC config did not change, skipping${NOCOLOR}";
			if [[ ! -z $amd_oc && $amd_oc != "null" ]]; then
				echo "$amd_oc" > $AMD_OC_CONF && sync
				nohup bash -c '
					amd-oc-safe
					exitcode=$?
					payload=`cat /var/log/amd-oc.log`
					echo "$payload"
					[[ $exitcode == 0 ]] &&
						echo "$payload" | message ok "AMD settings applied" payload ||
						echo "$payload" | message warn "AMD settings applied with errors" payload
				' > /tmp/nohup.log 2>&1 &
			else
				message error "No \"amd_oc\" config given"
			fi
		;;
		amd_download)
			gpu_index=$(echo $body | jq '.gpu_index' --raw-output)
			listjson=`gpu-detect listjson AMD`
			gpu_biosid=`echo "$listjson" | jq -r ".[$gpu_index].vbios" | sed -e 's/[\ ]/_/g'`
			gpu_type=`echo "$listjson" | jq -r ".[$gpu_index].name" | sed -e 's/[\,\.\ ]//g'`
			gpu_memsize=`echo "$listjson" | jq -r ".[$gpu_index].mem" | sed -e 's/^\(..\).*/\1/' | sed -e 's/.$/G/'`
			gpu_memtype=`echo "$listjson" | jq -r ".[$gpu_index].mem_type" | sed -e 's/[\,\.\ ]/_/g'`
			if [[ ! -z $gpu_index && $gpu_index != "null" ]]; then
			    payload=`atiflash -s $gpu_index /tmp/amd.saved.rom`
			    exitcode=$?
			    echo "$payload"
				if [[ $exitcode == 0 ]]; then
					#payload=`cat /tmp/amd.saved.rom | base64`
					#echo "$payload" | message file "VBIOS $gpu_index" payload
					cat /tmp/amd.saved.rom | gzip -9 --stdout | base64 -w 0 | message file "${WORKER_NAME}-$gpu_index-$gpu_type-$gpu_memsize-$gpu_memtype-$gpu_biosid.rom" payload
				else
					echo "$payload" | message warn "AMD VBIOS saving failed" payload
				fi
			else
				message error "No \"gpu_index\" given"
			fi
		;;
		amd_upload)
			gpu_index=$(echo $body | jq '.gpu_index' --raw-output)
			rom_base64=$(echo $body | jq '.rom_base64' --raw-output)
			if [[ -z $gpu_index || $gpu_index == "null" ]]; then
				message error "No \"gpu_index\" given"
			elif [[ -z $rom_base64 || $rom_base64 == "null" ]]; then
				message error "No \"rom_base64\" given"
			else
				force=$(echo $body | jq '.force' --raw-output)
				[[ ! -z $force && $force == "1" ]] && extra_args="-f" || extra_args=""
				echo "$rom_base64" | base64 -d | gzip -d > /tmp/amd.uploaded.rom
				fsize=`cat /tmp/amd.uploaded.rom | wc -c`
				if [[ -z $fsize || $fsize < 250000 ]]; then #too short file
					message warn "ROM file size is only $fsize bytes, there is something wrong with it, skipping"
				else
					if [[ $gpu_index == -1 ]]; then # -1 = all
				    	payload=`atiflashall $extra_args /tmp/amd.uploaded.rom`
					else
				    	payload=`echo "=== Flashing card $gpu_index ===" && atiflash -p $gpu_index $extra_args /tmp/amd.uploaded.rom`
					fi
				    exitcode=$?
				    echo "$payload"
					if [[ $exitcode == 0 ]]; then
						echo "$payload" | message ok "ROM flashing OK, now reboot" payload
					else
						echo "$payload" | message warn "ROM flashing failed" payload
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
				echo "$payload" | message ok "OpenVPN configured" payload
				hello #to give new ips and openvpn flag
			else
				echo "$payload" | message warn "OpenVPN setup failed" payload
			fi
		;;
		openvpn_remove)
			systemctl stop openvpn@client
			(rm /hive-config/openvpn/*.crt; rm /hive-config/openvpn/*.key; rm /hive-config/openvpn/*.conf; rm /hive-config/openvpn/auth.txt) > /dev/null 2>&1
			openvpn-install #will remove /tmp/.openvpn-installed file
			hello
			message ok "OpenVPN service stopped, certificates removed"
		;;
		"")
			echo -e "${YELLOW}Got empty command, might be temporary network issue${NOCOLOR}"
		;;
		*)
			message warning "Got unknown command \"$command\""
			echo -e "${YELLOW}Got unknown command ${CYAN}$command${NOCOLOR}"
		;;
	esac

	#Flush buffers if any files changed
	sync
}







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
			nvidia-oc-log
			exitcode=$?
			payload=`cat /var/log/nvidia-oc.log`
			echo "$payload"
			[[ $exitcode == 0 ]] &&
				echo "$payload" | message ok "Nvidia settings applied" payload ||
				echo "$payload" | message warn "Nvidia settings applied with errors, check X server running" payload
		fi
	fi

	if [[ ! -z $amd_oc_changed ]]; then
		#echo -e "${YELLOW}Saving AMD OC config${NOCOLOR}"
		echo "$amd_oc" > $AMD_OC_CONF && sync
		if [[ $justwrite != 1 ]]; then
			amd-oc-safe
			exitcode=$?
			payload=`cat /var/log/amd-oc.log`
			echo "$payload"
			[[ $exitcode == 0 ]] &&
				echo "$payload" | message ok "AMD settings applied" payload ||
				echo "$payload" | message warn "AMD settings applied with errors" payload
		fi
	fi
}
