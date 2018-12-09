# Custom miner integration in Hive OS

You can integrate any miner to Hive. 
For this need to implement several scripts which will be callbacks for Hive scripts. 
Other miners implementations are good points to start your own.

All files should be stored in `/hive/miners/custom/mysuperminer` folder. Don't forget about execute permission for `.sh` files.

`CUSTOM_MINER` - this variable in wallet.conf will hold currently selected miner, like `mysuperminer`. 

##### h-manifest.conf
This is a general config for Hive, not for the miner.
```bash
# The name of the miner like "mysuperminer" 
CUSTOM_NAME=
# Optional version of your custom miner package
CUSTOM_VERSION=
# Full path to miner config file, e.g. /hive/miners/custom/mysuperminer/mysuperminer.json
CUSTOM_CONFIG_FILENAME=
# Full path to log file basename. WITHOUT EXTENSION (don't include .log at the end)
# Used to truncate logs and rotate,
# E.g. /var/log/miner/mysuperminer/somelogname (filename without .log at the end)
CUSTOM_LOG_BASENAME=
```  

##### h-config.sh
Called every time the miner is started. Should generate miner config file.
Wallet and rig config variables are already in the scope, the script is included in `/hive/bin/custom`.
So you can use `$CUSTOM_URL`, `$CUSTOM_USER_CONFIG`, `$CUSTOM_ALGO` etc. in this script.


##### h-run.sh
Runs the miner. 
You can set LD_LIBRARY_PATH here, redirect output to file, etc. 
Working dir is `/hive/miners/custom/mysuperminer` directory.


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
```javascript
{ 
	"hs": [123, 223.3], //array of hashes
	"hs_units": "khs", //Optional: units that are uses for hashes array, "hs", "khs", "mhs", ... Default "khs".   
	"temp": [60, 63], //array of miner temps
	"fan": [80, 100], //array of miner fans
	"uptime": 12313232, //seconds elapsed from miner stats
	"ver": "1.2.3.4-beta", //miner version currently run, parsed from it's api or manifest 
	"ar": [123, 3], //Optional: acceped, rejected shares 
	"algo": "customalgo", //Optional: algo used by miner, should one of the exiting in Hive
	"bus_numbers": [0, 1, 12, 13] //Pci buses array in decimal format. E.g. 0a:00.0 is 10
}
```



## Packaging 
After you've implemented all the scripts `tar.gz` archive should be created so the users will be able to install it.
Archive filename MUST be in the following format `mysuperminer-version.tar.gz`, version is optional and should not contain "-".
Archive MUST contain a directory with the name of miner.

Example directory structure
```
drwxr-xr-x root/root    mysuperminer/
-rwxr-xr-x root/root    mysuperminer/h-run.sh
-rwxr-xr-x root/root    mysuperminer/mysuperminer-binary
-rwxr-xr-x root/root    mysuperminer/h-stats.sh
-rw-r--r-- root/root    mysuperminer/h-manifest.conf
-rwxr-xr-x root/root    mysuperminer/h-config.sh
-rw-r--r-- root/root    mysuperminer/mysuperminer.conf
``` 

Command to create archive
```bash
tar -zcvf mysuperminer-0.13_beta.tar.gz mysuperminer
```
