#!/usr/bin/env bash
#cardno=1
#VEGAS_COUNT=$( lspci -vnns 05:00.0 | grep VGA -A 2 | grep AMD -A 2 | grep Vega -A 2 | grep -v "Vega 8"|wc -l )
pp_table="b6020801005c00e1060000ee2b00001b004800000080a90300f04902008e0008000000000000000000000000000002015c004f02460294009e01be0028017a008c00bc0100000000720200009000a8026d0143019701f049020071020202000000000000080000000000000005000700030005000000000000000108840384038403840384038403840384030101840301018403000860ea00000040190100018038010002dc4a010003905f010004007701000590910100066cb00100070108d04c01000000800000000000001c83010001000000000000000070a7010002000000000000000088bc010003000000000000000038c1010004000000000000000088d5010005000000000100000070d90100060000000001000000E0220200070000000001000000000560ea00000040190100008038010000dc4a010000905f0100000008286e0000002cc9000001f80b0100028038010003905f010004f491010005d0b0010006c0d401000700086c39000000245e000001fc85000002acbc00000334d0000004686e0100050897010006eca30100070001683c01000001043c41000000000050c3000000000080380100020000289A01000400000108009885000040b5000060ea000050c300000180bb000060ea0000940b010050c300000200e10000940b01004019010050c300000378ff0000401901008826010050c300000440190100803801008038010050c300000580380100dc4a0100dc4a010050c30000060077010000770100905f010050c300000790910100909101000077010050c300000118000000000000000be412600960094b000a0054039001900190019001900190019001000000000002043107dc00dc00dc0090010000590069004a004a005f007300730064004000909297609600905500000000000000000000000000000000000202d4300000021060ea00000210"

#echo -n $pp_table | xxd -r -p > /sys/class/drm/card$cardno/device/pp_table

echo -n $pp_table > /tmp/PPT_$cardno
pp_work=/tmp/PPT_$cardno

if [[ $VEGAS_COUNT -ne 0 ]]; then
	echo "VEGAS_COUNT is $VEGAS_COUNT, exiting"
	exit 0
fi

function _SetcoreVDDC {
	corevddc=`echo $(printf %04X $1 | grep -o .. | tac | tr -d '\n')`
	corevddcstring="$corevddc$corevddc$corevddc$corevddc$corevddc$corevddc$corevddc$corevddc"0101"$corevddc"
	echo $corevddcstring
	#save to pp_work
	echo -n "$corevddcstring" | dd of=$pp_work bs=1 count=40 seek=248 conv=notrunc
}	


function _SetcoreClock {
	coreclock=`echo $(printf %06X $(($1*100)) | grep -o .. | tac | tr -d '\n')`
	coreclockstring=$coreclock"00070000000001000000"
	echo $coreclockstring
	#save to pp_work (only DPM7 state for VEGA)
	echo -n "$coreclockstring" | dd of=$pp_work bs=1 count=26 seek=566 conv=notrunc
}	


function _SetmemClock {
	memclock=`echo $(printf %06X $(($1*100)) | grep -o .. | tac | tr -d '\n')`
	memclockstring=$memclock
	echo $memclockstring
	#save to pp_work (only M3 state for VEGA)
	echo -n "$memclockstring" | dd of=$pp_work bs=1 count=6 seek=874 conv=notrunc
}	

if [[ ! -z $MEM_CLOCK && ${MEM_CLOCK[$i]} > 0 ]]; then
	_SetmemClock ${MEM_CLOCK[$i]}
fi

if [[ ! -z $CORE_CLOCK && ${CORE_CLOCK[$i]} > 0 ]]; then
	_SetcoreClock ${CORE_CLOCK[$i]}
fi

if [[ ! -z $CORE_VDDC && ${CORE_VDDC[$i]} > 0 ]]; then
	_SetcoreVDDC ${CORE_VDDC[$i]}
	cat $pp_work | xxd -r -p > /sys/class/drm/card$cardno/device/pp_table
	rocm-smi -d $cardno --setfan 125
fi


##Saving pp_work to Sysfs

##Turn On  fans on 50% ( it's stops after apply pp_table)
#	rocm-smi -d $cardno --setfan 125

[[ ! -z $FAN && ${FAN[$i]} > 0 ]] &&
	wolfamdctrl -i $cardno --set-fanspeed ${FAN[$i]}
