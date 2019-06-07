#!/bin/bash

echo "------------------------START Miner----------------------"
export UV_THREADPOOL_SIZE=24
./sushi-miner-opencl
echo "------------------------END Miner----------------------"
echo "something went wrong or you exited"
