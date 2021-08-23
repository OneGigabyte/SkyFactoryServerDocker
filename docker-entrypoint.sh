#!/bin/bash
java -version
cd /opt/server/
nohup ./ServerStart.sh > /var/log/mc-server.log 2>&1 &
exec "$@"