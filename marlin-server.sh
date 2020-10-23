#!/bin/sh

MON_IP="http://$1"

if [ -z "$1" ]; then
	echo "Insufficient parameters. Please specify Monitor's Server IP"
exit 1
fi

DEST=/etc
SYSTEMD=/usr/lib/systemd

useradd -m -s /bin/bash marlin

rm -rf /etc/promtail
mkdir -p /etc/promtail

cat promtail/promtail.yaml | sed -e 's+'http:/\/\127.0.0.1'+'"$MON_IP"'+g' > $DEST/promtail/promtail.yaml
cp systemd/* $SYSTEMD/system

systemctl enable marlin-server promtail
systemctl restart marlin-server promtail
systemctl status marlin-server promtail &
