# Nimiq GPU miner
[![Github All Releases](https://img.shields.io/github/downloads/tomkha/nq-miner/total.svg)]()

## Options

```
-t, --type         Use CUDA (Nvidia) or OpenCL (AMD)                             [string] [required]
                   Possible values: "cuda" or "opencl"

-a, --address      Nimiq wallet address                                          [string] [required]
                   Example: "NQ02 YP68 BA76 0KR3 QY9C SF0K LP8Q THB6 LTKU"

-p, --pool         Pool address (host:port)                                                 [string]
                   Example: "eu.nimpool.io:8444", "eu.sushipool.com:443"

-n, --name         Device (rig) name                                                        [string]
                   Example: "My rig"

-m, --mode         Mining mode                                                              [string]
                   Defines what consensus type to establish and what pool protocol to use
                   Possible values: "solo", "smart", "nano", "dumb"
                   Default: "dumb"

-d, --devices      List of GPU devices to use                                                [array]
                   Example: 0 1 2
                   Default: All available GPUs

--network          Nimiq network to connect to                                              [string]
                   Possible values: "main", "test", "dev"
                   Default: "main"

--volatile         Keep consensus state in memory only                                     [boolean]

--extra-data       Extra data to add to every mined block when mining solo                  [string]
                   Ensure that all your rigs have unique extra data

--hashrate         Expected hashrate in kH/s (sets start difficulty)                        [number]
                   Example: 400

--difficulty       Start difficulty to announce to the pool                                 [number]
                   Either hashrate or difficulty can be specificied
                   Example: 30

--log              Log level                                                                [string]
                   Possible values: "info", "debug", "verbose"
                   Default: "info"

--api              Start API server on the specified host and port                          [string]
                   Example: 3110 or 0.0.0.0:3110
                   Default: 127.0.0.1:3110

--memory           Memory to allocate in Mb per thread/GPU                                   [array]
                   Example: 3968 3968 2944 2944
                   Default: auto

--threads          Number of threads per GPU                                                 [array]
                   Example: 2 2 4 4
                   Default: 2

--cache            Number of Argon2 blocks cached into the local GPU memory                  [array]
                   Example: 4 4 2 2
                   Default: 4

--memory-tradeoff  Number of computed Argon2 blocks (CUDA)                                   [array]
                   Performs extra computations to reduce memory access
                   Example: 256 256 192 192
                   Default: 256

--jobs             Number of simultaneous jobs to run (OpenCL)                               [array]
                   Example: 8 8 4 4
                   Default: 8

--cpu-priority     Process priority (0 - 5, 0 - idle, 2 - normal, 5 - highest)              [number]
                   Example: 5

-v, --version      Show version number                                                     [boolean]

-h, --help         Show help                                                               [boolean]
```
