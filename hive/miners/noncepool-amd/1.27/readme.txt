v1_27

noncepool_miner
------------------------------
noncepool.com  bismuth miner
------------------------------


The heavy3.bin file is created if it does not exist.

If the optimize.txt file does not exist, a quick optimization scan is run on startup.
Setting --worksize or --batch will override this quick scan.
A full (slower) scan can be performed by running --opt

# On Pascal NVIDIA cards, you can get a 5%-20% speed boost by running ETHlargement Pill combined with settings the memory clock to a large negative offset and setting clock offset as high as you want.
# - The proper setting depends on thermal throttling, power limits,  and other things. 
# - On cards that are above 50C and thus being thermally throttled this can bring a large performance boost, as lowering the mem clock allows the core clock to run at a higher frequency.



Usage:
	./noncepool_miner options address workername

Options:
	--worksize		set worksize (64-1024)
	--batch			set batch size (128 - 32768)
	--opt			run full optimization for worksize and batch values
	--skip-gpu		comma separated list of gpus to skip ( example: 0,1,2,3)
	-p				set port number for ccminer stats (default 4028)

v1.27 changes:
 - fix for bug when running longer than 8 days of uptime

v1.26 changes:
 - bugfix

v1.25 changes:
 - 30 MH/s speed up for nvidia

v1.24 changes:
 - Fixed stats when using both amd and nvidia

v1.23 changes:
 - 25-40 MH/s speed increase for Nvidia

v1.22 changes:
 - uses less cpu, only 1 core is pinned
