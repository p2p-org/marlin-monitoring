#!/bin/sh

DEST=/etc
SYSTEMD=/usr/lib/systemd

rm -rf /etc/{grafana,haproxy,loki}
mkdir -p /etc/{grafana,haproxy,loki}

cp -R grafana $DEST/grafana
cp -R haproxy $DEST/haproxy
cp -R loki $DEST/loki

#systemctl enable haproxy
#systemctl restart haproxy
#systemctl status haproxy &

docker-compose up
# docker-compose up >> /dev/null 2>&1
