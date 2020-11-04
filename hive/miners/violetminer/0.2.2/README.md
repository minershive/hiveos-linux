# violetminer

![image](https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Argon_discharge_tube.jpg/500px-Argon_discharge_tube.jpg)

A CPU and NVIDIA miner for TurtleCoin / Chukwa / ChukwaV2 / WrkzCoin.

## Download

[Go here to download the latest release.](https://github.com/turtlecoin/violetminer/releases)

If you prefer to compile yourself, read on. This can result in increased hashrates in some cases.

## Setup / Usage

We suggest you follow the [guide here](https://docs.turtlecoin.lol/guides/mining/violetminer-guide) to setup your miner.

## Algorithms Supported
* TurtleCoin (ChukwaV2) - choose `turtlecoin` or `chukwa_v2`
* WrkzCoin - choose `wrkzcoin` or `chukwa_wrkz`
* Chukwa - choose `chukwa`

## Notes

* Supports AVX-512, AVX-2, SSE4.1, SSSE3, SSE2 and NEON optimizations.
* Supports NVIDIA GPUs.
* You can set a priority to a pool to determine which ones are tried first. A smaller priority number means we will connect to it first. 0 = highest priority. If we are not connected to the highest priority pool, we will continuously retry connecting to higher priority pools.

* Dev fee is 1%.
* Supports [xmrig-proxy](https://github.com/xmrig/xmrig-proxy) - Make sure to enable `"niceHash": true` in your pool config.
* Getting an error about a missing MSVCP140_1.dll or vcrruntime140_1.dll? You are missing the Visual C++ 2019 Redistributable. You can find that [here](https://support.microsoft.com/en-gb/help/2977003/the-latest-supported-visual-c-downloads) or [Direct download link (x64)](https://aka.ms/vs/16/release/vc_redist.x64.exe)

## Configuring

There are a couple of ways to configure the miner.

* Just start it, and walk throught the guided setup. Upon completion, the config will be written to `config.json` for modification if desired.
* Use command line options. Use `violetminer --help` to list them all. It is not recommended to use command line options, as they are less configurable than the config. Only `--algorithm`, `--pool`, and `--username` are mandatory.

For example:
```
./violetminer --algorithm turtlecoin --pool trtl.pool.mine2gether.com:2225 --username TRTLv2Fyavy8CXG8BPEbNeCHFZ1fuDCYCZ3vW5H5LXN4K2M2MHUpTENip9bbavpHvvPwb4NDkBWrNgURAd5DB38FHXWZyoBh4wW
```

* Copy the below config to `config.json` and modify to your purposes.

```json
{
    "hardwareConfiguration": {
        "cpu": {
            "enabled": true,
            "optimizationMethod": "Auto",
            "threadCount": 12
        },
        "nvidia": {
            "devices": [
                {
                    "desktopLag": 100.0,
                    "enabled": true,
                    "id": 0,
                    "intensity": 100.0,
                    "name": "GeForce GTX 1070"
                }
            ]
        }
    },
    "pools": [
        {
            "agent": "",
            "algorithm": "turtlecoin",
            "host": "trtl.pool.mine2gether.com",
            "niceHash": false,
            "password": "x",
            "port": 2225,
            "priority": 0,
            "rigID": "",
            "ssl": false,
            "username": "TRTLv2Fyavy8CXG8BPEbNeCHFZ1fuDCYCZ3vW5H5LXN4K2M2MHUpTENip9bbavpHvvPwb4NDkBWrNgURAd5DB38FHXWZyoBh4wW"
        },
        {
            "agent": "",
            "algorithm": "turtlecoin",
            "host": "pool.turtle.hashvault.pro",
            "niceHash": true,
            "password": "x",
            "port": 443,
            "priority": 2,
            "rigID": "",
            "ssl": true,
            "username": "TRTLv2Fyavy8CXG8BPEbNeCHFZ1fuDCYCZ3vW5H5LXN4K2M2MHUpTENip9bbavpHvvPwb4NDkBWrNgURAd5DB38FHXWZyoBh4wW"
        },
        {
            "agent": "",
            "algorithm": "wrkz",
            "host": "fastpool.xyz",
            "niceHash": false,
            "password": "x",
            "port": 3005,
            "priority": 1,
            "rigID": "",
            "ssl": false,
            "username": "WrkzjJMM8h9F8kDU59KUdTN8PvZmzu2HchyBG15R4SjLD4EcMg6qVWo3Qeqp4nNhgh1CPL7ixCL1P4MNwNPr5nTw11ma1MMXr7"
        }
    ]
}
```

### Disabling CPU/GPU/Specific Cards

* If you want to disable CPU mining, either set `enabled` to `false` in the cpu section, or start the miner with the `--disableCPU` flag.
* If you want to disable Nvidia mining, either set `enabled` to `false` for each card in the nvidia devices section, or start the miner with the `--disableNVIDIA` flag.

* If you want to disable a specific Nvidia or AMD card, just set `enabled` to `false` in the nvidia devices section for the appropriate card.

Note that changing the `name` field does not do anything. It is only there to help you identify which device has which id.
It's highly recommended that you don't change the `name` or `id` fields, or you may end up with quite a confusing result.

You can always delete your config file, and let the program regenerate it, if you mess up.

### GPU Configuration

#### Intensity

* In addition to enabling and disabling specific cards, you can also configure how many threads and how much memory they use.
* This is done by altering the `intensity` value in the config.
* A value of `100` for intensity means the maximum threads and memory will be used.
* A value of `0` for intensity means no threads and memory will be used.
* Lower intensities don't neccessarily mean lower hashrate.

#### Desktop Lag

* The `desktopLag` value determines how long we will sleep between kernel launches.
* The default value of `100` means there are no sleeps between launches.
* This is appropriate for most setups, where you are just mining.
* However, if you are mining on your personal PC, and your desktop is quite laggy while mining, you can use this setting to decrease the lags.
* A value of 100 means maximum desktop lag, a value of 0 means minimum desktop lag.
* You can see how long we will sleep between launches printed at startup.
* A lower value of desktop lag means less hashrate, because we launch the hasher kernel less.

### CPU Optimization method

By default, the program will automatically choose the optimization method to use.

In some cases, you may find you get better performance by manually specifying the optimization method to use.

You can, if desired, use a different optimization method, or disable optimizations altogether.

Note that you can only use optimizations that your hardware has support for - these are printed at startup.

Simply set the desired value in the `optimizationMethod` config field.

Available optimizations for each platform are as follows:

#### x86_64 (64 bit Intel/AMD Windows/Mac/Linux)

* `AVX-512`
* `AVX-2`
* `SSE4.1`
* `SSSE3`
* `SSE2`
* `None`
* `Auto`

#### ARMv8

Note: On ARMv8, `Auto` uses no optimizations. From my testing, the NEON implementation actually performs worse than the reference implementation. You may want to experiment with toggling between `NEON` and `None` if you are on an ARM machine.

* `NEON`
* `None`
* `Auto`

#### Anything else

* `None`
* `Auto`

## Compiling

#### Disabling NVIDIA support

Run cmake with the -DENABLE_NVIDIA=OFF flag: `cmake -DENABLE_NVIDIA=OFF ..`

### Windows

- Download and install CUDA from here: https://developer.nvidia.com/cuda-downloads (This step is only if you want Nvidia support.)
- Download the [Build Tools for Visual Studio 2019](https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=BuildTools&rel=16) Installer.
- When it opens up select **C++ build tools**, it automatically selects the needed parts.
- From the start menu, open 'x64 Native Tools Command Prompt for VS 2019'.
- `cd C:/` (Or your directory of choice)
- `git clone https://github.com/turtlecoin/violetminer`
- `cd violetminer`
- `git submodule update --init --recursive`
- `mkdir build`
- `cd build`
- `cmake -G "Visual Studio 16 2019" -A x64 ..`
- `MSBuild violetminer.sln /p:Configuration=Release /m`

### Linux

* It's recommended to use Clang to compile. It gets better CPU hashrate for many people.
* If you're on ARM however, GCC gets slightly better hashrate.
* You will need to install CUDA if you want Nvidia support, which is somewhat out of the scope of this document.
* You can find the CUDA binaries for linux here: https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64

#### Ubuntu, using Clang

- `sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y`
- `wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -`

You need to modify the below command for your version of ubuntu - see https://apt.llvm.org/

* Ubuntu 14.04 (Trusty)
- `sudo add-apt-repository "deb https://apt.llvm.org/trusty/ llvm-toolchain-trusty 6.0 main"`

* Ubuntu 16.04 (Xenial)
- `sudo add-apt-repository "deb https://apt.llvm.org/xenial/ llvm-toolchain-xenial 6.0 main"`

* Ubuntu 18.04 (Bionic)
- `sudo add-apt-repository "deb https://apt.llvm.org/bionic/ llvm-toolchain-bionic 6.0 main"`

- `sudo apt-get update`
- `sudo apt-get install aptitude -y`
- `sudo aptitude install -y -o Aptitude::ProblemResolver::SolutionCost='100*canceled-actions,200*removals' build-essential clang-6.0 libstdc++-7-dev git python-pip libssl-dev`
- `sudo pip install cmake`
- `export CC=clang-6.0`
- `export CXX=clang++-6.0`
- `git clone https://github.com/turtlecoin/violetminer`
- `cd violetminer`
- `git submodule update --init --recursive`
- `mkdir build`
- `cd build`
- `cmake ..`
- `make`

#### Ubuntu, using GCC

- `sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y`
- `sudo apt-get update`
- `sudo apt-get install aptitude -y`
- `sudo aptitude install -y build-essential g++-8 gcc-8 git python-pip libssl-dev`
- `sudo pip install cmake`
- `export CC=gcc-8`
- `export CXX=g++-8`
- `git clone https://github.com/turtlecoin/violetminer`
- `cd violetminer`
- `git submodule update --init --recursive`
- `mkdir build`
- `cd build`
- `cmake ..`
- `make`

#### Generic Linux

Reminder to use clang if possible. Make sure to set `CC` and `CXX` to point to `clang` and `clang++` as seen in the Ubuntu instructions.

- `git clone https://github.com/turtlecoin/violetminer`
- `cd violetminer`
- `git submodule update --init --recursive`
- `mkdir build`
- `cd build`
- `cmake ..`
- `make`

### Android with Termux

- `pkg install cmake clang git` (Enter `y` to confirm the install)
- `git clone https://github.com/turtlecoin/violetminer`
- `cd violetminer`
- `git submodule update --init --recursive`
- `mkdir build`
- `cd build`
- `cmake -DENABLE_NVIDIA=OFF ..`
- `make`

Or, if you hate typing and just want something to copy paste, try this single command:

```
cd && rm -Rf violetminer && apt-get update && pkg update -y && pkg install cmake clang git -y && git clone https://github.com/turtlecoin/violetminer && mkdir violetminer/build && cd violetminer/ && git submodule update --init --recursive && cd build/ && cmake -DENABLE_NVIDIA=OFF .. && make
```

### Android Cross Compile

Using [this](https://android.googlesource.com/platform/ndk/+/ndk-release-r20/build/cmake/android.toolchain.cmake) toolchain

ANDROID_ABI can be

* armeabi-v7a
* arm64-v8a
* x86
* x86_64

Set this depending on the architecture of the phone you want to run it on.

- `git clone https://github.com/turtlecoin/violetminer`
- `cd violetminer`
- `git submodule update --init --recursive`
- `mkdir build`
- `cd build`
- `cmake -DCMAKE_TOOLCHAIN_FILE="${HOME}/Android/sdk/android-ndk-r20/build/cmake/android.toolchain.cmake" -DANDROID_ABI=arm64-v8a -DANDROID_CROSS_COMPILE=ON ..`
- `make`

## Developing

* Update submodules to latest commit: `git submodule foreach git pull origin master`
