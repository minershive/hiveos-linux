#!/usr/bin/env python3
import sys
import usb.core
import usb.util
import time
import argparse

print ('WatchDog utility started...')

resolve_value=range(30,601)
resolve_value=list(resolve_value)
resolve_value.insert(0,0)
parser = argparse.ArgumentParser()
parser.add_argument('-r', '--reset', nargs='?', type=int, choices=resolve_value, default=30, help='Time to reset in seconds. Can take value from 30 to 600. Disabled if zero.', required=True)
parser.add_argument('-p', '--power', nargs='?', type=int, choices=resolve_value, default=0, help='Time to shutdown in seconds. Can take value from 30 to 600. Disabled if zero.', required=True)
namespace=parser.parse_args(sys.argv[1:])
namespace = vars(namespace)

dev = usb.core.find(idVendor=0x11D7, idProduct=0x41FF)
if dev is None:
	raise Exception ("WatchDog not found!")
else:
	print ('WatchDog has been found!')

print('Reset option has been disabled') if namespace['reset'] is 0 else print('Reset time set to ' + str(namespace['reset']) + ' seconds')

print('Shutdown option has been disabled') if namespace['power'] is 0 else print('Shutdown time set to ' + str(namespace['power']) + ' seconds')

dev.set_configuration()
cfg = dev.get_active_configuration()
intf = cfg[(0,0)]
ep_out = usb.util.find_descriptor(
intf,
custom_match = \
lambda e: \
    usb.util.endpoint_direction(e.bEndpointAddress) == \
    usb.util.ENDPOINT_OUT)
reset = bytearray(b'RR')
power = bytearray(b'PP')
if namespace['reset'] is 0: 
	reset[1] = 0xFF
else:
	reset[1] = namespace['reset'] // 10
if namespace['power'] is 0: 
	power[1] = 0xFF
else:
	power[1] = namespace['power'] // 10
status = bytearray(b'ST')
ep_out.write(reset)
dev.read(0x81, 3, 100)
ep_out.write(power)
dev.read(0x81, 3, 100)
time.sleep(0.5)

while True:
	try:
		ep_out.write(status)
		ret = dev.read(0x81, 3, 100)
		sret = ''.join([chr(x) for x in ret[1:]])
		print (sret)
	except Exception:
		print ('WatchDog disconnect!')
		dev = usb.core.find(idVendor=0x11D7, idProduct=0x41FF)
		if(dev is not None):
			dev.set_configuration()
			cfg = dev.get_active_configuration()
			intf = cfg[(0,0)]
			ep_out = usb.util.find_descriptor(
			intf,
			custom_match = \
			lambda e: \
	    		usb.util.endpoint_direction(e.bEndpointAddress) == \
	    		usb.util.ENDPOINT_OUT)
			ep_out.write(reset)
			dev.read(0x81, 3, 100)
			ep_out.write(power)
			dev.read(0x81, 3, 100)

	time.sleep(1.0)




