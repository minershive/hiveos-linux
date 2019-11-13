# Commandline Arguments

  -api string
    	Api listen address (default "127.0.0.1:9876")
  -device string
    	List of device numbers, like 0,1,2,4
  -intensity uint
    	Mining intensity, range 1-100.
  -scale float
    	Work scale, range 10-30. 0 for auto. 14-17 for eth dual mining, support decimal
  -server string
    	Pool address and port (default "ckb.sparkpool.com:8888")
  -version
    	Show version
  -wallet string
    	Wallet address or user name (default "sp_smine")

# Example

./smine -server ckb.sparkpool.com:8888 -wallet sp_smine

# Api

See api.txt
