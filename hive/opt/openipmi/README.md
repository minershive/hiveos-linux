# Hive IPMI-sim Hypervisor

IPMI-sim makes it possible to control the power of the rig as BMC-compatible devices.
(using ipmitool, MAAS-service etc.)

Then manually install.
```bash
apt install hive-ipmi
```

## Default setting:

**auth: "user", "1"**

**port: 9001**

Settings can be changed in */hive/opt/openipmi/etc/ipmi/lan.conf*

## Available signals:

* *power status* - If the service is working, the answer will always be *"Chassis Power is on"*
* *power reset* - Immediately hard reboot the system
* *power off* - Immediately shut off the system

