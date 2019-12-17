#!/bin/bash

# install optinal WiFi drivers

for opt in "$@"
do
	case $opt in

		8812)
		    apt-get update
			apt-get install rtl8812au-dkms
			;;

		8192)
			# D-Link DWA-131 rev E1, TP-Link TL-WN821N v6, TL-WN823N v2
			cd /tmp
			git clone https://github.com/Mange/rtl8192eu-linux-driver
			cd rtl8192eu-linux-driver
			dkms add .
			dkms install rtl8192eu/1.0
			modprobe 8192eu
			#echo "blacklist rtl8xxxu" | tee /etc/modprobe.d/rtl8xxxu.conf
			#echo -e "8192eu\n\nloop" | tee /etc/modules
			echo "options 8192eu rtw_power_mgnt=0 rtw_enusbss=0" | tee /etc/modprobe.d/8192eu.conf
			;;

		8192-remove)			
			dkms remove rtl8192eu/1.0 --all
			;;

		bcm)
		    # some bcm drivers
		    apt-get update
			apt-get --reinstall install bcmwl-kernel-source
			modprobe -r b43 ssb wl brcmfmac brcmsmac bcma
			modprobe wl
			;;

		 *) #-h|--help)
		 	break
			;;

	esac

	exit
done

echo -e "Optional WiFi drivers installation"
echo -e "Usage: $0 [driver]"
echo -e "  rt8812  USB-AC56 & etc (RTL8812AU)"
echo -e "  rt8192  DWA-131 rev E1, TL-WN821Nv6, TL-WN823Nv2 & etc (RTL8192EU)"
echo -e "  bcm     Some Broadcom adapters"

exit 0
