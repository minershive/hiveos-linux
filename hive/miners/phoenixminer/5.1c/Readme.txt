-[ PhoenixMiner 5.1c documentation ]-

* Introduction

* Quick start

  * Download and install

  * Ethash mining command-line examples

  * Dual-mining command-line examples

  * ProgPOW command-line examples

* Features, requirements, and limitations

* Command-line arguments

  * Pool options

  * General pool options

  * Benchmark mode

  * Remote control options

  * Mining options

  * Hardware control options (you may specify these options per-GPU)

  * General Options

  * Per-GPU options

* Interactive console commands

* Configuration files

* Remote monitoring and management

* Hardware control options

* FAQ

* Troubleshooting


Introduction
************

PhoenixMiner is fast (arguably the fastest) **Ethash** (ETH, ETC,
etc.) miner that supports both AMD and Nvidia cards (including in
mixed mining rigs). It runs under Windows x64 and Linux x64 and has a
developer fee of 0.65% (the lowest in the industry). This means that
every 90 minutes the miner will mine for us, its developers, for 35
seconds.

PhoenixMiner also supports **Ubqhash** for mining UBQ, **ProgPOW** for
mining BCI, and **dual mining** Ethash/Ubqhash with **Blake2s**.

The hashrate is generally higher than Claymore’s Ethereum miner (we
have measured about 0.4-1.3% hashrate improvement but your results may
be slightly lower or higher depending on the GPUs, drivers, and other
variables). To achieve highest possible hashrate on AMD cards you may
need to manually adjust the GPU tune factor (a number from 8 to about
400, which can be changed interactively with the "+" and "-" keys
while the miner is running).

If you have used Claymore’s Dual Ethereum miner, you can switch to
PhoenixMiner with minimal hassle as we support most of Claymore’s
command-line options and configuration files.

Please note that PhoenixMiner is extensively tested on many mining
rigs but there still may be some bugs. Additionally, we are actively
working on bringing many new features in the future releases. If you
encounter any problems or have feature requests, please post them in
our thread on the bitcointalk.org forum:
https://bitcointalk.org/index.php?topic=2647654.0


Quick start
***********


Download and install
====================

You can download PhoenixMiner 5.1c from here:

https://mega.nz/#F!2VskDJrI!lsQsz1CdDe8x5cH3L8QaBw (MEGA)

Note that you need the file "PhoenixMiner_NVRTC_Windows.zip" only if
you want to mine BCI with Nvdia cards under Windows.

