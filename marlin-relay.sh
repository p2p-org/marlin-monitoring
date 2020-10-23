#!/bin/sh

MON_IP="http://$1"
BEACON_IP=$2

if [ -z "$1" ] || [ -z "$2" ]; then
	echo "Insufficient parameters. Please specify Monitor's Server IP as first argument and Marlin Beacon's Server IP as second argument"
exit 1
fi

DEST=/etc
SYSTEMD=/usr/lib/systemd

useradd -m -s /bin/bash marlin

cat systemd/marlin-relay.service | sed -e 's+'127.0.0.1'+'"$BEACON_IP"'+g' > $SYSTEMD/system/marlin-relay.service

rm -rf /etc/promtail
mkdir -p /etc/promtail

cat promtail/promtail.yaml | sed -e 's+'http:/\/\127.0.0.1'+'"$MON_IP"'+g' > $DEST/promtail/promtail.yaml
cp systemd/* $SYSTEMD/system

systemctl enable marlin-relay promtail
systemctl restart marlin-relay promtail
systemctl status marlin-relay promtail &
