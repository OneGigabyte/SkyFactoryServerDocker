#!/bin/bash
wget -O /tmp/cn.zip https://modpack-1257209710.cos.ap-guangzhou.myqcloud.com/SkyFactory%204-4.1.0-linux.zip
unzip -d /tmp/cn /tmp/cn.zip
rsync -rltp /tmp/cn/ /srv/minecraft
rm -rf /tmp/cn
rm /tmp/cn.zip