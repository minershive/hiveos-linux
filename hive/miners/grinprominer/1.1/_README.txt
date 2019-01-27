GrinPro
-----------------------------------

Make sure you have latest drivers. PTX JIT failure on nvidia is an indication that drivers don't have Cuda10 support.
Check with nvidia-smi.

Optimize CPU usage:

Change value in config.xml
<CPUOffloadValue>0</CPUOffloadValue>

0   - automatic CPU load balancer
10  - minimal CPU usage, less GPS
100 - maximum CPU usage, more GPS

numbers between 0 .. 100+ are possible