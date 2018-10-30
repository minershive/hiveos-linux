ZM is an Equihash miner for Nvidia GPUs
Supports currencies which use Equihash as their POW e.g. ZCash.
Official site: Official site: https://bitcointalk.org/index.php?topic=2021765.0

- Compatible with devices having Compute Capability 5.0 and greater (Maxwell/Pascal).
- Supports stratum/pool based mining.
- Multi-GPU support.
- Supports remote monitoring
- Supports setup of failover pools (see zm.cfg for description)
- Supports configuration using configuration files
- contains 2% development fee



Dependencies
============

Linux:
 openssl 1.0 (for versions <= 0.5.7)

Windows:
 Visual C++ Redistributable for visual studio 2015 (VCRUNTIME140.dll)



Usage
=====

To get a description about available options - launch zm without parameters.

Minimal example:
 zm --server servername.com --port 1234 --user username

Packages for windows include a 'start.bat' for simplicity.
Don't forget to change your pool and login information.

$ zm --help
ZM 0.6.1, dstm's ZCASH/Equihash Cuda Miner

Usage:
 zm --server hostname --port port_nr --user user_name
    [--pass password] [options]...

 zm --cfg-file[=path]

 Stratum:
    --server         Stratum server hostname
                     prefix hostname with 'ssl://' for encrypted
                     connections - e.g. ssl://mypool.com
    --port           Stratum server port number
    --user           Username
    --pass           Worker password

 Options:
    --help           Print this help
    --list-devices   List available cuda devices

    --dev            Space separated list of cuda devices to use.
                     If this option is not given all available devices
                     are used.

    --time           Enable output of timestamps
    --color          colorize the output

    --logfile        [=path] Append logs to the file named by 'path'
                     If 'path' is not given append to 'zm.log' in
                     current working directory.
    --noreconnect    Disable automatic reconnection on network errors.

    --temp-target    =dev_id:temp-target[,dev_id:temp-target] ...
                     In C - If set, enables temperature controller.
                     The workload of each GPU will be continuously
                     adjusted such that the temperature stays around
                     this value. It is recommended to set your fan speed
                     to a constant value when using this setting.
                     Example: --temp-target=0:65,2:70

    --intensity      =dev_id:intensity[,dev_id:intensity] ...
                     Reduce the load which is put on the GPU - valid
                     intensity range ]1.0-0.0[.
                     Example: --intensity=0:0.893,2:0.8

    --telemetry      [=ip:port]. Starts telemetry server. Telemetry data
                     can be accessed using a web browser(http) or by json-rpc.
                     If no arguments are given the server listens on
                     127.0.0.1:2222 - Example: --telemetry=0.0.0.0:2222
                     Valid port range [1025-65535]

    --cfg-file       [=path] Use configuration file. All additional command
                     line options are ignored - configuration is done only
                     through configuration file. If 'path' is not given
                     use 'zm.cfg' in current working directory.

    --pool           =hostname,port_nr,user_name[,pass]
                     Setup additional failover pools.

 Example:
    zm --server servername.com --port 1234 --user username



User interface
==============

ZM's output on system with 8 GPUs:

>  GPU0  65C  75% |  507.9 Sol/s   504.9 Avg   269.8 I/s | 4.52 S/W  112 W |  3.74  100  39 ++++++++
>  GPU1  64C  70% |  508.4 Sol/s   509.1 Avg   273.0 I/s | 4.57 S/W  111 W |  4.11  100  38 +++++++++
>  GPU2  62C  70% |  512.9 Sol/s   514.0 Avg   274.0 I/s | 4.60 S/W  110 W |  2.62  100  37 +++++
>  GPU3  61C  70% |  502.4 Sol/s   500.8 Avg   266.9 I/s | 4.48 S/W  113 W |  2.24  100  38 ++++++++*
>  GPU4  64C  70% |  508.6 Sol/s   508.2 Avg   272.9 I/s | 4.53 S/W  111 W |  1.49  100  38 ++++++++++++
>  GPU5  57C  70% |  506.7 Sol/s   504.7 Avg   270.0 I/s | 4.53 S/W  110 W |  1.94  100  38 ++++++++++
>  GPU6  59C  70% |  514.5 Sol/s   506.3 Avg   270.4 I/s | 4.55 S/W  112 W |  2.36  100  38 ++++++
>  GPU7  64C  75% |  511.1 Sol/s   515.1 Avg   275.2 I/s | 4.62 S/W  109 W |  1.12  100  37 ++++++++
>  ============== | 4072.6 Sol/s  4063.3 Avg  2172.1 I/s | 4.55 S/W  891 W | 19.63  100  37 ++++++++++


Sol/s: solutions per second
Avg  : average solutions per second
I/s  : iterations per second done by the GPU
S/W  : efficiency - average Sol/s per Watt
W    : power consuption in Watt
last 3 colums: <shares per minute> <accepted shares ratio> <network latency in ms>


> : indicates that a new job was received
+ : indicates one submitted share
* : indicates one submitted dev fee share
= : sum/average if mining on multiple GPUs



Overclocking
============
ZM runs stable on stock settings.
On some GPUs overclocking might need readjustment in comparison with other mining software.
