#!/bin/bash
mkdir /config/supervisor
exec /usr/bin/supervisord -c /root/supervisor.conf -n 
#exec /home/nobody/start.sh