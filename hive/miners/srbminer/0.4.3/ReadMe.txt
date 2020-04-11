SRBMiner-MULTI CPU & AMD GPU Miner 0.4.3
-----------------------------------------
Win64 & Linux

Download :
https://www.srbminer.com/download.html
https://github.com/doktor83/SRBMiner-Multi
https://mega.nz/#F!rBYRxArK!scVnPjMbALABivlaQhl2IQ


Support :
https://discord.gg/zXY23De
https://bitcointalk.org/index.php?topic=5190081.0

Youtube :
https://www.youtube.com/c/SRBMinerCPUGPUminer



===========================================
SUPPORTED ALGORITHMS:
===========================================

[CPU ONLY]

+ cpupower
+ defyx
+ m7mv2
+ minotaur
+ randomarq
+ randomkeva
+ randomsfx
+ randomwow
+ randomx
+ randomxl
+ yescryptr16
+ yescryptr32
+ yescryptr8
+ yespower
+ yespower2b
+ yespoweric
+ yespoweriots
+ yespoweritc
+ yespowerlitb
+ yespowerltncg
+ yespowerr16
+ yespowerres
+ yespowersugar
+ yespowerurx

[CPU & GPU]

+ bl2bsha3
+ blake2b
+ blake2s
+ cryptonight_bbc
+ cryptonight_catalans
+ cryptonight_talleo
+ eaglesong
+ k12
+ kadena
+ keccak
+ mtp
+ rainforestv2
+ tellor
+ yescrypt



===========================================
SUPPORTED GPU'S:
===========================================

+ VEGA 56/64/FE/VII
+ RX 460/470/480/550/560/570/580/590
+ R9 285/285X/380/380X
+ R9 290/290X
+ R9 Fury/Nano


===========================================
FEATURES:
===========================================

+ Guided setup mode
+ Algorithm switching capability without external application
+ Run in background without a window
+ Hashrate watchdog that restarts miner on GPU error
+ Monitoring of GPU temperature, and auto turn off if temperature is too high
+ System shutdown on too high GPU temperature
+ Miner auto restart on too many rejected shares
+ Startup monitor which ensures your miner starts working normally
+ API for miner statistics
+ Web based GUI interface for miner statistics
+ Multiple pools with failover support
+ Add new pools on the fly without restarting miner
+ Difficulty monitor, reconnects to pool if difficulty is too high
+ Job timeout monitor, reconnects to pool if no job received for a long time
+ Switch AMD video cards to compute mode easily



===========================================
ALGORITHM ALIASES/MAPPINGS:
===========================================
There are aliases/mappings defined for algorithms, so you can try to use the cryptocurrency/coin name in the 'algorithm' field.

Examples :

- You can use 'monero' for 'randomx'
- You can use 'loki' for 'randomxl'
- You can use 'cranepay' or 'bellcoin' for 'yespower'
- You can use 'aeon' or 'kangarootwelve' for 'k12'

There are a lot more predefined aliases, if you don't know the algorithm, but you know the name of the coin, try it - maybe an alias exists.



===========================================
CONFIG.TXT AVAILABLE PARAMETERS
===========================================

