You may put OpenVPN config and keys here:

anyconfigname.conf
ca.crt
anynameclientkey.crt
anynameclientkey.key

If anyconfigname.conf is found then files will be linked to /etc/openvpn and service started

anyconfigname.conf will be linked to /etc/openvpn/client.conf
ca.crt will be linked to /etc/openvpn/ca.crt
anynameclientkey.crt will be linked to /etc/openvpn/client.crt
anynameclientkey.key will be linked to /etc/openvpn/client.key

So that files ca.crt, client.crt, client.key must be referenced in your config assuming that they will be in /etc/openvpn


Running service will be "openvpn@client"
systemctl restart openvpn@client
