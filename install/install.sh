#!/bin/bash
wget -O /tmp/server.zip https://media.forgecdn.net/files/3012/800/SkyFactory-4_Server_4.2.2.zip
wget -O /tmp/gotty_linux_amd64.tar.gz https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz

mkdir -p /srv/minecraft
unzip -d /srv/minecraft /tmp/server.zip
rm /tmp/server.zip
tar xvf /tmp/gotty_linux_amd64.tar.gz -C /usr/local/bin
chmod a+x /usr/local/bin/gotty
rm /tmp/gotty_linux_amd64.tar.gz
cd /srv/minecraft
mv server.properties server.properties.bak
sed -e "s/online-mode=true/online-mode=false/g" server.properties.bak > server.properties
chmod +x *sh
./Install.sh