"algorithm" 					: algorithm name
"disable_cpu"					: disable cpu mining
"disable_gpu"					: disable gpu mining
"cpu_threads"					: how many cpu threads to use for mining
"cpu_affinity"					: thread affinity bitmask (can be digit, or hex string)
"cpu_priority"					: miner process priority, 1-5 where 5 is highest
"gpu_platform"					: opencl platform id, use this if miner can't recognise the platform automatically
"gpu_intensity" 				: 1-31, if set to 0 miner will try to find best settings (intensity, worksize, threads)
"gpu_raw_intensity" 			: number of global threads, use if you want a fine tuned intensity (also use with cryptonight algorithms)
"gpu_worksize" 					: size of local workgroup
"gpu_threads"					: number of GPU threads to use
"gpu_target_temperature" 		: number between 0-99, miner will try to maintain defined temperature on all found video cards (ADL must be enabled, works only on cards supporting OverdriveN)
"gpu_shutdown_temperature" 		: number between 0-100, if this temperature is reached, miner will shutdown system (ADL must be enabled)
"gpu_off_temperature" 			: temperature in C, when to turn off GPU if it reaches this value. After value - 15, the GPU is turned on again automatically
"gpu_tweak_profile" 			: number 0-10 , applies tweaks to the GPU that can increase hashrate. 0 - not using any tweaks, 10 - max tweaking. If you add L after the number it will use the low settings (ex. "4L")
"giveup_limit" 					: number, how many times to try connecting to a pool before switching to next pool from pools.txt. If set to 0 miner will quit and won't retry connecting.
"timeout" 						: time, when is a connection to a pool treated as timed out
"retry_time" 					: time, how much to wait before trying to reconnect to a pool
"reboot_script_gpu_watchdog" 	: filename to a batch file in miner directory, if set it turns off built in miner reset procedure on gpu failure, and instead runs this script
"main_pool_reconnect" 			: time,(minimum is 3 minutes or 180 sec), how often to try to reconnect back to the main pool. Default is 10 minutes.



===========================================
POOLS.TXT AVAILABLE PARAMETERS
===========================================

"pool" 							: address:port
"wallet" 						: your wallet
"password" 						: your password
"nicehash" 						: true or false, set this to true if you are using Nicehash
"job_timeout" 					: number in seconds, if no job is received for this period, miner will reconnect to the pool (Default is off)
"max_difficulty" 				: decimal number, if pool difficulty is above this value miner will reconnect to the pool
"tls"							: true or false, if true miner will use SSL/TLS to connect to pool
"algorithm" 					: used to inform miner which algorithm is this pool using (--list-algorithms)
"start_block_height" 			: number, start mining when defined block height is reached. Pool must send this info
"algo_min_time" 				: time, used with algorithm switching capability, minimum time to mine same algorithm. Def. is 10 min.
"keepalive"						: true of false, not every pool supports this
"worker"						: worker name (rpc2)


Example to define multiple pools (main + failover pools):

{
"pools" :
[
	{"pool" : "main_pool_address:port", "wallet" : "main_pool_wallet", "password" : "x"},
	{"pool" : "failover1_pool_address:port", "wallet" : "failover1_pool_wallet", "password" : "x"},
	{"pool" : "failover2_pool_address:port", "wallet" : "failover2_pool_wallet", "password" : "x"}
]
}



===========================================
POOL CONFIGURATION IN CMD
===========================================

--pool url:port					(pool address:port)
--wallet address				(user wallet address)
--password value				(pool password)
--tls value						(use TLS, true or false)
--nicehash value				(force nicehash, true or false)
--job-timeout value				(time, if no job received for this period, miner will reconnect. Disabled by default)
--max-difficulty value			(decimal number, if pool difficulty is above this value miner will reconnect to the pool)
--start-block-height value		(number, start mining when defined block height is reached. Pool must send this info)
--algo-min-time value			(time, used with algorithm switching capability, minimum time to mine same algorithm. Def. is 10 min.)
--keepalive value				(true or false, not every pool supports this)
--worker value					(worker name (rpc2))


Examples:

SRBMiner-MULTI.exe --algorithm randomx --pool your-pool-here --wallet your-wallet-here --password your-password-here --tls true --keepalive true --worker my_miner



===========================================
GPU CONFIGURATION IN CONFIG.TXT
===========================================

First list your GPU devices with --list-devices parameter to be able to identify your GPU's.
To manually set up video cards, you must create a "gpu_conf" array in the config.txt file.

GPU_CONF AVAILABLE PARAMETERS

