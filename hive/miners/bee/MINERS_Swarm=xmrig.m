-MINERS.md
-Miners_Swarm=xmrig
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
