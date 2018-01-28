Claymore's AMD CryptoNight GPU Miner.
=========================



LINKS:

MEGA: https://mega.co.nz/#F!e4JVEAIJ!l1iF4z10fMyJzY5-LnyC2A
GOOGLE: https://drive.google.com/folderview?id=0B69wv2iqszefdkVDNkxla3BCZHc&usp=sharing


This is POOL version.
Set the following environment variables, especially if you have 1-2GB cards:

GPU_FORCE_64BIT_PTR 1
GPU_MAX_HEAP_SIZE 100
GPU_USE_SYNC_OBJECTS 1
GPU_MAX_ALLOC_PERCENT 100
GPU_SINGLE_ALLOC_PERCENT 100

For multi-GPU systems, set Virtual Memory size in Windows at least 16 GB:
"Computer Properties / Advanced System Settings / Performance / Advanced / Virtual Memory".

This miner is free-to-use, however, current developer fee is 1% if you use secure SSL/TLS connection to mining pool, every hour the miner mines for 36 seconds for developer. 
If you use unsecure connection to mining pool, current developer fee is 1.5%, every hour the miner mines for 54 seconds for developer. 
If you don't agree with the dev fee - don't use this miner, or use "-nofee" option.
Attempts to cheat and remove dev fee will cause a bit slower mining speed (same as "-nofee 1") though miner will show same hashrate.
Miner cannot just stop if cheat is detected because creators of cheats would know that the cheat does not work and they would find new tricks. If miner does not show any errors or slowdowns, they are happy.

This version is for recent AMD videocards only: 7xxx, 2xx, 3xx and 4xx, 1GB or more.

There are builds for Windows x64 and Linux x64. No 32-bit support. No NVidia support.



COMMAND LINE OPTIONS:

-xpool 	XMR pool address. Only Stratum protocol is supported. 
	Miner also supports SSL/TLS encryption for all data between miner and pool (if pool supports encryption), it significantly improves security.
	To enable encryption, use "ssl://" or "stratum+ssl://" prefix (or "tls" instead of "ssl").

-xwal 	Your XMR wallet address. Also worker name and other options if pool supports it. 
	Pools that require "Login.Worker" instead of wallet address are not supported directly currently, but you can use "-allpools 1" option to mine there.

-xpsw 	Password for XMR pool, use "x" as password.

-allpools Specify "-allpools 1" if miner does not want to mine on specified pool (because it cannot mine devfee on that pool), but you agree to use some default pools for devfee mining. 
	Note that if devfee mining pools will stop, entire mining will be stopped too.