"id"							: id of GPU, can be found with --list-devices parameter
"intensity"						: 1-31, if set to 0 miner will try to find best settings (intensity, worksize, threads)
"raw_intensity" 				: number of global threads, use if you want to fine tune intensity (also use with cryptonight algorithms)
"worksize" 						: size of local workgroup
"threads"						: number of GPU threads to use
"tweak_profile" 				: number 0-10 , applies tweaks to the GPU that can increase hashrate. 0 - not using any tweaks, 10 - max tweaking. If you add L after the number it will use the low settings (ex. "4L")
"target_temperature" 			: number between 0-99, miner will try to maintain defined temperature on this GPU (ADL must be enabled, works only on cards supporting OverdriveN)
"target_fan_speed" 				: 0-6000, miner will try to set the fan speed on this GPU to this value. Value is in RPM (rounds per minute) (ADL must be enabled)
"off_temperature" 				: temperature in C, when to turn off the GPU if it reaches this value. The GPU will be turned back on when it's temperature drops
"adl_type" 						: 1-3 , 1 - USE OVERDRIVEN , 2 - USE OVERDRIVE5, 3 - USE OVERDRIVE8. Default is 1 if not set. Option 2 (Overdrive5) is suitable for older cards, 3 is for Radeon VII and newer



Example :

"gpu_conf" : 
[ 
	{ "id" : 0, "intensity" : 20, "worksize" : 256, "threads" : 1},
	{ "id" : 1, "intensity" : 20, "worksize" : 256, "threads" : 1},
	{ "id" : 2, "intensity" : 15, "worksize" : 64 , "threads" : 2},
	{ "id" : 3, "intensity" : 15, "worksize" : 64 , "threads" : 2}
]



===========================================
GPU CONFIGURATION IN CMD
===========================================

First list your GPU devices with --list-devices parameter to be able to identify your GPU's.

AVAILABLE PARAMETERS

--algorithm value               	(algorithm to use)
--gpu-platform value				(force usage of specific opencl platform)
--gpu-id value                  	(gpu id from --list-devices, comma separated values)
--gpu-intensity value           	(gpu intensity, 1-31, comma separated values)
--gpu-raw-intensity value       	(gpu raw intensity, comma separated values)
--gpu-threads value             	(number of gpu threads, comma separated values)
--gpu-worksize value            	(gpu worksize, comma separated values)
--gpu-target-temperature value  	(gpu temperature, comma separated values)
--gpu-off-temperature value     	(gpu turn off temperature, comma separated values)
--gpu-target-fan-speed value    	(gpu fan speed in RPM, comma separated values)
--gpu-adl-type value            	(ADL to use (1 or 2), comma separated values)
--gpu-tweak-profile value       	(number from 0-10, 0 disables tweaking)


Examples:

SRBMiner-MULTI.exe --algorithm keccak --pool your-pool-here --wallet your-wallet-here --password your-password-here
SRBMiner-MULTI.exe --algorithm keccak --gpu-id 0,1,3 --gpu-intensity 0,0,0 --pool your-pool-here --wallet your-wallet-here --password your-password-here
SRBMiner-MULTI.exe --algorithm keccak --gpu-id 0,1,2,3,4,5 --gpu-intensity 20,20,21,24,26,26 --gpu-worksize 64,64,64,64,64,256 --gpu-threads 1,1,1,1,1,2 --pool your-pool-here --wallet your-wallet-here --password your-password-here



===========================================
CMD AVAILABLE PARAMETERS
===========================================

