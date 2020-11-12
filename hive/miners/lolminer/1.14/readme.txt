lolMiner 1.12

For a short introduction how to mine using lolMiner, see
https://github.com/Lolliedieb/lolMiner-releases/wiki

Also have a look to the mine_coin.bat or mine_coin.sh files which can be used as 
starting point to run lolMiner on the command line.

Here is a list of the most relevant parameters for lolMiner:

General:
  -h [ --help ]                         Help screen
  --config arg (=./lolMiner.cfg)        Config file
  --json arg (=./user_config.json)      Config file in Json format
  --profile arg                         Profile to load from Json file
  --list-coins                          List all supported coin profiles
  --list-algos                          List all supported algorithms
  --list-devices                        List all supported & detected GPUs in 
                                        your system
  -v [ --version ]                      Print lolMiner version number

Mining:
  -c [ --coin ] arg                     The coin to mine
  -p [ --pool ] arg                     Mining pool to mine on
                                        Format: <pool>:<port>
  -u [ --user ] arg                     Wallet or pool user account to mine on
  --pass arg                            Pool user account password (Optional)
  --tls arg                             Toggle TLS ("on" / "off")
  --devices arg                         The devices to mine on (ALL / AMD / 
                                        NVIDIA or a comma separated list of 
                                        indexces)
  --devicesbypcie [=arg(=on)] (=off)    Interpret --devices as list of PCIE 
                                        BUS:SLOT pair
  -a [ --algo ] arg                     The algorithm to mine. 
                                        This is an alternative to --coin. 
  --pers arg                            The personalization string. 
                                        Required when using --algo for Equihash
                                        algorithms
  --keepfree arg (=5)                   Set the number of MBytes of GPU memory 
                                        that should be left free by the miner.
  --benchmark arg                       The algorithm to benchmark

Statistics:
  --apiport arg (=0)                    The port the API will use
  --longstats arg (=150)                Long statistics interval
  --shortstats arg (=30)                Short statistics interval
  --digits arg                          Number of digits in hash speed after 
                                        delimiter
  --timeprint [=arg(=on)] (=off)        Enables time stamp on short statistics
  --compactaccept [=arg(=on)] (=off)    Enables compact accept notification
  --log [=arg(=on)]                     Enables printing a log file
  --logfile arg                         Path to a custom log file location

Ethash Options:
  --ethstratum arg (=ETHV1)             Ethash stratum mode. Available options:
                                        ETHV1: EthereumStratum/1.0.0 (Nicehash) 
                                        ETHPROXY: Ethereum Proxy
  --worker arg (=eth1.0)                Separate worker name for Ethereum Proxy
                                        stratum mode.
  --dagdelay [=arg(=0)] (=-1)           Delay between creating the DAG buffers 
                                        for the GPUs. Negative values enable 
                                        parallel generation (default).
  --enable-ecip1099 [=arg(=on)] (=off)  Enable reduced DAG size for mining ETC 
                                        from block 11.730.000 and higher.
  --benchepoch arg (=350)               The DAG epoch the denchmark mode will 
                                        use
  --enablezilcache [=arg(=1)] (=0)      Allows 8G+ GPUs to store the DAG for 
                                        mining Zilliqa. It will generated only 
                                        once and offers a faster switching.
  --4g-alloc-size arg (=0)              Sets the memory size (in MByte) the 
                                        miner is allowed for Ethash on 4G 
                                        cards. Suggested values: 
                                        Linux: 4076 Windows: 4024
  --win4galloc [=arg(=1)] (=0)          Enables (1) / Disables (0) experimental
                                        4G DAG allocation mode on Windows.


