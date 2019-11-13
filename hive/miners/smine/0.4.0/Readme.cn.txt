# 命令行参数

  -api string
    	Api 监听地址 (默认 "127.0.0.1:9876")
  -device string
    	指定设备编号, 如 0,1,2,4
  -intensity uint
    	挖矿强度, 范围 1-100.
  -scale float
    	工作集大小, 范围10-30, 支持小数, 默认自动. eth双挖时可在14-17之间调节
  -server string
    	服务器地址 (默认 "ckb.sparkpool.com:8888")
  -version
    	显示版本号
  -wallet string
    	钱包地址或用户名 (默认 "sp_smine")

# 示例

./smine -server ckb.sparkpool.com:8888 -wallet sp_smine

