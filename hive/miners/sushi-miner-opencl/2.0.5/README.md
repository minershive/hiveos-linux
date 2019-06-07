# Nimiq OpenCL GPU Mining Client for AMD and Nvidia Cards
[![Github All Releases](https://img.shields.io/github/downloads/Sushipool/sushi-miner-opencl/total.svg)]()

High-performance Nimiq GPU mining client that provides a fully open source codebase, optimized hash rate, nano protocol, multi GPU support, and a **0%** Dev fee.
## Quickstart (Ubuntu/Debian)

1. Install [Node.js](https://github.com/nodesource/distributions/blob/master/README.md#debinstall).
2. Install `git` and `build-essential`: `sudo apt-get install -y git build-essential`.
3. Install `opencl-headers`: `sudo apt-get install opencl-headers`.
4. Install OpenCL-capable drivers for your GPU ([Nvidia](https://www.nvidia.com/Download/index.aspx) or [AMD](https://www.amd.com/en/support))
5. Clone this repository: `git clone https://github.com/Sushipool/sushi-miner-opencl`.
6. Build the project: `cd sushi-miner-opencl && npm install`.
7. Copy miner.sample.conf to miner.conf: `cp miner.sample.conf miner.conf`.
8. Edit miner.conf, specify your wallet address.
9. Run the miner `UV_THREADPOOL_SIZE=8 nodejs index.js`. Ensure UV_THREADPOOL_SIZE is higher than a number of GPU in your system.

## HiveOS Mining FlightSheet
Use the following FlightSheet settings to start mining Nimiq with HiveOS.
![HiveOS](https://github.com/Sushipool/sushi-miner-opencl/blob/master/hiveos-flightsheet.png?raw=true)


## Developer Fee
This client offers a **0%** Dev Fee!


## Drivers Requirements
AMD: Version 18.10 is recommended to avoid any issues.

## Mining Parameters

```
Parameter       Description                                            Data Type

address         Nimiq wallet address                                    [string]
                Example: "address": "NQ...",

host            Pool server address
                Example: "host": "eu.sushipool.com"                     [string]
                
port            Pool server port
                Example: "port": "443"
                Default: 443                                            [number]

consensus       Consensus method used
                Possible values are "dumb" or "nano"
                Note that "dumb" mode (i.e. no consensus) only works with SushiPool.
                Example: "consensus": "nano"                            [string]
                
name            Device name to show in the dashboard                    [string]
                Example: "name": "My Miner"
                
hashrate        Expected hashrate in kH/s                               [number]
                Example: "hashrate": 100
                
devices         GPU devices to use
                Example: "devices": [0,1,2]
                Default: All available GPUs                              [array]
                
memory          Allocated memory in Mb for each device
                Example: "memory": [3072,3840,3840,3840]                 [array]
                
threads         Number of threads per GPU
                Example: "threads": [1,1,2,2]
                Default: 1                                               [array]
```

### Links
Website: https://sushipool.com

Discord: https://discord.gg/JCCExJu

Telegram: https://t.me/SushiPoolHelp

Releases: https://github.com/Sushipool/sushi-miner-opencl/releases
