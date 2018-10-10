# Miner Integration Brief

Please study other miners integration

Naming convention of naming a directory. Fork is optional.
```
minername/[fork]/version
```


Miner generated config MUST be a symlink to `/run/hive/miners/minername/someconfig.json`.
This is required for PXE boot to keep hive folder readonly.
Real file is created with `mkfile_from_symlink` command in h-config.sh


The following files are not run as scripts, they are included as `source` from running script, `miner`, `miner-run`.
These scripts should not have execute permission to stop attempts to run them separately.

##### h-manifest.conf
This is a general config for Hive integration, not for the miner itself.
```bash
# Required
# Must be the same as miner's base directory
MINER_NAME=xmrig

# Optional
# Full path to log file basename. WITHOUT EXTENSION (don't include .log at the end)
# Used to truncate logs and rotate,
# E.g. /var/log/mysuperminer/somelogname (filename without .log at the end)
# MINER_LOG_BASENAME=/var/log/miner/$MINER_NAME/$MINER_NAME

# Optional. May be used in miner's config generatino
# API port used to collect stats
MINER_API_PORT=60050

# Optional
# If miner has configurable fork this should define default
#MINER_DEFAULT_FORK=legacy

# Required 
# Should be set to the latest version of miner which you have implemented 
MINER_LATEST_VER=2.6.4


# Optional
# If miner required libcurl3 compatible lib you can enable this
LIBCURL3_COMPAT=0
```

##### h-config.sh
Should generate miner config file.

MUST implement the following functions
```bash
# Returns the version which is running now. 
function miner_ver() {
	echo $MINER_LATEST_VER
}

# Not required
# Returns configured fork
function miner_fork() {
	echo $MINER_DEFAULT_FORK
}

# Outputs generated config file
function miner_config_echo() {
	export MINER_FORK=`miner_fork`
	local MINER_VER=`miner_ver`
	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_FORK/$MINER_VER/miner.cfg"
}

# Generates config file
function miner_config_gen() {
	local MINER_CONFIG="$MINER_DIR/$MINER_FORK/$MINER_VER/miner.cfg"
	mkfile_from_symlink $MINER_CONFIG

	conf=`cat $MINER_DIR/miner.global.cfg | envsubst`
	#...
	
	echo -e "$conf" > $MINER_CONFIG
}
```


##### h-run.sh
Runs the miner. Checks for exiting process, API bindings and just runs the binnary.



##### h-stats.sh
Script is included inside a function. 
Please try to define your variables **local**. 

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
	"algo": "customalgo", //Optional: algo used by miner, should one of the exiting in Hive
	"bus_numbers": [0, 1, 12, 13] //Pci buses array in decimal format. E.g. 0a:00.0 is 10
}
```
 