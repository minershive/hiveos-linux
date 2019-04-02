v1.5

This is the noncepool.com Bismuth miner for AMD graphics cards running on Linux

Usage: noncepool_miner bismuth_wallet_address worker_name

--skip-gpu		2,3,4
				comma separated list of gpu indexes to skip

An example startup script is included. 


TCP Fastopen is used to reduce latency.
If TCP Fastopen is not enabled I suggest you run:
	sudo sysctl -w net.ipv4.tcp_fastopen=3
Even if TCP Fastopen is not enabled the miner will still function correctly.


If you have any problems contact me in discord or at admin@noncepool.com