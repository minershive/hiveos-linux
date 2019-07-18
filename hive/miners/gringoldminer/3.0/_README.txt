GGM3
-----------------------------------

Make sure you have latest drivers. PTX JIT failure on nvidia is an indication that drivers don't have Cuda10 support.
Check with nvidia-smi.

Miner can accept some command line arguments like api-port=5777 or configpath=/path/to/
All possible arguments are documented at: https://gist.github.com/urza/331bf94b78a3c1bf04a1f8104f6b41cb

First run will generate config.xml and ask for stratum connections and try to auto-detect GPU devices.
If you want to run directly without waiting for user input you have 2 options:
1. Make sure config.xml exists in directory of miner executable
	- see manual_config.xml for example and modify your values
	- you can also read config from other location with ./GrinProMiner configpath=/absolute/path/to/directory
	(path must be absolute, must exist and must contain config.xml)
2. You can use command-line arguments (but you will lose some options, config.xml is preferred option):
	./GrinProMiner ignore-config=true stratum-address=eu-west-stratum.grinmint.com stratum-port=4416 stratum-tls=true stratum-login=logina@example.com nvidia=0 amd=0:0
	(this will ignore config.xml and will start mining on grinmint pool with 2 GPUs - one Nvidia (Device ID 0) and one AMD (platform 0, Device ID 0))

API:
Miner has JSON API:
http://localhost:5777/api
API can be used to get status of the miner, information about GPUs, Connections, Config.
API can also change current stratum connection and config options.
API DOCS: https://grinpro.io/api.html

LOGS:
Logs are saved to logs/ directory
You can set your logging preferences (or disable logging) in config.xml
	

Optimize CPU usage:

Change value in config.xml
<CPUOffloadValue>0</CPUOffloadValue>

0   - automatic CPU load balancer
10  - minimal CPU usage, less GPS
100 - maximum CPU usage, more GPS

numbers between 0 .. 100+ are possible