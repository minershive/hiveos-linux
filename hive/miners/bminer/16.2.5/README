Bminer: When Crypto-mining Made *Fast*
======================================

Bminer is a highly optimized cryptocurrency miner that runs on modern NVIDIA GPUs (Maxwell and Pascal, i.e. GPUs that have compute capability 5.0 or above). Bminer is one of the *fastest* publicly available miners today -- we use various techniques including tiling and pipelining to realize the full potentials of the hardware.

Bminer also comes with REST APIs to facilitate production deployments (e.g., mining farms).

Bminer currently supports:
* Mine Equihash-based coins (e.g. Zcash) with 2% of devfee.
* Mine Zhash / Equihash 144,5 based coins (e.g. BitcoinGold, BitcoinZ) with 2% of devfee.
* Mine Ethash-based coins (e.g. Ethereum) with 0.65% of devfee.
* Dual mine Ethash-based coins (e.g. Ethereum) and Blake14r-based coins (e.g. Decred) / Blake2s-based coins (e.g. Verge) at the same time. Devfee for the dual mining mode is 1.3%, and the second coin (e.g. Decred/Verge) is mined without devfee.
* Mine [Bytom](https://bytom.io/) (BTM) with 2% of devfee.

Features
========

  * Fast
    * Equihash on stock settings:
      * 735-745 Sol/s on GTX 1080Ti
      * 450-460 Sol/s on GTX 1070
      * 315-325 Sol/s on GTX 1060
    * Equihash 144,5 (Zhash) on stock settings:
      * 61 Sol/s on GTX 1080Ti
      * 25 Sol/s on GTX 1060
    * Ethash on GTX 1080Ti stock settings (power: 250 W):
      * With [OhGodAnETHlargementPill](https://github.com/OhGodACompany/OhGodAnETHlargementPill): 46.7 MH/s
      * Without OhGodAnETHlargementPill: 32.2 MH/s
    * Dual mining using automatica tuning (default) on GTX 1080Ti stock settings (power: 250 W):
      * With OhGodAnETHlargementPill:
        * ETH 46 MH/s and DCR 1000 MH/s
        * ETH 46 MH/s and XVG 1770 MH/s
      * Without OhGodAnETHlargementPill:
        * ETH 32 MH/s and DCR 2200 MH/s
        * ETH 32 MH/s and XVG 3750 MH/s
    * Bytom mining on stock settings:
      * 2100 H/s on GTX 1080Ti
      * 800 H/s on GTX 1060 6G
  * Secure and reliable
    * SSL support
    * Automatic reconnects to recover from transient network failures
    * Automatic restarts if GPUs hang
  * Operation friendly
    * Comes with REST APIs to facilitate production deployments
    * Friendly UI to config and monitor miners

Quickstart
==========

To mine [Zcash](https://z.cash) on Windows on [nanopool](https://zec.nanopool.org/):

  * Download and extract Bminer into a folder (e.g. C:\bminer)
  * Edit mine.bat and change the address to the desired Zcash address that Bminer mines towards
  * Open command line prompt and run mine.bat.
  * Enjoy mining :-)

To mine [BitcoinGold](https://bitcoingold.org/) on Windows on [pool.gold](http://pool.gold/):

  * Download and extract Bminer into a folder (e.g. C:\bminer)
  * Edit mine_zhash.bat and change the parameters according to https://www.bminer.me.
  * Open command line prompt and run mine_zhash.bat.
  * Enjoy mining :-)

To mine [BitcoinZ](https://btcz.rocks/) on Windows on [2miners.com](https://2miners.com/):

  * Download and extract Bminer into a folder (e.g. C:\bminer)
  * Edit mine_equihash1445.bat and change the parameters according to https://www.bminer.me.
  * Open command line prompt and run mine_equihash1445.bat.
  * Enjoy mining :-)

To mine [Ethereum](https://www.ethereum.org/) on Windows on [ethermine.org](https://ethermine.org/):

  * Download and extract Bminer into a folder (e.g. C:\bminer)
  * Edit mine_eth.bat and change the parameters according to https://www.bminer.me.
  * Open command line prompt and run mine_eth.bat.
  * Enjoy mining :-)

To dual mine [Ethereum](https://www.ethereum.org/) and [Decred](https://www.decred.org/) on Windows:

  * Download and extract Bminer into a folder (e.g. C:\bminer)
  * Edit mine_eth_dcr.bat and change the parameters according to https://www.bminer.me.
  * Open command line prompt and run mine_eth_dcr.bat.
  * Enjoy mining :-)

To dual mine [Ethereum](https://www.ethereum.org/) and [Verge](https://vergecurrency.com/) on Windows:

  * Download and extract Bminer into a folder (e.g. C:\bminer)
  * Edit mine_eth_xvg.bat and change the parameters according to https://www.bminer.me.
  * Open command line prompt and run mine_eth_xvg.bat.
  * Enjoy mining :-)

To mine [Bytom](https://bytom.io/) on [f2pool](https://www.f2pool.com/):

  * Download and extract Bminer into a folder (e.g. C:\bminer)
  * Edit mine_btm.bat and change parameters according to https://www.bminer.me.
  * Open command line prompt and run mine_btm.bat.
  * Enjoy mining :-)

Please see https://www.bminer.me for advanced usages, APIs and updates.

OhGodAnETHlargementPill
=======================

For Ethash-based coin mining (including dual mining mode) on GTX 1080 and GTX 1080Ti, running [OhGodAnETHlargementPill](https://github.com/OhGodACompany/OhGodAnETHlargementPill) and Bminer at the same time can accelerate the mining speed.

To download and run OhGodAnETHlargementPill:

  * On Windows:
    * Download and install [Microsoft Powershell](https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell?view=powershell-6).
    * Open command line prompt and run download_OhGodAnETHlargementPill.bat.
    * Run the downloaded file OhGodAnETHlargementPill-r2.exe. It may require administrative rights on Windows.
  * On Linux:
    * Run download_OhGodAnETHlargementPill.sh to download the program.
    * Run OhGodAnETHlargementPill-r2 to launch the pogram. It may require root access on Linux.

For more details, please visit [OhGodAnETHlargementPill](https://github.com/OhGodACompany/OhGodAnETHlargementPill).
