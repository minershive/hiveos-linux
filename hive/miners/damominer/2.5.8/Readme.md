# DamoMiner

GPU miner for ETH,CKB,ETH-CKB

# Download

[Download here](https://github.com/damominer/damominer/releases)

## Contact Us

- Email: damominerofficial@gmail.com 

## Performance (stock frequency)

| Algorithm        |   Coin  |     1070    |   P102-10G  |    1080ti   |     1080    |
| ---------------- | ------- |  ---------- |   --------  |   --------  |   --------  |
| eaglesong        |   CKB   |      -      |     998M    |      -      |      -      |
| ethash           |   ETH   |      -      |    47.2M    |     46M     |     35M     |
| ethash+eaglesong | CKB+ETH | 383.1+24.9M | 439.9+43.6M | 657.6+45.9M | 529.5+31.1M |

## Feature

* Supports Windows & Linux.
* Supports faster dual-mining.
* Dev Fee: 
  * ethash+eaglsong 2%ETH+1%CKB
  * ethash+hns 3% ETH+HNS




## CMD Option

GPU miner,it is only support Nvidia card now !

 Options :

    -P,--pool           Stratum pool. Example
                        ckb pool: stratum+tcp://youraccount.workname@ckb-eu.sparkpool.com:8888
                        eth pool: stratum1+tcp://youraccount.workname@cn.sparkpool.com:3333
                        scheme://[account[.workername]@]hostname:port

    -E                  Dual ming mode, set ETH pool, single ming mode only need set -P 
                        scheme://[account[.workername]@]hostname:port

    -A                  Algorithm supported:ckb,eth,eth_ckb
    -h,--help           Displays this help text and exits
    -V,--version        Show program version and exits
    --api-bind          Default not set. Example:--api-bind 127.0.0.1:3333
                        Use negative port number for readonly mode
    --api-port          Default not set.range from (1~65535) 
                        listen on this port 
    --api-password      Default not set.you can set the password to protect your interaction
    -I,--intensity      Dual ming mode ,ETH hashrate will faster and slave coin hashrate will slower 
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

## Coin:ETH-CKB

### Linux

- **f2pool:** damominer -P stratum+tcp://sp_tttest.workname@ckb.sparkpool.com:8888 -E stratum1+tcp://0x43E5f72D6Ab08fB8034F0dFb34a480B9d256e53C.workname@cn.sparkpool.com:3333 -A eth_ckb
- **sparkpool:** damominer -P stratum+tcp://sp_tttest.workname@ckb.f2pool.com:4300 -E stratum1+tcp://0x43E5f72D6Ab08fB8034F0dFb34a480B9d256e53C.workname@eth.f2pool.com:8008 -A eth_ckb

### Windows

- **f2pool:** damominer -P stratum+tcp://sp_tttest.workname@ckb.sparkpool.com:8888 -E stratum1+tcp://0x43E5f72D6Ab08fB8034F0dFb34a480B9d256e53C.workname@cn.sparkpool.com:3333 -A eth_ckb --mode 1
- **sparkpool:** damominer -P stratum+tcp://sp_tttest.workname@ckb.f2pool.com:4300 -E stratum1+tcp://0x43E5f72D6Ab08fB8034F0dFb34a480B9d256e53C.workname@eth.f2pool.com:8008 -A eth_ckb --mode 1

## FAQ

### Tuning parameter

- **-I:** -I range(0,8),Dual-ming eth_ckb
  
    1.If you want CKB have the best performance ,set I 8    
    damominer -P stratum+tcp://sp_tttest.workname@ckb.sparkpool.com:8888 -E stratum1+tcp://0x43E5f72D6Ab08fB8034F0dFb34a480B9d256e53C.workname@cn.sparkpool.com:3333 -A eth_ckb -I 8

    2.If you want ETH have the best performance ,set I 0
    damominer -P stratum+tcp://sp_tttest.workname@ckb.sparkpool.com:8888 -E stratum1+tcp://0x43E5f72D6Ab08fB8034F0dFb34a480B9d256e53C.workname@cn.sparkpool.com:3333 -A eth_ckb -I 0

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
### V2.5.8 (20200320)

    Supports nicehash protocal.
    Update eth_hns hash rate.

### V2.5.7 (20200313)

    Supports ETH-HNS Dual ming.
    Supports Window & linux.

### V2.4.3 (20200207)

    Supports ETH,CKB,ETH-CKB Dual ming.
    Supports Window & linux.