If you want to check the integrity of the downloaded file, you can use
the hashes (checksums) that are provided in our bitcointalk.org thread
(https://bitcointalk.org/index.php?topic=2647654.0) or the file
"PhoenixMiner_5.1c_checksums.txt" which is in the same MEGA folder as
the main PhoenixMiner archive.

Note: **Linux:** Under Linux you need to replace "PhoenixMiner.exe"
  with "./PhoenixMiner" in the command-line examples below.


Ethash mining command-line examples
===================================

Here are the command line parameters for some of the more popular
pools and coins:

ethermine.org (ETH):
      PhoenixMiner.exe -pool eu1.ethermine.org:4444 -pool2 us1.ethermine.org:4444 -wal YourEthWalletAddress.WorkerName -proto 3

ethermine.org (ETH, secure connection):
      PhoenixMiner.exe -pool ssl://eu1.ethermine.org:5555 -pool2 ssl://us1.ethermine.org:5555 -wal YourEthWalletAddress.WorkerName -proto 3

ethpool.org (ETH):
      PhoenixMiner.exe -pool eu1.ethpool.org:3333 -pool2 us1.ethpool.org:3333 -wal YourEthWalletAddress.WorkerName -proto 3

nanopool.org (ETH):
      PhoenixMiner.exe -pool eth-eu1.nanopool.org:9999 -wal YourEthWalletAddress/WorkerName -pass x

nicehash (ethash):
      PhoenixMiner.exe -pool stratum+tcp://daggerhashimoto.eu.nicehash.com:3353 -wal YourBtcWalletAddress -pass x -proto 4 -stales 0

f2pool (ETH):
      PhoenixMiner.exe -epool eth.f2pool.com:8008 -ewal YourEthWalletAddress -pass x -worker WorkerName

miningpoolhub (ETH):
      PhoenixMiner.exe -pool us-east.ethash-hub.miningpoolhub.com:20535 -wal YourLoginName.WorkerName -pass x -proto 1

coinotron.com (ETH):
      PhoenixMiner.exe -pool coinotron.com:3344 -wal YourLoginName.WorkerName -pass x -proto 1

ethermine.org (ETC):
      PhoenixMiner.exe -pool eu1-etc.ethermine.org:4444 -wal YourEtcWalletAddress.WorkerName

epool.io (ETC):
      PhoenixMiner.exe -pool eu.etc.epool.io:8008 -pool2 us.etc.epool.io:8008 -worker WorkerName -wal YourEtcWalletAddress -pass x -retrydelay 2

whalesburg.com (ethash auto-switching):
      PhoenixMiner.exe -pool proxy.pool.whalesburg.com:8082 -wal YourEthWalletAddress -worker WorkerName -proto 2

miningpoolhub (EXP):
      PhoenixMiner.exe -pool us-east.ethash-hub.miningpoolhub.com:20565 -wal YourLoginName.WorkerName -pass x -proto 1

miningpoolhub (MUSIC):
      PhoenixMiner.exe -pool europe.ethash-hub.miningpoolhub.com:20585 -wal YourLoginName.WorkerName -pass x -proto 1

maxhash.org (UBIQ):
      PhoenixMiner.exe -pool ubiq-us.maxhash.org:10008 -wal YourUbqWalletAddress -worker WorkerName -coin ubq

ubiq.minerpool.net (UBIQ):
      PhoenixMiner.exe -pool lb.geo.ubiqpool.org:8001 -wal YourUbqWalletAddress -pass x -worker WorkerName -coin ubq

ubiqpool.io (UBIQ):
      PhoenixMiner.exe -pool eu2.ubiqpool.io:8008 -wal YourUbqWalletAddress.WorkerName -pass x -proto 4 -coin ubq

minerpool.net (PIRL):
      PhoenixMiner.exe -pool pirl.minerpool.net:8002 -wal YourPirlWalletAddress -pass x -worker WorkerName

etp.2miners.com (Metaverse ETP):
      PhoenixMiner.exe -pool etp.2miners.com:9292 -wal YourMetaverseETPWalletAddress -worker Rig1 -pass x

minerpool.net (Ellaism):
      PhoenixMiner.exe -pool ella.minerpool.net:8002 -wal YourEllaismWalletAddress -worker Rig1 -pass x

etherdig.net (ETH PPS):
      PhoenixMiner.exe -pool etherdig.net:4444 -wal YourEthWalletAddress.WorkerName -proto 4 -pass x

etherdig.net (ETH HVPPS):
      PhoenixMiner.exe -pool etherdig.net:3333 -wal YourEthWalletAddress.WorkerName -proto 4 -pass x

epool.io (CLO):
      PhoenixMiner.exe -pool eu.clo.epool.io:8008 -pool2 us.clo.epool.io:8008 -worker WorkerName -wal YourEthWalletAddress -pass x -coin clo -retrydelay 2

baikalmine.com (CLO):
      PhoenixMiner.exe -pool clo.baikalmine.com:3333 -wal YourEthWalletAddress -pass x -coin clo -worker rigName


Dual-mining command-line examples
=================================

ETH on ethermine.org ETH, Blake2s on Nicehash:
      PhoenixMiner.exe -pool ssl://eu1.ethermine.org:5555 -pool2 ssl://us1.ethermine.org:5555 -wal YourEthWalletAddress.WorkerName -proto 3 -dpool blake2s.eu.nicehash.com:3361 -dwal YourBtcWalletAddress -dcoin blake2s

Nicehash (Ethash + Blake2s):
      PhoenixMiner.exe -pool stratum+tcp://daggerhashimoto.eu.nicehash.com:3353 -wal YourBtcWalletAddress -pass x -proto 4 -stales 0 -dpool blake2s.eu.nicehash.com:3361 -dwal YourBtcWalletAddress -dcoin blake2s


ProgPOW command-line examples
=============================

BCI on Suprnova.cc:
      PhoenixMiner.exe -pool bci.suprnova.cc:9166 -wal YourSupernovaLogin -coin bci


Features, requirements, and limitations
***************************************

* Highly optimized OpenCL and CUDA cores for maximum ethash mining
  speed

* Lowest developer fee of 0.65% (35 seconds defvee mining per each
  90 minutes)

* Dual mining ethash/Blake2s with lowest devfee of 0.9% (35 seconds
  defvee mining per each 65 minutes)

* Advanced statistics: actual difficulty of each share as well as
  effective hashrate at the pool

* Supports AMD RX5500, RX5700, Radeon VII, Vega,
  590/580/570/480/470, 460/560, Fury, 390/290 and older AMD GPUs with
  enough VRAM

* Supports Nvidia 20x0, 16x0, 10x0 and 9x0 series as well as older
  cards with enough VRAM

* DAG file generation in the GPU for faster start-up and DAG epoch
  switches

* Supports all ethash mining pools and stratum protocols, including
  solo mining via HTTP

* Supports secure pool connections (e.g.
  "ssl://eu1.ethermine.org:5555)" to prevent IP hijacking attacks

* Detailed statistics, including the individual cards hashrate,
  shares, temperature, fan speed, clocks, voltages, etc.

* Unlimited number of fail-over pools in "epools.txt" configuration
  file (or two on the command line)

* GPU tuning for the AMD GPUs to achieve maximum performance with
  your rig

* Supports devfee on alternative ethash currencies like ETC, EXP,
  Music, UBQ, Pirl, Ellaism, Metaverse ETP, WhaleCoin, and Victorium.
  This avoids any additional loses and instabilities becuase of
  additional DAG generation, and also allows you to use older cards
  with small VRAM or low hashate on current DAG epochs (e.g. GTX970,
  280X).

* Supports the Ubqhash algorithm for the UBQ coin. Please note that
  you must add "-coin ubq" to your command line (or "COIN: ubq" to
  your "epools.txt file") in order to mine UBQ

* Supports the ProgPOW algorithm for the Bitcoin Interest (BCI) coin
  mining. Please note that you must add "-coin bci" to your command
  line (or "COIN: bci" to your "epools.txt" file) in order to mine BCI

* Full compatibility with the industry standard Claymore’s Dual
  Ethereum miner, including most of command-line options,
  configuration files, and remote monitoring and management.

* More features coming soon!

PhoenixMiner requires Windows x64 (Windows 7, Windows 10, etc.), or
Linux x64 (tested on Ubuntu LTS and Debian stable).

PhoenixMiner also supports dual mining (simultaneous mining of
ethash/ubqhash and other cryptocoin algorithm). Currently we support
only Blake2s as secondary algorithm for dual mining. Note that when
using dual mining, there is no devfee on the secondary coin but the
devfee on the main coin is increased to 0.9%. In other words, if you
are using the dual mining feature PhoenixMiner will mine for us for 35
seconds every 65 minutes.

While the miner is running, you can use some interactive commands.
Press the key "h" while the miner’s console window has the keyboard
focus to see the list of the available commands. The interactive
commands are also listed at the end of the following section.


Command-line arguments
**********************

Note that PhoenixMiner supports most of the command-line options of
Claymore’s dual Ethereum miner so you can use the same command line
options as the ones you would have used with Claymore’s miner.


Pool options
============

-pool <host:port>
   Ethash pool address (prepend the host name with "ssl://" for SSL
   pool, or "http://" for solo mining).

-wal <wallet>
   Ethash wallet (some pools require appending of user name and/or
   worker).

-pass <password>
   Ethash password (most pools don’t require it, use "x" as password
   if unsure)

-worker <name>
   Ethash worker name (most pools accept it as part of wallet)

-proto <n>
   Selects the kind of stratum protocol for the ethash pool:

   1:
      miner-proxy stratum spec (e.g. coinotron)

   2:
      eth-proxy (e.g. ethermine, nanopool) - this is the default,
      works for most pools

   3:
      qtminer (e.g. ethermine, ethpool)

   4:
      EthereumStratum/1.0.0 (e.g. nicehash)

   5:
      EthereumStratum/2.0.0

-coin <coin>
   Ethash coin to use for devfee to avoid switching DAGs:

   auto:
      Auto-detect the coin (default)

   eth:
      Ethereum

   etc:
      Ethereum Classic

   exp:
      Expanse

   music:
      Musicoin

   ubq:
      UBIQ

   pirl:
      Pirl

   ella:
      Ellaism

   etp:
      Metaverse ETP

   whale:
      WhaleCoin

   vic:
      Victorium

   nuko:
      Nekonium

   mix:
      Mix

   egem:
      EtherGem

   clo:
      Callisto

   dbix:
      DubaiCoin

   moac:
      MOAC

   etho:
      Ether-1

   yoc:
      Yocoin

   b2g:
      Bitcoiin2Gen

   esn:
      Ethersocial

   ath:
      Atheios

   reosc:
      REOSC

   qkc:
      QuarkChain

   bci:
      Bitcoin Interest

-stales <n>
   Submit stales to ethash pool: 1 - yes (default), 0 - no

-pool2 <host:port>
   Failover ethash pool address. Same as "-pool" but for the failover
   pool

-wal2 <wallet>
   Failover ethash wallet (if missing "-wal" will be used for the
   failover pool too)

-pass2 <password>
   Failover ethash password (if missing "-pass" will be used for the
   failover pool too)

-worker2 <name>
   Failover ethash worker name (if missing "-worker" will be used for
   the failover pool too)

-proto2 <n>
   Failover ethash stratum protocol (if missing "-proto" will be used
   for the failover pool too)

-coin2 <coin>
   Failover devfee Ethash coin (if missing "-coin" will be used for
   the failover pool too)

-stales2 <n>
   Submit stales to the failover pool: 1 - yes (default), 0 - no

-dpool <host:port>
   Dual mining pool address

-dwal <wallet>
   Dual mining wallet

-dpass <password>
   Dual mining pool password (most pools don’t require it, use "x" as
   password if unsure)

-dworker <name>
   Dual mining worker name

-dcoin blake2s
   Currently only the Blake2s algorithm is supported for dual mining.
   If you want to put all dual mining pools in "dpools.txt", you need
   to set "-dcoin blake2s" in the command-line or in config.txt to
   force the miner to load the dual mining pools from "dpools.txt"

-dstales <n>
   Submit stales to the dual mining pool: 1 - yes (default), 0 - no


General pool options
====================

-fret <n>
   Switch to next pool afer N failed connection attempts (default: 3)

-ftimeout <n>
   Reconnect if no new ethash job is receved for n seconds (default:
   600)

-ptimeout <n>
   Switch back to primary pool after n minutes. This setting is 30
   minutes by default; set to 0 to disable automatic switch back to
   primary pool.

-retrydelay <n>
   Seconds to wait before reconnecting (default: 5)

-gwtime <n>
   Recheck period for Solo/GetWork mining (default: 200 ms)

-rate <n>
   Report hashrate to the pool: 1 - yes, 0 - no (1 is the default), 2
   - (for solo mining only) use alternative name of the report method
   "eth_submitHashRate" instead of "eth_submitHashrate"


Benchmark mode
==============

-bench [<n>],-benchmark [<n>]
   Benchmark mode, optionally specify DAG epoch. Use this to test your
   rig. If you specify only the "-bench" option, you will benchmark
   the ethash algorithm. If you want to bench the dual mining, use the
   options "-bench <n> -dcoin blake2s". If you want to benchmark the
   ProgPOW BCI algorithm, use the options "-bench <n> -coin bci"


Remote control options
======================

-cdm <n>
   Selects the level of support of the CDM remote monitoring:

   0:
      disabled

   1:
      read-only - this is the default

   2:
      full (only use on secure connections)

-cdmport <port>
   Set the CDM remote monitoring port (default is 3333). You can also
   specify <ip_addr:port> if you have a secure VPN connection and want
   to bind the CDM port to it

-cdmpass <pass>
   Set the CDM remote monitoring password

-cdmrs
   Reload the settings if "config.txt" is edited/uploaded remotely.
   Note that most options require restart in order to change.

   Currently the following options can be changed without restarting:
   "-mi", "-gt", "-sci", "-clf", "-nvf", "-gpow", and most of the
   hardware control parameters ("-tt", "-fcm", "-fanmin", "-fanmax",
   "-powlim", "-tmax", "-ttli", "-cclock", "-cvddc", "-mclock",
   "-mvddc", "-ppf", "-straps", "-vmt1", "-vmt2", "-vmt3", "-vmr").


Mining options
==============

-amd
   Use only AMD cards

-acm
   Turn on AMD compute mode on the supported GPUs. This is equivalent
   of pressing "y" in the miner console.

-nvidia
   Use only Nvidia cards

-gpus <123 ..n>
   Use only the specified GPUs (if more than 10, separate the indexes
   with comma)

-mi <n>
   Set the mining intensity (0 to 14; 12 is the default for new
   kernels). You may specify this option per-GPU.

-gt <n>
   Set the GPU tuning parameter (6 to 400). The default is 15. You can
   change the tuning parameter interactively with the "+" and "-" keys
   in the miner’s console window. You may specify this option per-GPU.
   If you don’t specify "-gt" or you specify value 0, the miner will
   use auto-tuning to determine the best GT value. Note that when the
   GPU is dual-mining, it ignores the "-gt" values, and uses "-sci"
   instead.

-sci <n>
   Set the dual mining intensity (1 to 1000). The default is 30. As
   you increase the value of "-sci", the secondary coin hashrate will
   increase but the price will be higher power consumption and/or
   lower ethash hashrate. You can change the this parameter
   interactively with the "+" and "-" keys in the miner’s console
   window. You may specify this option per-GPU. If you set "-sci" to
   0, the miner will use auto-tuning to determine the best value,
   while trying to maximize the ethash hashrate regardless of the
   secondary coin hashrate.

-clKernel <n>
   Type of OpenCL kernel: 0 - generic, 1 - optimized, 2 - alternative,
   3 - turbo (1 is the default) You may specify this option per-GPU.

-clgreen <n>
   Use the power-efficient (“green”) kernels (0: no, 1: yes; default:
   0). You may specify this option per-GPU. Note that you have to run
   auto-tune again as the optimal GT values are completely different
   for the green kernels

-clNew <n>
   Use new AMD kernels if supported (0: no, 1: yes; default: 1). You
   may specify this option per-GPU.

-clf <n>
   AMD kernel sync (0: never, 1: periodic; 2: always; default: 1). You
   may specify this option per-GPU.

-nvKernel <n>
   Type of Nvidia kernel: 0 auto (default), 1 old (v1), 2 newer (v2),
   3 latest (v3). Note that v3 kernels are only supported on GTX10x0
   GPUs. Also note that dual mining is supported only by v2 kernels.
   You may specify this option per-GPU.

-nvdo <n>
   Enable Nvidia driver-specific optimizations (0 - no, the default; 1
   - yes). Try "-nvdo 1" if your are unstable. You may specify this
   option per-GPU.

-nvNew <n>
   Use new Nvidia kernels if supported (0: no, 1: yes; default: 1).
   You may specify this option per-GPU.

-nvf <n>
   Nvidia kernel sync (0: never, 1: periodic; 2: always; 3: forced;
   default: 1). You may specify this option per-GPU.

-mode <n>
   Mining mode (0: dual mining if dual pool(s) are specified; 1:
   ethash only even if dual pools are specified). You may specify this
   option per-GPU.

-gbase <n>
   Set the index of the first GPU (0 or 1, default: 1)

-minRigSpeed <n>
   Restart the miner if avg 5 min speed is below <n> MH/s

-eres <n>
   Allocate DAG buffers big enough for n epochs ahead (default: 2) to
   avoid allocating new buffers on each DAG epoch switch, which should
   improve DAG switch stability. You may specify this option per-GPU.

-dagrestart <n>
   Restart the miner when allocating buffer for a new DAG epoch. The
   possible values are: 0 - never, 1 - always, 2 - auto (the miner
   decides depending on the driver version). This is relevant for 4 GB
   AMD cards, which may have problems with new DAG epochs after epoch
   350.

-lidag <n>
   Slow down DAG generation to avoid crashes when switching DAG epochs
   (0-3, default: 0 - fastest, 3 - slowest). You may specify this
   option per-GPU.

-gser <n>
   Serializing DAG creation on multiple GPUs (0 - no serializing, all
   GPUs generate the DAG simultaneously, this is the default; 1 -
   partial overlap of DAG generation on each GPU; 2 - no overlap (each
   GPU waits until the previous one has finished generating the DAG);
   3-10 - from 1 to 8 seconds delay after each GPU DAG generation
   before the next one)

-gpureset <n>
   Fully reset GPU when paused (0 - no, 1 - yes; default: no, except
   on 1080Ti). You may specify this option per-GPU.

-rvram <n>
   Minimum free VRAM in MB (-1: don’t check; default: 384 for Windows,
   and 128 for Linux)

-altinit
   Use alternative way to initialize AMD cards to prevent startup
   crashes

-wdog <n>
   Enable watchdog timer: 1 - yes, 0 - no (1 is the default). The
   watchdog timer checks periodically if any of the GPUs freezes and
   if it does, restarts the miner (see the "-rmode" command-line
   parameter for the restart modes)

-wdtimeout <n>
   Watchdog timeout (30 - 300; default 45 seconds). You can use this
   parameter to increase the default watchdog timeout in case it
   restarts the miner needlessly

-rmode <n>
   Selects the restart mode when a GPU crashes or freezes: :0:
   disabled - miner will shut down instead of restarting :1: restart
   with the same command line options - this is the default :2: reboot
   (shut down miner and execute "reboot.bat")

-log <n>
   Selects the log file mode: :0: disabled - no log file will be
   written :1: write log file but don’t show debug messages on screen
   (default) :2: write log file and show debug messages on screen

-logfile <name>
   Set the name of the logfile. If you place an asterisk (*) in the
   logfile name, it will be replaced by the current date/time to
   create a unique name every time PhoenixMiner is started. If there
   is no asterisk in the logfile name, the new log entries will be
   added to end of the same file. If you want to use the same logfile
   but the contents to be overwritten every time when you start the
   miner, put a dollar sign ($) character in the logfile name (e.g.
   "-logfile my_log.txt$").

-logdir <path>
   Set a path where the logfile(s) will be created

-logsmaxsize <n>
   Maximum size of the logfiles in MB. The default is 200 MB (use 0 to
   turn off the limitation). On startup, if the logfiles are larger
   than the specified limit, the oldest are deleted. If you use a
   single logfile (by using "-logfile"), then it is truncated if it is
   bigger than the limit and a new one is created.

-config <name>
   Load a file with configuration options that will be added to the
   command-line options. Note that the order is important.

   For example, if we have a "config.txt" file that contains "-cclock
   1000" and we specify command line "-cclock 1100 -config
   config.txt", the options from the "config.txt" file will take
   precedence and the resulting -cclock will be 1000. If the order is
   reversed ("-config config.txt -cclock 1100") then the second option
   takes precedence and the resulting -cclock will be 1100.

   Note that only one "-config" option is allowed. Also note that if
   you reload the config file with "c" key or with the remote
   interface, its options will take precedence over whatever you have
   specified in the command-line.

-timeout <n>
   Restart miner according to -rmode after n minutes

-pauseat <hh:mm>
   Pause the miner at hh:mm (24 hours time). You can specify multiple
   times: "-pauseat 6:00,12:00"

-resumeat <hh:mm>
   Resume the miner at hh::mm (24 hours time). You can specify
   multiple times: "-resumeat 8:00,22:00"

-gswin <n>
   GPU stats time window (5-30 sec; default: 15; use 0 to revert to
   pre-2.8 way of showing momentary stats)

-gsi <n>
   Speed stats interval (5-30 sec; default: 5; use 0 to disable). The
   detailed stats are still shown every 45 seconds and aren’t affected
   by the "-gsi" value

-astats <n>
   Show advanced stats from Web sources (0: no; 1: yes). By default
   the coin exchange rates are updated every 4 hours, and the coin
   difficulty is updated every 8 hours. You can increase these periods
   by specifying for example "-astats 12", which will increase update
   periods to 12 and 24 hours respectively

-gpow <n>
   Lower the GPU usage to n% of maximum (default: 100). If you already
   use "-mi 0" (or other low value) use "-li" instead. You may specify
   this option per-GPU.

-li <n>
   Another way to lower the GPU usage. Bigger n values mean less GPU
   utilization; the default is 0. You may specify this option per-GPU.

-resetoc
   Reset the HW overclocking settings on startup

-leaveoc
   Do not reset overclocking settings when closing the miner


Hardware control options (you may specify these options per-GPU)
================================================================

-tt <n>
   Set fan control target temperature (special values: 0 - no HW
   monitoring on ALL cards, 1-4 - only monitoring on all cards with
   30-120 seconds interval, negative - fixed fan speed at n %)

-hstats <n>
   Level of hardware monitoring: 0 - temperature and fan speed only; 1
   - temperature, fan speed, and power; 2 - full (include core/memory
   clocks, voltages, P-states). The default is 1.

-pidle <n>
   Idle power consumption of the rig in W. Will be added to the GPU
   power consumption when calculating the total power consumption of
   the rig.

-ppf <n>
   The power usage of each GPU will be multiplied by this value to get
   the actual usage. This value is in percent, so for example if the
   GPU reports 100 W power usage and you have specified -ppf 106 the
   GPU power usage will be calculated to be 100 * (106 / 100) = 106 W.
   This allows you to correct for the efficiency of the PSUs and the
   individual GPUs. You can also specify this value for each GPU
   separately.

-prate <n>
   Price of the electricity in USD per kWh (e.g. "-prate 0.1"). If
   specified the miner will calculate the rig daily electricity cost

-fanmin <n>
   Set fan control min speed in % (-1 for default)

-fanmax <n>
   Set fan control max speed in % (-1 for default)

-fcm <n>
   Set fan control mode (0 - auto, 1 - use VBIOS fan control, 2 -
   forced fan control; default: 0)

-fanidle <n>
   (*Linux only*) Set idle fan speed in % (-1 is auto, the default is
   20)

-fpwm <n>
   (*Linux only*) Fan PWM mode (0 - auto, 1 - direct, 2 - Polaris, 3 -
   Vega, 4 - Radeon VII, Navi; default: 0)

-tmax <n>
   Set fan control max temperature (0 for default)

-powlim <n>
   Set GPU power limit in % (from -75 to 75, 0 for default)

-cclock <n>
   Set GPU core clock in MHz (0 for default). For Nvidia cards use
   relative values (e.g. -300 or +400)

-cvddc <n>
   Set GPU core voltage in mV (0 for default)

-mclock <n>
   Set GPU memory clock in MHz (0 for default). For Nvidia cards use
   relative values (e.g. -300 or +400)

-mvddc <n>
   Set GPU memory voltage in mV (0 for default)

-tstop <n>
   Pause a GPU when temp is >= n deg C (0 for default; i.e. off)

-tstart <n>
   Resume a GPU when temp is <= n deg C (0 for default; i.e. off)

-mt <n>
   VRAM timings (AMD under Windows only): 0 - default VBIOS values; 1
   - faster timings; 2 - fastest timings. The default is 0. This is
   useful for mining with AMD cards without modding the VBIOS.

-leavemt
   Do not reset memory timing level ("-mt") to 0 when closing

-ttli <n>
   Lower GPU usage when GPU temperature is above n deg C. The default
   value is 0, which means do not lower the usage regardless of the
   GPU temperature. This option is useful whenever -tmax is not
   working. If you are using both "-tt" and "-ttli" options, the
   temperature in "-tt" should be lower than the "-ttli" to avoid
   throttling the GPUs without using the fans to properly cool them
   first.

-straps <n>
   Memory strap level (Nvidia cards 10x0 series only). The possible
   values are 0 to 6. 0 is the default value and uses the default
   timings from the VBIOS. Each strap level corresponds to a
   predefined combination of memory timings ("-vmt1", "-vmt2",
   "-vmt3", "-vmr"). Strap level 3 is the fastest predefined level and
   may not work on most cards, 1 is the slowest (but still faster than
   the default timings). Strap levels 4 to 6 are the same as 1 to 3
   but with less aggressive refresh rates (i.e. lower "-vmr" values).

-vmt1 <n>
   Memory timing parameter 1 (0 to 100, default 0)

-vmt2 <n>
   Memory timing parameter 2 (0 to 100, default 0)

-vmt3 <n>
   Memory timing parameter 3 (0 to 100, default 0)

-vmr <n>
   Memory refresh rate (0 to 100, default 0)

-nvmem <n>
   Force using straps on unsupported Nvidia GPUs (0 - do not force, 1
   - GDDR5, 2 - GDDR5X). Make sure that the parameter matches your GPU
   memory type. You can try this if your card is Pascal-based but when
   you try to use -straps or any other memory timing option, the card
   is shown as “unsupported”.


General Options
===============

-list
   List the detected GPUs devices and exit

-v,–version
   Show the version and exit

-vs
   Show short version string (e.g. "4.1c") and exit

-h,–help
   Show information about the command-line options and exit


Per-GPU options
===============

Some of the PhoenixMiner options can provide either the same setting
for all GPUs, or a different setting for each of the GPUs. For
example, to specify the "-gt" value for all cards you would write "-gt
90" but if you want to specify a different GT value for each of the
cards, use something like this: "-gt 20,15,40,90,90" for a five-GPU
mining rig. This would set GT to 20 for the first GPU, 15 for the
second GPU, and so on. If you specify less values than you have GPUs,
the rest of the GPUs will use the default value for the parameter.

You can also use another, more flexible way of specifying different
values for the different cards. This is best explained by example:
"-cclock *:1100,1-3:1090,4:1300" - here we are setting core clock to
1100 MHz for all cards, except the cards 1 to 3, on which it is set to
1090 MHz, and card 4 to 1300 MHz.

The part before the colon (:) is the selector, which selects the GPUs
for which the value after the colon is applied. The selector can be:

* single GPU index: e.g. "5:1000" sets 1000 for the 5th GPU

* range of GPU indexes: e.g "2-5:1200" sets 1200 for the GPUs 2,3,4,
  and 5

* asterisk, which sets the value for all GPUs

* label "amd" or "nvidia": e.g. "amd:1090" sets the value to 1090
  for all AMD cards

* arbitrary string that starts with letter and can contain letters,
  numbers and asterisks, which is matched with the GPU name as listed
  by PhoenixMiner. Example: "gtx*1070:+500" will set value +500 for
  all cards which contain ‘gtx’ and ‘1070’ in their names with
  anything between them. This will match ‘Nvidia GeForce GTX 1070’ but
  not ‘Nvidia GeForce 1070’.

Note that if more than one selector matches given card, than only the
last one counts. Example: "-cclock *:1100,1-4:1090,2:1300" will set
card 2 to 1300; cards 1,3, and 4 to 1090; and the rest of the cards to
1100 MHz core clock.


Interactive console commands
****************************

While the miner is running, you can use the following interactive
commands in the console window by pressing one of these keys:

* "s"   Print detailed statistics

* "1"-"9" Pause/resume GPU1 … GPU9

* "p"   Pause/resume the whole miner

* "+",``-`` Increase/decrease GPU tuning parameter

* "g"   Reset the GPU tuning parameter (and stop auto-tuning if
  active)

* "x"   Select the GPU(s) for manual or automatic GT tuning

* "z"   Start AMD auto-tune process

* "r"   Reload "epools.txt" and switch to primary ethash pool

* "e"   Select the current ethash pool

* "d"   Select the current dual-mining pool

* "y"   Turn on AMD Compute mode if it is off on some of the GPUs

* "c"   Reload the "config.txt" file (some settings require restart)

* "h"   Print this short help

When you have more than 9 GPUs (or if you are using zero-based GPU
indexing), you can press "0" key and then enter two more digits in
order to pause or resume GPU outside of the 1-9 rage. For example the
key sequence "0", "1", "2" will pause or resume GPU12, and the
sequence "0", "0", "0" will pause or resume GPU0 (if using zero-based
GPU indexing).


Configuration files
*******************

Instead of using command-line options, you can also control
PhoenixMiner with configuration files. If you run PhoenixMiner.exe
without any options, it will search for the file "config.txt" in the
current directory and will read its command-line options from it. If
you want, you can use file with another name by specifying its name as
the only command-line option when running PhoenixMiner.exe.

Note that PhoenixMiner supports the same configuration files as
Claymore’s dual Ethereum miner so you can use your existing
configuration files without any changes.

You will find an example "config.txt" file in the PhoenixMiner’s
directory.

Instead of specifying the pool(s) directly on the command line, you
can use another configuration file for this, named "epools.txt". There
you can specify one pool per line (you will find an example epools.txt
file in the PhoenixMiner’s directory).

For the dual mining pools, you can use the "dpools.txt" file, which
has the same format as "epools.txt" but for the secondary coin. You
will find an example "dpools.txt" file in the PhoenixMiner’s
directory. Note that unlike the "epools.txt", which is loaded each
time when the miner starts, the "dpools.txt" file is only read if you
specify a dual mining pool on the command line with "-dpool", or if
you add the "-dcoin blake2s" command-line option.

You can combine the config.txt file with some options that are
specified directly on the command-line by using the "-config <name>"
command-line option. It will instruct the miner to load a file with
configuration options that will be added to the options read from the
command-line.

The advantages of using "config.txt" and "epools.txt"/"dpools.txt"
files are: * If you have multiple rigs, you can copy and paste all
settings with these files * If you control your rigs via remote
control, you can change pools and even the miner options by uploading
new "epools.txt" files to the miner, or by uploading new "config.txt"
file and restarting the miner.


Remote monitoring and management
********************************

PhoenixMiner is fully compatible with Claymore’s dual miner protocol
for remote monitoring and management. This means that you can use any
tools that are build to support Claymore’s dual miner, including the
“Remote manager” application that is part of Claymore’s dual miner
package.

We are working on much more powerful and secure remote monitoring and
control functionality and control center application, which will allow
better control over your remote or local rigs and some unique features
to increase your mining profits.


Hardware control options
************************

Here are some important notes about the hardware control options:

* Most recent Nvidia drivers require running as administrator (or as
  root under Linux) to allow hardware control, so you must run
  PhoenixMiner as administrator for the VRAM timing options to work.

* When using the VRAM timing options ("-straps", "-vmt1", "-vmt2",
  "-vmt3", "-vmr"), start with lower values and make sure that the
  cards are stable before trying higher and more aggressive settings.
  You can use "-straps" along with the other options. For example
  "-straps 1" "-vmt1 60" will use the timings from 1st strap level but
  -vmt1 will be set to 60 instead of whatever value is specified by
  the 1st strap level. In such case the "-straps" option must be
  specified first.

* Generally, the "-vmt3" option has little effect on the hashrate,
  so first try adjusting the other parameters.

* The VRAM timing options can be quite different between the GPUs,
  even when the GPUs are the same model. Therefore, you can (and
  probably should) specify the VRAM timing options per-GPU.

* If you specify a single value (e.g. "-cvddc 1150"), it will be
  used on all cards. Specify different values for each card like this
  (separate with comma): "-cvddc 1100,1100,1150,1120,1090" If the
  specified values are less than the number of GPUs, the rest of GPUs
  will use the default values.

* We have tested only on relatively recent AMD GPUs
  (RX460/470/480/560/570/580/590, Vega, Radeon VII, RX5700, RX5500).
  Your results may vary with older GPUs.

* The blockchain beta drivers from AMD show quite unstable results -
  often the voltages don’t stick at all or revert back to the default
  after some time. For best results use the newer drivers from AMD:
  18.5.1 or later, where most of the bugs are fixed.

* "-tmax" specifies the temperature at which the GPU should start to
  throttle (because the fans can’t keep up).

* If you use other programs for hardware control, conflicts are
  possible and quite likely. Use something like GPU-Z to monitor the
  voltages, etc. MSI Afterburner also seems to behave OK (so you can
  use it to control the Nvidia cards while AMD cards are controller by
  PhoenixMiner).

* This should be obvious but still: if given clocks/voltages are
  causing crashes/freezes/incorrect shares when set with third-party
  program, they will be just as much unstable when set via
  PhoenixMiner hardware control options.

* If you have problems with hardware control options of PhoenixMiner
  and you were using something else to control clocks, fans, and
  voltages (MSI Aftrerburner, OverdriveNTool, etc.), which you were
  happy with, it is probably best to keep using it and ignore the
  hardware control options of PhoenixMiner (or use only some of them
  and continue tweaking the rest with your third-party tools).

* In order to have working hardware control under Linux, you need
  relatively recent kernel (4.15 or later), recent AMD drivers (we
  tested with 19.30-855429), PhoeniMiner must be running as root
  ("sudo ./PhoenixMiner"), AND you need to add the following boot
  parameter to the Linux kernel: "amdgpu.ppfeaturemask=0xffffffff"

* In all AMD Linux drivers there is a bug with returning the fan
  control back to automatic. As a workaround we added the parameter
  "-fanidle" which allows you to specify the default fan speed after
  PhoenixMiner is closed. The default value is 20%

* In AMD Linux drivers the fan PWM curves are very strange and while
  we have tested on dozens of cards, and PhoenixMiner should be able
  to detect the PWM type automatically, you can use the "-fpwm"
  parameter to force different kinds of fan PWM mappings (not
  recommended unless you really know what you are doing).


FAQ
***

Q001: Why another miner?
   A: We feel that the competition is good for the end user. In the
   first releases of PhoenixMiner we focused on the basic features and
   on the mining speed but we are now working on making our miner
   easier to use and even faster.

Q002: Can I run several instances of PhoenixMiner on the same rig?
   A: Yes, but make sure that each GPU is used by a single miner (use
   the -gpus, -amd, or -nvidia command-line options to limit the GPUs
   that given instance of PhoenixMiner actually uses).

   Another possible problem is that all instances will use the default
   CDM remote port 3333, which will prevent proper remote control for
   all but the first instance. To fix this problem, use the -cdmport
   command-line option to change the CDM remote port form its default
   value.

Q003: Can I run PhoenixMiner simultaneously on the same rig with other
miners?
   A: Yes, but see the answer to the previous question for how to
   avoid problems.

Q004: What is a stale share?
   A: The ethash coins usually have very small average block time (15
   seconds in most instances). On the other hand, to achieve high
   mining speed we must keep the GPUs busy so we can’t switch the
   current job too often. If our rigs finds a share just after the
   someone else has found a solution for the current block, our share
   is a stale share. Ideally, the stale shares should be minimal as
   same pools do not give any reward for stale shares, and even these
   that do reward stall shares, give only partial reward for these
   shares. If the share is submitted too long after the block has
   ended, the pool may even fully reject it.

Q005: Why is the percentage of stale shares reported by PhoenixMiner
smaller than the one shown by the pool?
   A: PhonixMiner can only detect the stale shares that were
   discovered after it has received a new job (i.e. the “very stale”)
   shares. There is additional latency in the pool itself, and in the
   network connection, which makes a share stall even if it was
   technically found before the end of the block from the miner’s
   point of view. As pools only reports the shares as accepted or
   rejected, there is no way for the miner to determine the stale
   shares from the pool’s point of view.

Q006: What is the meaning of the “actual share difficulty” shown by
PhoenixMiner when a share is found?
   A: It allows you to see how close you were to finding an actual
   block (a rare event these days for the most miners with reasonable-
   sized mining rigs). You can find the current difficulty for given
   coin on sites like whattomine.com and then check to see if you have
   exceeded it with your maximum share difficulty. If you did, you
   have found a block (which is what the mining is all about).

Q007: What is the meaning of “effective speed” shown by PhoenixMiner’s
statistics?
   A: This is a measure of the actually found shares, which determines
   how the pool sees your miner hashrate. This number should be close
   to the average hashrate of your rig (usually a 2-4% lower than it)
   depending you your current luck in finding shares. This statistic
   is meaningless in the first few hours after the miner is started
   and will level off to the real value with time.

Q008: Why is the effective hashrate shown by the pool lower than the
one shown by PhoenixMiner?
   A: There are two reasons for this: stale shares and luck. The stale
   shares are rewarded at only about 50-70% by most pools. The luck
   factor should level itself off over time but it may take a few days
   before it does. If your effective hashrate reported by the pool is
   consistently lower than the hashrate of your rig by more than 5-7%
   than you should look at the number of stale shares and the average
   share acceptance time - if it is higher than 100 ms, try to find a
   pool that is near to you geographically to lower the network
   latency. You can also restart your rig, or try another pool.


Troubleshooting
***************

P001: I’m using AMD RX470/480/570/580 or similar card and my hashrate
dropped significantly in the past few months for Ethereum and Ethereum
classic!
   S: This is known problem with some cards. For the newer cards
   (RX470/480/570/580), this can be solved by using the special
   blockchain driver from AMD (or try the latest drivers, they may
   incorporate the fix). For the older cards there is no workaround
   but you still can mine EXP, Musicoin, UBQ or PIRL with the same
   speed that you mined ETH before the drop.

P002: My Nvidia GTX9x0 card is showing very low hashrate under Windows
10!
   S: While there is a (convoluted) workaround, the best solution is
   to avoid Windows 10 for these cards - use Windows 7 instead.

P003: I’m using Nvidia GTX970 (or similar) card and my hashrate
dropped dramatically for Ethereum or Ethereum classic!
   S: GTX970 has enough VRAM for larger DAGs but its hashate drops
   when the DAG size starts to exceed 2 GB or so. Unlike the AMD
   Polaris-based cards, there is no workaround for this problem. We
   recommend using these cards to mine EXP, Musicoin, UBQ or PIRL with
   the same speed that you used to ETH before the drop.

P004: I can’t see some of my cards (or their fan speed and
temperature) when using Windows Remote Desktop (RDP)!
   S: This is a known problem with RDP. Use VNC or TeamViewer instead.

P005: On Windows 10, if you click inside the PhoenixMiner console, it
freezes!
   S: This is a known problem on Windows 10, related to so called
   “Quick Edit” feature of the command prompt window. From
   PhoenixMiner 2.6, the QuickMode is disabled by default, so you
   shouldn’t experience this problem. If you still, do, read here how
   to solve it: https://stackoverflow.com/q/33883530

P006: Immediately after starting, PhoenixMiner stops working and the
last message is “debugger detected”
   S: If you have only Nvidia cards, add the option -nvidia to the
   PhoenixMiner.exe command line. If you have only AMD cards, add the
   option -amd to the command line.

P007: (*Windows only*) PhoenixMiner shows an error after allocating
DAG buffer and shuts down.
   S: If you have more than one GPU, make sure that your Windows page
   file minimal size is set to at least (N x DS + 4) GB, where N is
   the number of GPUs, and DS is the size of DAG in GB (about 2.7 GB
   around September 2018 for ETC and ETH). For example, if you have 10
   GPUs, you need 10 x 2.7 + 4 = 31 GB minimal size of the page file.
   Note that this will increase as the DAG sizes increase.

P008: The miner sometimes crashes when the DAG epoch change.
   S: During DAG generation, the GPUs are loaded more than during the
   normal operation. If you have overclocked or undervolted the GPUs
   “to the edge”, the DAG generation ofter pushes them “over the
   edge”. Another possible reason for the crash (especially if the
   whole rig crashes) is the higher power usage during this process.
   You can lower the DAG generation speed by specifying the -lidag
   command-line option. The possible values are 0 (no slow down), 1,
   2, and 3 (max slowdown). In order to check if your rig would be
   stable during DAG generation, run it in benchmark mode by
   specifying the -bench 170 command line option. Then every time when
   you press the key ‘d’ the miner will advance to the next DAG epoch,
   and you will be able to see if it is stable during multiple DAG
   generations. If it isn’t you can try to alter the -lidag and -eres
   command line options until the desired stability is achieved.
