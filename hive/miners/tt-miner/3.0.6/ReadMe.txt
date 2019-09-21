Please find below the available parameter and arguments, arguments in [] are not required:

-a, -A, -algo		ALGONAME	select the algorithm to use for mining
			ETHASH		Ethash (ETH, ETC, Music, Callisto, etc)
			UBQHASH		Ubiq version of Ethash (UBIQ)
			TETHASHV1	Teo version of Ethash (TEO)
			PROGPOW		ProgPoW (BitcoinInterest)
			PROGPOWZ	ProgPoWZ (Zano)
			PROGPOW092	ProgPoW-Rev.0.9.2 (Hydnora, Sero, Abassian)
			MTP		MTP (Zcoin)
			MYRGR		Myriad-Groestl (Myriad, DigiByte, Verge, etc)
			LYRA2V3		Lyra2 Revision 3 (Vertcoin)
			HONEYCOMB	HoneyComb (BeeNode)

-AALT			ALGONAME	select the algorithm to use for mining the alternate coin

This parameter will always load the algo that fits best to the installed driver. If you want 
to make sure that TT-Miner uses a certain cuda version please append one of these values:
			-92		for cuda 9.20	(ETHASH-92, UBQHASH-92)
			-100		for cuda 10.00	(ETHASH-100, PROGPOW-100)
			-101		for cuda 10.10	(ETHASH-101, MTP-101)

Please note these requirements for the different cuda toolkit releases:
Cuda-Toolkit		Linux		Windows
CUDA 10.1.105		>= 418.39	>= 418.96
CUDA 10.0.130		>= 410.48	>= 411.31
CUDA 9.2.148		>= 396.37	>= 398.26


-d, -device, -devices	Comma or space separated list of devices that should be used mining. IDs starts with 0
-gpus
 
-coin			defines the coin you want to mine. That helps for connection to some pools (SERO) and can
			avoid unnecessary DAG creation for the DevFee
			HORA		Hora (https://www.hydnora.org/)
			EPIC		Epic (https://https://epic.tech)
			SERO		Sero (https://sero.cash)
			BNA		Abassian (https://abassian.com/)

-work-timeout		NOT supported (ignored)

-i, -mi, -intensity	Comma or space separated list of intensities that should be used mining. First value
			for first GPU and so on. A single value sets the same intensity to all GPUs. A value
			of -1 uses the default intensity of the miner. A sample may look like this:
			-i 18,17,-1,18		sets intensity of 18 to the first and fourth GPU, 17 to the 
						second and the third keeps the default of the miner. The GPUs
						are the GPUs you may have selected with the -d parameter. If you
						have installed 6 GPUs and use -d 3 4, the parameter -i 19 18
						will set the intensity of 19 to your system GPU 3 and 18 to GPU 4.

-ig, -gs		intensity grid/grid-size. Same as intensity (-i, -intensity) just defines the size for the grid directly.
			This will give you more and finer control about the number of threads that should run on the gpu.

-ib, -bs		not supported! intensity block/block-size. Allows to define a fixed block size for the cuda kernel. If you do
			not specify thzis option TT-Miner will try to find the best value for the blocksize.

-tstop                  Stop mining on a GPU if temperature exceeds value. 0 is disabled. Default: 0
-tstart                 Restart mining on a GPU if the temperature drops below. Default: 40


			API options Monitor/Control:
-b, --api-bind		IP[:port]		enables the monitoring API of TT-Miner to the IP address. If you
						omit the port, port 4068 is used as default
--api-type		Protocol		TCP/WebSocket - parameter ignored
--api-password		password		assigns a password to the API


			Parameter without argument
-RH, -rate		Reports the current hashrate every 90 seconds to the pool
-DSS			Drop stalled shares even if 'Clean Jobs' in mining.notify is set to FALSE
-n, -list, -ndevs	List the detected CUDA devices and exit
-logpool		Enable logging of the pool communication. TT-Miner creates the pool-logfile in the folder 'Logs'.
-log			Enable logging of screen output and additional information, the file is created in the folder 'Logs'.
-poolinfo, -pi		Show information of the active pool
-luck			Show a second information line that shows you how long it should take to find a new solution (share).

				Additionally the time already spend on the new solutions is printed and also a 'luck' value
				in percent that shows you the progress. Values below 100% indicate that there is still time
				left until the next solution should be found. Values above 100% indicate that the miner needs
				more time to find the new share than expected. These values are 'long term' statistical
				indications.
-U, --nvidia		Mining using CUDA devices (just for combability - can be omitted)
-X			Mining with OpenCL (just for combability - NOT supported)
-G, --amd		Mining using AMD devices (just for combability - NOT supported)
-h, --help 		Show this help and exit
-v, --version		Show TT-Miner version and exit
-nocolor		Disables color output
-notimestamp		Disables timestamp in output
-ccd			Create a crashdump file for debugging (default: no crashdump created)


			Pool definition - defines all values that are required for a connection to a mining pool.
-P			[scheme://]user/wallet[.workername/username][:password]@hostname:port

			The minimal definition to connect to a pool is:
			-P YOUR_WALLET@YOUR_SERVER_IP:YOUR_SERVER_PORT

			With all options it look like this
			-P stratum+tcp://YOUR_WALLET.YOUR_WORKER:YOUR_PASSWORD@YOUR_SERVER_IP:YOUR_SERVER_PORT

			'stratum+tcp://' is not required because TT-Miner will try to detect which stratum protocol is in use.
			The first -P will define your primary pool, all following -P definition will work as
			backup/failover pool.

-o, -pool, -url		YOUR_SERVER_IP:YOUR_SERVER_POOL
-u, -user, -wal		YOUR_WALLET[.YOUR_WORKER] or YOUR_USER
-p, -pass		YOUR_PASSWORD
-w, -worker		YOUR_WORKER

-pool2			YOUR_BACKUP_SERVER_IP:YOUR_BACKUP_SERVER_POOL
-user2, wal2		YOUR_BACKUP_WALLET[.YOUR_BACKUP_WORKER] or YOUR_BACKUP_USER
-pass2			YOUR_BACKUP_PASSWORD
-worker2		YOUR_BACKUP_WORKER

-PP INT			Process-Priority
			This option set the process priority for TT-Miner to a different level:
			 1 low
			 2 below normal
			 3 normal
			 4 above normal
			 5 high
			Default: -PP 3
			
			Screen-Output
-PRGN			Performance-Report GPU-name
			Prints the name/model in the performance report

-PRHRI INT		Performance-Report Hash-Rate Interval
			Performance-Report & information after INT multiple of one minute. Minimum value for INT is
			1 which creates a hashrate interval of a minute. Higher Intervals gives you a more stable
			hashrate. If the interval is too high the displayed average of your hashrate will change
			very slowly. The default of 2 will give you an average of 2 minutes.
			Default: -PRHRI 2

-PRT INT		Performance-Report & information after INT multiple of 5 seconds
			Set INT to 0 to disable output after a fixed timeframe
			sample -RPT 24 shows the performance report after 24 * 5 sec = 2 minutes
			Default: -PRT 3

-PRS INT		Performance-Report & information after a INT shares found
			Set INT to 0 to disable output after a fixed number of shares
			sample -RPS 10 shows the performance report after 10 shares were found
			Default: -PRS 0

			Mixed sample:
				- You want to see the performance report all 25 shares and all 30 secs:
					-PRS 25 -PRT 6
				- You do not want to see any performance report:
					-PRT 0
