lolMiner 1.0

For a short introduction how to mine using lolMiner, see
https://github.com/Lolliedieb/lolMiner-releases/wiki

Also have a look to the mine_coin.bat or mine_coin.sh files which can be used as 
starting point to run lolMiner on the command line.

Here is a list of the most relevant parameters for lolMiner:

General:
  -h [ --help ]                       Help screen
  --config arg                        Config file
  --json arg                          Config file in Json format
  --profile arg                       Profile to load from Json file
  --list-coins                        List all supported coin profiles
  --list-algos                        List all supported algorithms
  --list-devices                      List all supported & detected GPUs in 
                                      your system
  -v [ --version ]                    Print lolMiner version number

Mining:
  -c [ --coin ] arg                   The coin to mine
  -p [ --pool ] arg                   Mining pool to mine on
                                      Format: <pool>:<port>
  -u [ --user ] arg                   Wallet or pool user account to mine on
  --pass arg                          Pool user account password (Optional)
  --tls [=arg(=on)]                   Toggle TLS (on / off)
  --devices arg                       The devices to mine on (ALL / AMD / 
                                      NVIDIA or a comma separated list of 
                                      indexces)
  -a [ --algo ] arg                   The algorithm to mine. 
                                      This is an alternative to --coin. 
  --pers arg                          The personalization string. 
                                      Required when using --algo for Equihash 
                                      algorithms
  --benchmark arg                     The algorithm to benchmark

Statistics:
  --apiport arg (=0)                  The port the API will use
  --longstats arg (=150)              Long statistics interval
  --shortstats arg (=30)              Short statistics interval
  --timeprint [=arg(=on)] (=off)      Enables time stamp on short statistics
  --compactaccept [=arg(=on)] (=off)  Enables compact accept notification
  --log [=arg(=on)]                   Enables printing a log file
  --logfile arg                       Path to a custom log file location

