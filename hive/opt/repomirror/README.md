# Hive packages repository mirror setup

If you have local web server on your farm with packages repository
you can set it's URL in farm settings so the rigs will update from your server.
This is useful for faster updates and to preserve traffic.

Any rig from your network can be turned into such local server.
Several tens of Gb are required.

Then manually install mirror package, it will install web server as well.
`/hive/opt/repomirror/repomirror -i`
After this Lighttpd web server should be running on this machine.

Sync is done once per hour.

You can run it manually `/hive/opt/repomirror/repomirror -s`
also there is log file of cron job here `/var/log/hive-repo-sync.log`.

If you want to use alternate reference server to download from,
you can create `/hive-config/repo-sync.url` with URL of that server,
like `http://your.another.mirror/repo/binary/`

In your browser you can check mirror by opening `http://your.rig.ip/repo/binary/`,
if it's ok set this URL in farm settings.

Use `/hive/opt/repomirror/repomirror -h` for other options

repomirror  -i | --install    install httpd and enable repo syncing
repomirror  -e | --enable     enable httpd and repo syncing
repomirror  -d | --disable    disable httpd and repo syncing
repomirror  -c | --check      check configuration and httpd
repomirror  -s | --sync       sync repo manually
repomirror  -r | --remove     remove absolete unreferenced packages
repomirror  -u | --uninstall  uninstall httpd and disable repo syncing
repomirror  -l | --log        display repo syncing log
