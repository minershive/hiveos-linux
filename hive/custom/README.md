# Custom miner integration in Hive OS

You can integrate any miner to Hive. 
For this need to implement several scripts which will be callbacks for Hive scripts. 
Other miners implementations are good points to start your own.

All files should be stored in `/hive/custom/mysuperminer` folder. Don't forget about execute permission for `.sh` files.

`CUSTOM_MINER` - this variable in wallet.conf will hold currently selected miner, like `mysuperminer`. 

##### h-manifest.conf
This is a general config for Hive, not for the miner.
```bash
# The name of the miner like "mysuperminer" 
CUSTOM_NAME=
# Optional version of your custom miner package
CUSTOM_VERSION=
# Full path to miner config file, e.g. /hive/custom/mysuperminer/mysuperminer.json
CUSTOM_CONFIG_FILENAME=
# Full path to log file basename. WITHOUT EXTENSION (don't include .log at the end)
# Used to truncate logs and rotate,
# E.g. /var/log/miner/mysuperminer/somelogname (filename without .log at the end)
CUSTOM_LOG_BASENAME=
```  

##### h-config.sh
Called every time the miner is started. Should generate miner config file.
Wallet and rig config variables are already in the scope, the script is included in `/hive/bin/custom`.
So you can use `$CUSTOM_URL`, `$CUSTOM_USER_CONFIG`, etc. in this script.


##### h-run.sh
Runs the miner. 
You can set LD_LIBRARY_PATH here, redirect output to file, etc. 
Working dir is `/hive/custom/mysuperminer` directory.


##### h-stats.sh
Provides miner stats as JSON. Used by `agent`.

While implementing this script please look at other miners implements in `agent.miner_stats.sh`.
Sometimes the miner does not provide temps or fan,  in this case you could use system values.
This script is not run separately but included in the calling agent script 
so all the variables of `agent` are in the scope.
 
The script MUST define 2 variables.
`$khs` should hold total hashrate of the miner. 
`$stats` should hold JSON stats data.

Example of `$stats` var:
```json
{ 
	"hs": [123, 223.3], //array of hashes
	"hs_units": "khs", //Optional: units that are uses for hashes array, "hs", "khs", "mhs", ... Default "khs".   
	"temp": [60, 63], //array of miner temps
	"fan": [80, 100], //array of miner fans
	"uptime": 12313232, //seconds elapsed from miner stats
	"ar": [123, 3], //Optional: acceped, rejected shares 
	"algo": "customalgo" //Optional: algo used by miner, should one of the exiting in Hive  
}
```