--adl-disable                   	(disable ADL)
--api-enable                    	(enable statistics API)
--api-port value                	(port where statistics API is reachable - default 21550)
--api-rig-name value            	(identifier name for your rig in statistics API)
--api-rig-restart-url value     	(user defined url which accessed in browser triggers computer restart)
--api-miner-restart-url value   	(user defined url which accessed in browser triggers miner restart)
--api-rig-shutdown-url value    	(user defined url which accessed in browser triggers computer shutdown)
--background                    	(run miner in background, without console window)
--config-file filename          	(use config file other than config.txt)
--cpu-affinity value            	(thread affinity bitmask)
--cpu-priority value            	(miner process priority, 1-5 where 5 is highest)
--cpu-threads                   	(how many cpu threads to use for mining)
--disable-cpu                   	(disable cpu mining)
--disable-gpu                   	(disable gpu mining)
--disable-cpu-optimisations     	(use only SSE2 for cpu mining)
--disable-extranonce-subscribe  	(don't send mining.extranonce.subscribe to pool)
--disable-gpu-watchdog          	(disable gpu crash detection)
--disable-huge-pages            	(disable usage of huge pages)
--disable-hw-aes                	(use only soft AES for cpu mining)
--disable-numa                  	(disable binding to numa nodes)
--disable-startup-monitor       	(disable watchdog for miner startup interval)
--disable-gpu-tweaking          	(disable gpu tweaking options, which are enabled by default)
--disable-msr-tweaks				(disable msr extra tweaks, which are enabled by default)
--enable-opencl-cleanup				(release ocl resources on miner exit/restart)
--enable-workers-ramp-up        	(enable workers slow start)
--enable-restart-on-rejected    	(enable miner auto restart on too many rejected shares. Set with --max-rejected-shares)
--extended-log                  	(enable more informative logging)
--forced-shutdown               	(never try to free resources on restart/shutdown)
--give-up-limit value           	(how many times to try connecting to a pool before switching to the next pool)
--gpu-errors-alert value        	(notify when number of compute errors for any GPU reaches this value [def. is 0 - disabled])
--gpu-watchdog-disable-mode     	(if enabled, watchdog will try to disable crashed gpu, instead of restarting miner)
--list-algorithms               	(list available algorithms)
--list-devices                  	(list available devices ordered by busid)
--log-file filename             	(enable logging to file)
--main-pool-reconnect value     	(time, how often to try to reconnect back to the main pool. def. is 10 minutes)
--max-no-share-sent value       	(time, if no share is accepted from the pool for x time, restarts miner [def. is 0 - disabled])
--max-rejected-shares value     	(max number of allowed rejected shares on a connection. def. is 20 if '--enable-restart-on-rejected' option enabled)
--max-startup-time value        	(time, max time to init gpu's and start mining. def. is 2 min)
--max-startup-time-script filename 	(run this script if maxstartuptime exceeded)
--pools-file filename           	(use pools file other than pools.txt)
--randomx-use-1gb-pages				(Linux only, allocate 1GB sized pages)
--msr-use-tweaks value      		(defines the msr tweaks to use 0-4, | 0 - Intel, 0,1,2,3,4 - AMD |)
--reboot-script-gpu-watchdog    	(filename, if set it turns off built in restart procedure on gpu failure, and instead runs this script)
--retry-time value              	(time, how much to wait before trying to reconnect to a pool)
--reset-vega                    	(disable/enable Vega video cards on miner start)
--send-stales                   	(send shares that miner thinks are stale to the pool)
--set-compute-mode              	(sets AMD gpu's to compute mode & disables crossfire - run as admin)
--setup                         	(interactive mode to create basic config files)
--startup-script filename       	(run custom script on miner start - set clocks, voltage, etc.)
--shutdown-temperature value    	(if this temperature is reached, miner will shutdown system (ADL must be enabled))
--watchdog-rounds value         	(after how many rounds (round is 30 sec) to trigger gpu-watchdog. def. is 5)


When setting any of the parameters don't use " or ' around the value!
Parameters that take a TIME value must be set in SECONDS!



===========================================
CPU MINING SETUP
===========================================
If you don't set the --cpu-threads or --cpu-affinity parameters, miner will try to automatically find the best setup for you system.
Sometimes the auto setup won't find the optimal settings so you should find it by experimenting.

You need to set the number of worker threads (--cpu-threads) and bind them to the appropriate PU (processing unit) with --cpu-affinity.
You can calculate the affinity mask here : https://bitsum.com/tools/cpu-affinity-calculator/

Examples to get you started:

4 CORE / 8 THREADS CPU :

1. Use 4 threads, 1 on every core : --cpu-threads 4 --cpu-affinity 0x55
2. Use 8 threads, 2 on every core : --cpu-threads 8 --cpu-affinity 0xFF

6 CORE / 12 THREADS CPU :

1. Use 6 threads, 1 on every core : --cpu-threads 6 --cpu-affinity 0x555
2. Use 12 threads, 2 on every core : --cpu-threads 12 --cpu-affinity 0xFFF



===========================================
ALGORITHM SWITCHING CAPABILITIES:
===========================================
Miner supports two types of algorithm switching :

1 - User defined algorithm in pools configuration file
2 - Pool side initiated algorithm switch

To enable the algorithm switching capability, rename 'algorithms_example.txt' file to 'algorithms.txt'.
It is very important to use only configuration files, and not mix cmd parameters & configuration files! Algorithm switching will be only enabled if you have '--config-file' parameter in your cmd line.
'--config-file' should point to the configuration file of the first entry in the pools file (main pool).


1. User defines in the pools configuration file which algorithm does a pool use.
Pools for multiple algorithms can be defined in the same configuration file, and when manual switch/auto failover of pool occurs, miner will restart with the settings of the next pool.

Example :

pools.txt :

{
"pools" :
[ 
	{
		"pool" : "loki.herominers.com:10111", 
		"wallet" : "LWC57bMh2uvQX62DT9eLkr2JvsTbeGKrcbwocNk6nAD2DXQsy4p6CJMV8zze6SYnzo2XHsdsmaDaP8Rc6JceP4WSTkRnjJF", 
		"password" : "x",
		"algorithm": "randomxl"
	},
	{
		"pool" : "xmr-eu1.nanopool.org:14444", 
		"wallet" : "4A5hJyu2FvuM2azexYssHW2odrNCNWVqLLmzCowrA57xGJLNufXfzVgcMpAy3YWpzZSAPALhVH4Ed7xo6RZYyw2bUtbm12g", 
		"password" : "x",
		"algorithm": "randomx"
	}
]
}

Start miner with:
SRBMiner-MULTI.exe --config-file Config\config-randomxl.txt --pools-file pools.txt

Miner will start mining with 'randomxl' algorithm. If user changes pool manually, or a failover switch to the next pool occurs, SRBMiner-MULTI will connect to the next pool (nanopool in this example) using the
configuration settings for 'randomx' algorithm that are read from algorithms.txt file.


2. Pools like Monero Ocean can initiate automatic algorithm switch based on profitability. How that works you can read on their page (https://moneroocean.stream/#/help/faq)



Example :

If you don't want to include every miner supported algorithm in the algorithm switching process, you need to edit the algorithms.txt file to fit your needs.

 
algorithms.txt :

This is where you define individual settings for every algorithm.
Include algorithms that you want to be available in the algorithm switching process.

Parameters:

"algorithm"			: name of the algorithm [ run miner with --list-algorithms to see available]
"config"			: path to the configuration file to use for this algorithm
"startup_script"	: path to the startup script that you want to run on miner startup
"hashrate"			: hashrate of your system on this algorithm. Used only with pool side initiated algorithm switch

Example:

{
"algorithms" :
[
	{
		"algorithm" : "randomx",
		"config" : "Config\\config-randomx.txt",
		"startup_script": "",
		"hashrate" : 1400
	},
	{
		"algorithm" : "randomxl",
		"config" : "Config\\config-randomxl.txt",
		"startup_script": "",
		"hashrate" : 1450
	}
]
}



===========================================
RANDOMX EXTRA TWEAKS 
===========================================

To enjoy the benefits of the increased hashrate:

1. Miner must run with administrator privileges [right click on SRBMiner-MULTI.exe->properties->compatibility-> check 'Run this program as an administrator' option-> click OK button
2. Make sure WinRing0x64.sys is in the same folder as SRBMiner-MULTI.exe
 
Enabling the extra tweaks, some register values are changed which will revert back on miner exit.

If miner starts crashing, or creates bad results after enabling the extra tweaks, you can try the '--randomx-use-tweaks' parameter, where you can define which tweak/s you want to enable.
Without this option miner enables all available tweaks (same as --randomx-use-tweaks 0123 for AMD, --randomx-use-tweaks 0 for Intel) , but with '--randomx-use-tweaks' you can define which ones you want to use.

There are at the moment :
Intel - 1 tweak
Amd - 5 tweaks

Index starts from 0, so you have 0 1 2 3 4 for options on AMD.


Here's an example :

+ Use tweaks number 0 and 3 (dont use 1 and 2)

SRBMiner-MULTI.exe --algorithm randomx --pool your-pool-here --wallet your-wallet-here --password your-password-here --randomx-use-tweaks 03

The order of tweaks doesn't matter, so writing 03 is same as 30.

What you should do is to find which tweak, or combination of tweaks, makes the problems. 
You should try enabling tweaks one by one, and test to see if miner runs stable with one tweak, and if it does, test the next one etc.
Luckily there are not so many combinations for you try (because 0123 is for example same as 3021 or 1302.. )

So start with :
SRBMiner-MULTI.exe --algorithm randomx --pool your-pool-here --wallet your-wallet-here --password your-password-here --randomx-use-tweaks 0

If it runs without crashing for some time, try the next one :

SRBMiner-MULTI.exe --algorithm randomx --pool your-pool-here --wallet your-wallet-here --password your-password-here --randomx-use-tweaks 1

and so on, until you find the one that makes the trouble.

Then try combining tweaks to find a combination that works for you.

If you have older gen. Ryzens, try this combination of tweaks : --randomx-use-tweaks 0134



===========================================
GPU TWEAKING PROFILES (WINDOWS ONLY)
===========================================

[VEGA56/64/FE/VII] & [RX 550/560, RX 470/480/570/580/590]

If you have VEGA56/64/FE/VII cards i recommend using the 'tweak_profile' parameter because it can increase your hashrate on some algorithms!
For RX series cards, the 'tweak_profile' option can bring some extra hash for your modded GPU.
It can be used on stock bios GPU's too, but the performance will be far from the performance of a modded bios.

Please read these VERY IMPORTANT things:

1. Miner must run with administrator privileges [right click on SRBMiner-MULTI.exe->properties->compatibility-> check 'Run this program as an administrator' option-> click OK button
2. Be patient, it takes some time to find optimal settings for your gpu/rig. Always test 1 card at a time.
3. If you start getting invalid shares or compute errors, that means the profile is too much for that gpu, so lower it. Or decrease your memory frequency.

To use in config file, use the "tweak_profile" parameter on top of config so the same profile is used for all cards, or in gpu_conf to set a different profile for every card.
Not every gpu can handle the same profile, so you need to find the right one for every gpu you have.

Tweak levels :

0 - no change, uses your original settings
1 - light tweak
2
3
4
10 - max tweak

Every profile has also weaker (low) settings. To use the low profile, add L after the profile number.
If using gpu setup in cmd it would look like this for example: --gpu-tweak-profile 3,4,4L,5L
If using config file, you must surround the value with quotation marks if you want to use the L profile. Example : "5L"

The simplest mode to apply a tweak profile is by using + or - on your keyboard while the miner is running.

Example for cmdline setup [4 gpu]:
Gpu 0 uses profile 3
Gpu 1 uses low profile 4
Gpu 2 uses low profile 4
Gpu 3 uses profile 5

SRBMiner-MULTI.exe --algorithm keccak --gpu-id 0,1,2,3 --gpu-intensity 20,23,23,24 --gpu-worksize 64,64,64,256 --gpu-threads 1,1,1,2 --gpu-tweak-profile 3,4L,4L,5 --pool your-pool-here --wallet your-wallet-here


Same example as above, using config file setup:

{
"algorithm" : "keccak",
"intensity" : 0,
"gpu_conf" : 
[ 
	{ 
	  "id" : 0, 
	  "intensity" : 20,
	  "worksize" : 64,
	  "threads" : 1,
	  "tweak_profile" : 3
	},
	{ 
	  "id" : 1, 
	  "intensity" : 23,
	  "worksize" : 64,
	  "threads" : 1,
	  "tweak_profile" : "4L"
	},
	{ 
	  "id" : 2, 
	  "intensity" : 23,
	  "worksize" : 64,
	  "threads" : 1,
	  "tweak_profile" : "4L"
	},
	{ 
	  "id" : 3, 
	  "intensity" : 24,
	  "worksize" : 256,
	  "threads" : 2,
	  "tweak_profile" : 5
	}
]
}



===========================================
GUI WEB STATISTICS
===========================================

First you must enable API, by using the --api-enable parameter in start.bat
Set your rig (computer) name with --api-rig-name rig_name also in start.bat

After you have started the miner, you can access the stats page in your browser :
http://127.0.0.1:21550/stats

There are also three other parameters that can help you to restart miner, reboot or shutdown your machine remotely :

--api-rig-restart-url
This should be a unique string, which accessed in browser results in a computer restart. Miner needs to have admin privileges.

--api-rig-shutdown-url
This should be a unique string, which accessed in browser results in a computer shutdown. Miner needs to have admin privileges.

--api-miner-restart-url
This should be a unique string, which accessed in browser restarts SRBMiner-MULTI.



Example :
SRBMiner-MULTI.exe --config-file Config\config-randomxl.txt --pools-file Pools\pools.txt --api-enable --api-rig-restart-url 12345fff --api-rig-shutdown-url 54321fff --api-miner-restart-url restart_my_srb

Visiting this url restarts your machine:
http://127.0.0.1:21550/12345fff

Visiting this url turns off your machine:
http://127.0.0.1:21550/54321fff

Visiting this url restarts SRBMiner-MULTI:
http://127.0.0.1:21550/restart_my_srb



===========================================
BACKGROUND MODE (WINDOWS ONLY)
===========================================

Background mode means that miner will run without a console window. CPU & GPU mining can both work in background mode.
The SRBMiner-MULTI process can be found in the task-manager, if you want to stop/kill the process working in the background.

Example:
Start CPU mining in background (without console window), using 3 CPU threads

SRBMiner-MULTI.exe --algorithm k12 --pool your-pool-here --wallet your-wallet-here --cpu-threads 3 --disable-gpu --background



===========================================
USAGE EXAMPLES
===========================================

1. Disable CPU mining, use only GPU mining

SRBMiner-MULTI.exe --algorithm keccak --pool your-pool-here --wallet your-wallet-here --disable-cpu

2. Run miner in background without console window, with API enabled on port 17644 (http://127.0.0.1:17644)

SRBMiner-MULTI.exe --algorithm keccak --pool your-pool-here --wallet your-wallet-here --background --api-enable --api-port 17644

3. Disable GPU mining, use 7 CPU threads with extended logging enabled and saved to Logs\log.txt file

SRBMiner-MULTI.exe --algorithm keccak --pool your-pool-here --wallet your-wallet-here --disable-gpu --cpu-threads 7 --log-file Logs\log.txt --extended-log

4. Full example for CPU & GPU mining set only from cmd (4 GPU/s used and 7 CPU threads on K12 algorithm)

SRBMiner-MULTI.exe --algorithm k12 --gpu-id 0,1,2,3 --gpu-intensity 26,25,26,26 --gpu-worksize 256,256,256,256 --gpu-threads 1,1,1,1 --cpu-threads 7 --pool your-pool-here --wallet your-wallet-here

5. Disable GPU mining, use 15 CPU threads with extended logging enabled and saved to Logs\log.txt file, start mining Randomx from block height 1978433 and run miner in background

SRBMiner-MULTI.exe --algorithm randomx --pool your-pool-here --wallet your-wallet-here --disable-gpu --cpu-threads 15 --log-file Logs\log.txt --extended-log --background --start-block-height 1978433



===========================================
KEYBOARD SHORTCUTS
===========================================

- Press 's' to see some basic stats
- Press 'h' to see hashing speed
- Press 'r' to reload pools
- Press 'p' to switch to the next pool
- Press 'o' to switch to the previous pool
- Press number from 0-9 to disable/enable from gpu0-gpu9, then shift+0 for gpu10, shift+1 for gpu11..etc. until gpu19 max (use US keyboard where SHIFT+1 = !, SHIFT+2 = @ ..etc..)
- Press + or - to change tweak profile



===========================================
INFORMATIONS, NOTES AND LICENSES
===========================================

If you get "Insufficient system resources available to allocate X kB in large-page memory" message, that means you dont have enough FREE memory left, a computer restart should solve this.
Large-page memory regions may be difficult to obtain after the system has been running for a long time because the physical space for each large page must be contiguous, but the memory may have become fragmented.
If you still get this message even after restarting, try increasing virtual memory.


SRBMiner-MULTI uses a part of WinIO library from Yariv Kaplan.
SRBMiner-MULTI uses a part of WinRing0 library from OpenLibSys.org.
SRBMiner-MULTI uses the RandomX library from Tevador (tevador@gmail.com).


LICENSES:

WinIO
==============
END USER LICENSE AGREEMENT

Software License Agreement for WinIo
The following terms apply to all files associated with the software unless
explicitly disclaimed in individual files.

IMPORTANT- PLEASE READ CAREFULLY: BY INSTALLING THE SOFTWARE (AS DEFINED BELOW),
OR COPYING THE SOFTWARE, YOU (EITHER ON BEHALF OF YOURSELF AS AN INDIVIDUAL OR
ON BEHALF OF AN ENTITY AS ITS AUTHORIZED REPRESENTATIVE) AGREE TO ALL OF THE
TERMS OF THIS END USER LICENSE AGREEMENT ("AGREEMENT") REGARDING YOUR USE OF
THE SOFTWARE. IF YOU DO NOT AGREE WITH ALL OF THE TERMS OF THIS AGREEMENT, DO
NOT INSTALL, COPY OR OTHERWISE USE THE SOFTWARE.

1. GRANT OF LICENSE: Subject to the terms below, Yariv Kaplan ("AUTHOR") hereby
grants you a non-exclusive, non-transferable, non-assignable license to install
and to use the downloadable version of WinIo ("SOFTWARE").

a. Redistributable Code. You may reproduce and distribute the object code form
of the SOFTWARE solely in conjunction with, and as part of, your application
("Permitted Application"); provided that you comply with the following:

If you redistribute any portion of the Redistributable Code, you agree that:

(i) you will only distribute the Redistributable Code in conjunction with, and
as part of, your Permitted Application which adds significant functionality to
the Redistributable Code and that distribution of the Permitted Application does
not compete with the AUTHOR's distribution of the SOFTWARE;

(ii) you will include a valid copyright notice on your Permitted Application;

(iii) you will not permit further redistribution of the Redistributable Code;

(iv) you will indemnify, hold harmless, and defend the AUTHOR from and against
any claims or lawsuits, including attorneys' fees, that arise or result from
the use or distribution of your Permitted Application.

b. License to use Source Code. You may not sell, lease, rent, transfer or
sublicense the source code of this SOFTWARE.

2. MODIFICATION: SOFTWARE Source Code may be modified without the prior written
permission of the AUTHOR. Any modifications made to the SOFTWARE will continue
to be subject to the terms and conditions of this AGREEMENT.

3. COPYRIGHT: All rights, title, and copyrights in and to the SOFTWARE and any
copies of the SOFTWARE are owned by the AUTHOR. The SOFTWARE is protected by
copyright laws and international treaty provisions. Therefore, you must treat
the SOFTWARE like any other copyrighted material.

4. TITLE: You acknowledge that no title to the intellectual property in the
SOFTWARE is transferred to you. Title, ownership, rights, and intellectual
property rights in and to the SOFTWARE shall remain the exclusive property of
the AUTHOR. The SOFTWARE is protected by copyright laws of the United States
and international treaties.

5. LIMITATION OF LIABILITY: You must assume the entire risk of using the
SOFTWARE.

IN NO EVENT SHALL THE AUTHOR BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT,
SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OF THIS
SOFTWARE, ITS DOCUMENTATION, OR ANY DERIVATIVES THEREOF, EVEN IF THE AUTHOR
HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

THE AUTHOR SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, AND NON-INFRINGEMENT. THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS,
AND THE AUTHOR HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
ENHANCEMENTS, OR MODIFICATIONS.




WinRing0
==============
Copyright (c) 2007-2009 OpenLibSys.org. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.




RandomX
==============
Copyright (c) 2018-2019, tevador <tevador@gmail.com>
Copyright (c) 2014-2019, The Monero Project

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
	* Redistributions of source code must retain the above copyright
	  notice, this list of conditions and the following disclaimer.
	* Redistributions in binary form must reproduce the above copyright
	  notice, this list of conditions and the following disclaimer in the
	  documentation and/or other materials provided with the distribution.
	* Neither the name of the copyright holder nor the
	  names of its contributors may be used to endorse or promote products
	  derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
