#!/bin/sh

# This is a helper script for the TRM auto-tune process. Please make sure
# you've read the CN_AUTOTUNING_WITH_TRM.txt guide first.

# Choose algo here unless cn/r is your target. Only CN algos supported. Run
# the help.bat to list available CN variants.
ALGO=cnr

# Insert your pool below. Change 'tcp' to 'ssl' if you run a SSL stratum
# connection. 
POOL=stratum+tcp://pool.supportxmr.com:7777

# Your wallet. This is the TRM donation/test wallet. PLEASE do replace it
# with your own wallet, this is only to make sure the most lazy of users can
# test this script with zero time invested.
WALLET=479c6JsyawEVAMNZU8GMmXgVPTxd1vdejR6vVpsm7z8y2AvP7C5hz2g5gfrqyffpvLPLYb2eUmmWA5yhRw5ANYyePX7SvLE

# Pool password, very rarely used.
PASSWORD=x

# Auto-Tune parameters

# Subset of devices if you only want to test on a few. Enter -d 0,1,3 to only
# run the first, second and fourth device. Use 
#DEVS="-d 0,1,3"
DEVS=

# Flip the comment between these two lines if you want to use bus order of
# your gpus to match e.g. the OverdriveNTool order.
#BUS_ORDER=--bus_reorder
BUS_ORDER=

# The mode can be QUICK or SCAN. See the tuning guide for more info.
MODE=SCAN

# For scanning multiple intensities, set this to > 1.
RUNS=6

# Copy the full --cn_config=... and paste it here for the secound rounds of
# the test. Adjust the configurations before starting if necessary.
CN_CFG=

# Old legacy GPU environment variables
export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100

./teamredminer -a $ALGO --log_file=autotune_full_log.txt -o $POOL -u $WALLET -p $PASSWORD --auto_tune=$MODE --auto_tune_runs=$RUNS --auto_tune_exit $BUS_ORDER $DEVS $CN_CFG
