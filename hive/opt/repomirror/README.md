# Hive packages repository mirror setup

If you have local web server on your farm with packages repository 
you can set it's URL in farm settings so the rigs will update from your server.
This is useful for faster updates and to preserve traffic.

Any rig from your network can be turned into such local server.

First don't forget to `disk-expand` so that you will have enough space for packages.
Several Gb are required.

Then manually install mirror package, it will install web server as well. 
```bash
apt install hive-opt-repomirror
```

After this Nginx web server should be running on this machine.

Sync is done once per hour.
  
You can run it manually `/hive/opt/repomirror/updaterepo`, 
also there is log file of cron job here `/var/log/hive-repo-sync.log`.

In your browser you can check mirror by opening `http://your.rig.ip/repo/binary`,
if it's ok set this URL in farm settings.
