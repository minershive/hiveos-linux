# DamoMiner

GPU miner for ETH,CKB,ETH-CKB,RVN,ETH-HNS,ETH-TRB

# Download

[Download here](https://github.com/damominer/damominer/releases)

## Contact Us

- Email: damominerofficial@gmail.com 

## Performance (stock frequency)

| Algorithm           |   Coin  |     1070    |   P102-10G  |    1080ti   |     1080    |   P106-100  |   P104      |   2080 Ti   |    2060     |
| ----------------    | ------- |  ---------- |   --------  |   --------  |   --------  |   --------  | --------    |   --------  |  --------   |
| eaglesong           |   CKB   |      -      |     998M    |      -      |      -      |     -       |     -       |    -        |    -        |
| ethash              |   ETH   |      -      |    47.2M    |     46M     |     35M     |     -       |     -       |    -        |    -        |
| eaglesong+ethash    | CKB+ETH | 383.1+24.9M | 439.9+43.6M | 657.6+45.9M | 529.5+31.1M |     -       |     -       |    -        |    -        |
| blake2b_sha3+ethash | HNS+ETH | 159.6+22.1M | 168.6+44.0M | 173.9+43.4M | 86.5+21.6M  | 74.2+18.6M  | 130.1+32.5M |    -        |    -        |
| tellor+ethash       | TRB+ETH | 254.3+25.4M | 289.8+41.4M | 402.1+44.6M | 137.7+19.3M | 128.1+18.3M | 235.3+33.6M | 860.8+50.6M | 435.1+36.2M | 
| kawpow              |  RVN    | 13.22M      | 23.92M      | 22.484M     |      -      | 10.4195     | 18.642M     |    -        |    -        |

Note: - wait for update.

## Feature

* Supports Windows & Linux.
* Supports faster dual-mining.
* Dev Fee: 
  * ethash 1% ETH
  * eaglesong 3% CKB
  * ethash+eaglsong 2%ETH+1%CKB
  * ethash+hns 3% ETH+HNS
  * ethash+trb 3% ETH+TRB
  * kawpow 2% RVN


## CMD Option

GPU miner,it is only support Nvidia card now !

 Options :

    -P,--pool           Stratum pool. Example
                        ckb pool: stratum+tcp://youraccount.workname@ckb-eu.sparkpool.com:8888
                        eth pool: stratum1+tcp://youraccount.workname@cn.sparkpool.com:3333
                        scheme://[account[.workername]@]hostname:port

    -E                  Dual mining mode, set ETH pool, single mining mode only need set -P 
                        scheme://[account[.workername]@]hostname:port

    -A                  Algorithm supported:ckb,eth,eth_ckb,eth_hns,eth_trb,rvn
    -h,--help           Displays this help text and exits
    -V,--version        Show program version and exits
    --api-bind          Default not set. Example:--api-bind 127.0.0.1:3333
                        Use negative port number for readonly mode
    --api-port          Default not set.range from (1~65535) 
                        listen on this port 
    --api-password      Default not set.you can set the password to protect your interaction
    -I,--intensity      Dual mining mode ,ETH hashrate will faster and slave coin hashrate will slower 
                        with the smaller intensity range from (0~8).default 4

## Requirements

### Linux 

    damominer: NVIDIA Driver version:>=418.87,cuda 10.1

### Windows

    damominer9: NVIDIA Driver version:>=385.54 cuda 9.0
    damominer10: NVIDIA Driver version:>=418.96 cuda 10.1

## Sample Usages

### Coin:ETH

- **f2pool:** damominer -P stratum1+tcp://0x43E5f72D6Ab08fB8034F0dFb34a480B9d256e53C.workname@cn.sparkpool.com:3333 -A eth
- **sparkpool:** damominer -P stratum1+tcp://0x43E5f72D6Ab08fB8034F0dFb34a480B9d256e53C.workname@eth.f2pool.com:8008 -A eth  

## Coin:CKB

- **sparkpool:** damominer -P stratum+tcp://sp_tttest.workname@ckb.sparkpool.com:8888 -A ckb
- **f2pool:** damominer -P stratum+tcp://tttest.workname@ckb.f2pool.com:4300 -A ckb

## Coin:RVN

- **Testpool:** damominer -P stratum+tcp://USER.worker@rvnt.minermore.com:4505 -A rvn

## Coin:ETH-TRB

### Linux

- **sparkpool:** damominer -P stratum+tcp://0x178ddc4da700bba670b635103476764771671dad.test@trb.uupool.cn:11002   -E stratum1+tcp://0x43E5f72D6Ab08fB8034F0dFb34a480B9d256e53C.0707@cn.sparkpool.com:3333 -A eth_trb

### Windows

- **sparkpool:** damominer -P stratum+tcp://0x178ddc4da700bba670b635103476764771671dad.test@trb.uupool.cn:11002   -E stratum1+tcp://0x43E5f72D6Ab08fB8034F0dFb34a480B9d256e53C.0707@cn.sparkpool.com:3333 -A eth_trb

## Coin:ETH-HNS

### Linux

- **sparkpool:** damominer -P stratum+tcp://hs1qmggmnpwx72qy5fsm57rw42ktaah6h5gm50ss2e.test@hns.f2pool.com:6000   -E stratum1+tcp://0x43E5f72D6Ab08fB8034F0dFb34a480B9d256e53C.0707@cn.sparkpool.com:3333 -A eth_hns

### Windows

- **sparkpool:** damominer.exe -P stratum+tcp://hs1qmggmnpwx72qy5fsm57rw42ktaah6h5gm50ss2e.test@hns.f2pool.com:6000   -E stratum1+tcp://0x43E5f72D6Ab08fB8034F0dFb34a480B9d256e53C.0707@cn.sparkpool.com:3333 -A eth_hns

## Coin:ETH-CKB

### Linux

- **f2pool:** damominer -P stratum+tcp://sp_tttest.workname@ckb.sparkpool.com:8888 -E stratum1+tcp://0x43E5f72D6Ab08fB8034F0dFb34a480B9d256e53C.workname@cn.sparkpool.com:3333 -A eth_ckb
- **sparkpool:** damominer -P stratum+tcp://sp_tttest.workname@ckb.f2pool.com:4300 -E stratum1+tcp://0x43E5f72D6Ab08fB8034F0dFb34a480B9d256e53C.workname@eth.f2pool.com:8008 -A eth_ckb

### Windows

- **f2pool:** damominer -P stratum+tcp://sp_tttest.workname@ckb.sparkpool.com:8888 -E stratum1+tcp://0x43E5f72D6Ab08fB8034F0dFb34a480B9d256e53C.workname@cn.sparkpool.com:3333 -A eth_ckb --mode 1
- **sparkpool:** damominer -P stratum+tcp://sp_tttest.workname@ckb.f2pool.com:4300 -E stratum1+tcp://0x43E5f72D6Ab08fB8034F0dFb34a480B9d256e53C.workname@eth.f2pool.com:8008 -A eth_ckb --mode 1

## FAQ

### Tuning parameter

- **-I:** -I range(0,8),Dual-mining eth_ckb
  
    1.If you want CKB have the best performance ,set I 8    
    damominer -P stratum+tcp://sp_tttest.workname@ckb.sparkpool.com:8888 -E stratum1+tcp://0x43E5f72D6Ab08fB8034F0dFb34a480B9d256e53C.workname@cn.sparkpool.com:3333 -A eth_ckb -I 8

    2.If you want ETH have the best performance ,set I 0
    damominer -P stratum+tcp://sp_tttest.workname@ckb.sparkpool.com:8888 -E stratum1+tcp://0x43E5f72D6Ab08fB8034F0dFb34a480B9d256e53C.workname@cn.sparkpool.com:3333 -A eth_ckb -I 0

- **Environment Set:**  
    info: error while loading shared libraries: libcuda.so.1: cannot open shared object file: No such file or directory

    You should copy libnvrtc-builtins.so libnvrtc.so.10.1  to /usr/lib/ or add to LD_LIBRARY_PATH

## API Reference

    Request:
    {
    "id": 1,
    "jsonrpc": "2.0",
    "method": "miner_getstatdetail"
    }

    response:
    {
        "id": 0,
        "jsonrpc": "2.0",
        "result": {
            "connection": {
                "connected": true,
                "switches": 1,
                "uri": "stratum+tcp://youraccount.workname@ckb.sparkpool.com:8888"
            },
            "devices": [
                {
                    "_index": 0,
                    "_mode": "CUDA",
                    "hardware": {
                        "name": "P102-100 9.92 GB",
                        "pci": "06:00.0",
                        "sensors": [
                            0,
                            0,
                            0
                        ],
                        "type": "GPU"
                    },
                    "mining": {
                        "hashrate": "0x000847f9",
                        "hashrate_sc": "0x22074180",
                        "segment": [
                            "0xe9624dbb2939f091",
                            "0xe9624dbc2939f091"
                        ],
                        "shares": [
                            0,//accept share;
                            0,//reject share;
                            0,//fault share;
                            18   //last share take delay_time;
                        ]
                    }
                },
                {
                    "_index": 1,
                    "_mode": "CUDA",
                    "hardware": {
                        "name": "P102-100 9.92 GB",
                        "pci": "07:00.0",
                        "sensors": [
                            0,
                            0,
                            0
                        ],
                        "type": "GPU"
                    },
                    "mining": {
                        "hashrate": "0x00085c1c",
                        "hashrate_sc": "0x211add80",
                        "segment": [
                            "0xe9624dbc2939f091",
                            "0xe9624dbd2939f091"
                        ],
                        "shares": [
                            0,
                            0,
                            0,
                            18
                        ]
                    }
                },               
            ],
            "host": {
                "name": "N0101",
                "runtime": 18,
                "version": "damominer"
            },
            "mining": {
                "difficulty": 99998604623,
                "epoch": -1,
                "epoch_changes": 0,
                "hashrate": "0x00299118",
                "shares": [//master coin
                    0,//accept share;
                    0,//reject share;
                    0,//fault share;
                    18   //last share take delay_time;
                ]
                "shares_sc": [//slave coin
                    0,//accept share;
                    0,//reject share;
                    0,//fault share;
                    18   //last share take delay_time;
                ]
            },
            "monitors": null
        }
    }


## History

### V2.6.9 (20200429)

    Update RVN hash rate.
    Supports linux.

### V2.6.6 (20200421)

    Supports RVN mining.
    Supports Windows & linux.

### V2.6.3 (20200410)

    Supports ETH-TRB dual mining.
    Supports Windows & linux.

### V2.5.8 (20200320)

    Supports nicehash protocal.
    Update eth_hns hash rate.

### V2.5.7 (20200313)

    Supports ETH-HNS dual mining.
    Supports Windows & linux.

### V2.4.3 (20200207)

    Supports ETH,CKB,ETH-CKB dual mining.
    Supports Windows & linux.
