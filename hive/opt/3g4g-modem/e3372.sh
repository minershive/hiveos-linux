#!/usr/bin/env bash

. colors

DELAY=3
HUAWEI_STORAGE="12d1:1f01"
HUAWEI_MODEMS="12d1:14dc|12d1:14db"

function DelayDot(){
    local i=0
    while [ "$i" -le "$DELAY" ]
    do
       echo -n '.'
       sleep 1
       i=$((i+1))
    done
    echo
}

function modem_config()
{
   local config=$(cat <<EOF
DefaultVendor=0x12d1
\nDefaultProduct=0x1f01
\nTargetVendor="12d1"
\nTargetProductList="14db,14dc"
\nHuaweiNewMode=1
EOF
)
   echo -e "${CYAN}Creating modem config${NOCOLOR}"
   [[ ! -z $config ]] && echo -e $config > /etc/usb_modeswitch.d/$HUAWEI_STORAGE
}

function udev_config()
{
   local config=$(cat <<EOF
ATTRS{idVendor}=="12d1", ATTRS{idProduct}=="1f01", RUN+="usb_modeswitch '%b/%k'"
EOF
)
   echo -e "${CYAN}Configure device manager${NOCOLOR}"
   [[ ! -z $config ]] && echo $config >/etc/udev/rules.d/10-HuaweiModemStorage.rules
}

function modem_install()
{
   [[ -d /etc/usb_modeswitch.d ]] && modem_config
   [[ -d /etc/udev/rules.d ]] && udev_config
   echo "Reload udev rules" udevadm control --reload
   echo "Try switch to GSM modem ..." && usb_modeswitch usb_modeswitch -c /etc/usb_modeswitch.d/$HUAWEI_STORAGE && echo "OK" || echo "FAIL"
   sleep 0.5 && hello
   
}

function switcher_install()
{
   echo -e "${CYAN}Updating packages cache & installing usb_modeswitch package${NOCOLOR}"
   apt update
   apt install -y usb-modeswitch
}

USB_MODESWITCH_CHECK=$(dpkg -l | grep -c -w "usb-modeswitch ")
HUAWEI_CHECK=$(lsusb | grep "${HUAWEI_STORAGE}" )
echo "Huawei E3362 4G installer"
if [[ -z $HUAWEI_CHECK ]]; then
   echo -e "${RED}Could not find Huawei GSM modems in default state!${NOCOLOR}"
else
   echo -e "${GREEN}Find Huawei GSM modems in default state:${NOCOLOR}"
   echo -e "${YELLOW}$HUAWEI_CHECK${NOCOLOR}"
   # Give user time for break process in interactive mode
   echo -e "Press Ctrl+C to stop or wait $DELAY seconds to continue"
   DelayDot
   [[ $USB_MODESWITCH_CHECK -eq 0 ]] && switcher_install || echo "usb_modeswitch already installed - skipping"
   modem_install
fi