-di 	GPU indexes, default is all available GPUs. For example, if you have four GPUs "-di 02" will enable only first and third GPUs (#0 and #2).
	You can also turn on/off cards in runtime with "0"..."9" keys and check current statistics with "s" key.
	For systems with more than 10 GPUs: use letters to specify indexes more than 9, for example, "a" means index 10, "b" means index 11, etc.

-h	number of hashes that GPU processes during one round. If not specified, default value is used. For many cases you can increase performance by adjusting this parameter value. For example, "-h 832" means HashCnt=832 for all cards. You can also specify values for every card, for example "-h 640,832,1376,0", zero value means autoselection. 

-dmem	doubled memory mode selection. Specify "-dmem 1" to use twice more GPU RAM, it will improve performance in many cases. Use "-dmem 0" to disable this mode. 
	Default value is "-1" (autoselection).

-lite	enables CryptoNight-Lite mode, specify "-lite 1" to be able to mine AEON. If set, "-allpools 1" will be set automatically.

-ftime	failover main pool switch time, in minutes, see "Failover" section below. Default value is 30 minutes, set zero if there is no main pool.

-wd 	watchdog option. Default value is "-wd 1", it enables watchdog, miner will be closed (or restarted, see "-r" option) if any thread is not responding for 1 minute or OpenCL call failed.
	Specify "-wd 0" to disable watchdog.

-r	Restart miner mode. "-r 0" (default) - restart miner if something wrong with GPU. "-r -1" - disable automatic restarting. -r >20 - restart miner if something 
	wrong with GPU or by timer. For example, "-r 60" - restart miner every hour or when some GPU failed.
	"-r 1" closes miner and execute "reboot.bat" file ("reboot.bash" or "reboot.sh" for Linux version) in the miner directory (if exists) if some GPU failed. 
	So you can create "reboot.bat" file and perform some actions, for example, reboot system if you put this line there: "shutdown /r /t 5 /f".

-retrydelay	delay, in seconds, between connection attempts. Default values is "20". Specify "-retrydelay -1" if you don't need reconnection, in this mode miner will exit if connection is lost.

-dbg	debug log and messages. "-dbg 0" - (default) create log file but don't show debug messages. 
	"-dbg 1" - create log file and show debug messages. "-dbg -1" - no log file and no debug messages.

-logfile debug log file name. After restart, miner will append new log data to the same file. If you want to clear old log data, file name must contain "noappend" string.
	If missed, default file name will be used.

-nofee	set "1" to cancel my developer fee at all. In this mode some recent optimizations are disabled so mining speed will be slower by about 4%. 
	By enabling this mode, I will lose 100% of my earnings, you will lose only 2.5-3% of your earnings.
	So you have a choice: "fastest miner" or "completely free miner but a bit slower".
	If you want both "fastest" and "completely free" you should find some other miner that meets your requirements, just don't use this miner instead of claiming that I need to cancel/reduce developer fee, saying that 1% developer fee is too much for this miner and so on.
-li	low intensity mode. Reduces mining intensity, useful if your cards are overheated. Note that mining speed is reduced too. 
	More value means less heat and mining speed, for example, "-li 10" is less heat and mining speed than "-li 1". You can also specify values for every card, for example "-li 3,10,50".
	Default value is "0" - no low intensity mode.

-tt	set target GPU temperature. For example, "-tt 80" means 80C temperature. You can also specify values for every card, for example "-tt 70,80,75".
	You can also set static fan speed if you specify negative values, for example "-tt -50" sets 50% fan speed. Specify zero to disable control and hide GPU statistics.
	"-tt 1" (default) does not manage fans but shows GPU temperature and fan status every 30 seconds. Specify values 2..5 if it is too often.
	Note: for Linux gpu-pro drivers, miner must have root access to manage fans, otherwise only monitoring will be available.

-ttli	reduce entire mining intensity (for all coins) automatically if GPU temperature is above specified value. For example, "-ttli 80" reduces mining intensity if GPU temperature is above 80C.
	You can see if intensity was reduced in detailed statistics ("s" key).
	You can also specify values for every card, for example "-ttli 80,85,80". You also should specify non-zero value for "-tt" option to enable this option.
	It is a good idea to set "-ttli" value higher than "-tt" value by 3-5C.

-tstop	set stop GPU temperature, miner will stop mining if GPU reaches specified temperature. For example, "-tstop 95" means 95C temperature. You can also specify values for every card, for example "-tstop 95,85,90".
	This feature is disabled by default ("-tstop 0"). You also should specify non-zero value for "-tt" option to enable this option.
	If it turned off wrong card, it will close miner in 30 seconds.
	You can also specify negative value to close miner immediately instead of stopping GPU, for example, "-tstop -95" will close miner as soon as any GPU reach 95C temperature.

-fanmax	set maximal fan speed, in percents, for example, "-fanmax 80" will set maximal fans speed to 80%. You can also specify values for every card, for example "-fanmax 50,60,70".
	This option works only if miner manages cooling, i.e. when "-tt" option is used to specify target temperature. Default value is "100".

-fanmin	set minimal fan speed, in percents, for example, "-fanmin 50" will set minimal fans speed to 50%. You can also specify values for every card, for example "-fanmin 50,60,70".
	This option works only if miner manages cooling, i.e. when "-tt" option is used to specify target temperature. Default value is "0".

-cclock	set target GPU core clock speed, in MHz. If not specified or zero, miner will not change current clock speed. You can also specify values for every card, for example "-cclock 1000,1050,1100,0".
	Unfortunately, AMD blocked underclocking for some reason, you can overclock only.

-mclock	set target GPU memory clock speed, in MHz. If not specified or zero, miner will not change current clock speed. You can also specify values for every card, for example "-mclock 1200,1250,1200,0".
	Unfortunately, AMD blocked underclocking for some reason, you can overclock only.

-powlim set power limit, from -50 to 50. If not specified, miner will not change power limit. You can also specify values for every card, for example "-powlim 20,-20,0,10".

-cvddc	set target GPU core voltage, multiplied by 1000. For example, "-cvddc 1050" means 1.05V. You can also specify values for every card, for example "-cvddc 900,950,1000,970". Supports latest AMD 4xx cards only in Windows.

-mvddc	set target GPU memory voltage, multiplied by 1000. For example, "-mvddc 1050" means 1.05V. You can also specify values for every card, for example "-mvddc 900,950,1000,970". Supports latest AMD 4xx cards only in Windows.

-mport	remote monitoring/management port. Default value is -3333 (read-only mode), specify "-mport 0" to disable remote monitoring/management feature. 
	Specify negative value to enable monitoring (get statistics) but disable management (restart, uploading files), for example, "-mport -3333" enables port 3333 for remote monitoring, but remote management will be blocked.
	You can also use your web browser to see current miner state, for example, type "localhost:3333" in web browser. 
	Warning: use negative option value or disable remote management entirely if you think that you can be attacked via this port!
	By default, miner will accept connections on specified port on all network adapters, but you can select desired network interface directly, for example, "-mport 127.0.0.1:3333" opens port on localhost only.

-mpsw	remote monitoring/management password. By default it is empty, so everyone can ask statistics or manage miner remotely if "-mport" option is set. You can set password for remote access (at least EthMan v3.0 is required to support passwords).

-colors enables or disables colored text in console. Default value is "1", use "-colors 0" to disable coloring. Use 2...4 values to remove some of colors.

-v	displays miner version, sample usage: "-v 1".



CONFIGURATION FILE

You can use "config.txt" file instead of specifying options in command line. 
If there are not any command line options, miner will check "config.txt" file for options.
If there is only one option in the command line, it must be configuration file name.
If there are two or more options in the command line, miner will take all options from the command line, not from configuration file.
Place one option per line, if first character of a line is ";" or "#", this line will be ignored. 
You can also use environment variables in "epools.txt" and "config.txt" files. For example, define "WORKER" environment variable and use it as "%WORKER%" in config.txt or in epools.txt.



SAMPLE USAGE

 moneropool (unencrypted connection):
	NsGpuCNMiner.exe -xpool stratum+tcp://mine.moneropool.org:80 -xwal 449TGay4WWJPwsXrWZfkMoPtDbJp8xoSzFuyjRt3iaM4bRHdzw4qoDu26FdcGx67BMDS1r2bnp7f5hF6xdPWWrD3Q3Wf7G6 -xpsw x

 miningpoolhub SSL/TLS connection (this pool detects encryption automatically so it uses same port as for unencrypted connection):
	NsGpuCNMiner.exe -xpool ssl://us-east.cryptonight-hub.miningpoolhub.com:20580 -xwal YourLogin.YourWorker -xpsw x

suprnova SSL/TLS connection:
	NsGpuCNMiner.exe -xpool ssl://xmr.suprnova.cc:5221 -xwal YourLogin.YourWorker -xpsw x

Do not forget to specify your wallet address!



FAILOVER

Use "epools.txt" file to specify additional pools. This file has text format, one pool per line. Every pool has 3 connection attempts. 
Miner disconnects automatically if pool does not send new jobs for a long time or if pool rejects too many shares.
If the first character of a line is ";" or "#", this line will be ignored. 
Do not change spacing, spaces between parameters and values are required for parsing.
If you need to specify "," character in parameter value, use two commas - ,, will be treated as one comma.
You can reload "epools.txt" file in runtime by pressing "r" key.
Pool specified in the command line is "main" pool, miner will try to return to it every 30 minutes if it has to use some different pool from the list. 
If no pool was specified in the command line then first pool in the failover pools list is main pool.
You can change 30 minutes time period to some different value with "-ftime" option, or use "-ftime 0" to disable switching to main pool.
You can also use environment variables in "epools.txt" and "config.txt" files. For example, define "WORKER" environment variable and use it as "%WORKER%" in config.txt or in epools.txt.
You can also select current pool in runtime by pressing "e" key.



REMOTE MONITORING/MANAGEMENT

Miner supports remote monitoring/management via JSON protocol over raw TCP/IP sockets. You can also get recent console text lines via HTTP.
Start "EthMan.exe" from "Remote management" subfolder (Windows version only).
Check built-in help for more information. "API.txt" file contains more details about protocol.



KNOWN ISSUES

- Windows 10 Defender recognizes miner as a virus, some antiviruses do the same. Miner is not a virus, add it to Defender exceptions. 
  I write miners since 2014. Most of them are recognized as viruses by some paranoid antiviruses, perhaps because I pack my miners to protect them from disassembling, perhaps because some people include them into their botnets, or perhaps these antiviruses are not good, I don't know. For these years, a lot of people used my miners and nobody confirmed that my miner stole anything or did something bad. 
  Note that I can guarantee clean binaries only for official links in my posts on this forum (bitcointalk). If you downloaded miner from some other link - it really can be a virus.
  However, my miners are closed-source so I cannot prove that they are not viruses. If you think that I write viruses instead of good miners - do not use this miner, or at least use it on systems without any valuable data.



TROUBLESHOOTING

1. Install Catalyst v15.12.
2. Disable overclocking.
3. Set environment variables as described above.
4. Set Virtual Memory 16 GB or more.
5. Reboot computer.
6. Check hardware, risers.



FAQ:

Q: Why do I see more shares for devfee than in my mining for the same time?
A: Most pools support variable diff, they change "target share" after some time after connection. For example, you have very powerful rig, after connection you will send shares very often. It takes some CPU time to check your shares so after some time pool will send higher share target and miner will send less shares (but they will have more value). When pool updates share target you will see "Pool sets new share target" line in the miner. This way pool can adjust the number of shares that miner sends and balance its load.
So check the log or console text to see current target for main mining thread and for devfee thread. For example:
DevFee: Pool sets new share target: 0x0083126e (diff: 500H) - this is for devfee mining connection
Pool sets new share target: 0x0024fa4f (diff: 1772H) - this is for main mining connection
As you can see, target share for main mining is higher in about 3.5 times, so for main mining miner sends in 3 times less shares (but they have 3x more value) than for devfee mining.

Q: Miner freezes if I put cursor to its window in Windows 10 until any key is pressed. Sometimes miner freezes randomly until any key is pressed.
A: You should make some changes in Windows:
  https://superuser.com/questions/555160/windows-command-prompt-freezing-on-focus
  https://superuser.com/questions/419717/windows-command-prompt-freezing-randomly?rq=1
  https://superuser.com/questions/1051821/command-prompt-random-pause?rq=1




