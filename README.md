# marlin-monitoring

Marlin monitoring using Grafana, Loki, and Promtail. Log data obtained from systemd-journal.

## Description

Grafana, Loki, and Promtail monitoring stack expects Marlin Beacon & Marlin Relay servers were prebuilt from official [Marlin repository](https://github.com/marlinprotocol/OpenWeaver) and run on the same VM or separate VMs outside Docker containers. Set 'marlin' process owner for both Marlin Beacon and Relay servers is recommended.

The monitoring itself uses Doker Compose to run Grafana & Loki, but Promtail should be run on the same respective VMs where Marlin Beacon or Marlin Relay servers run. 

Loki Docker image exposes 127.0.0.1:3100 for Loki stream input from local or remote Promtail instance. If monitoring running on a different machine or Docker instance, addtional Linux iptables(8) setup required to redirect egress ports to localhost:3100.

__Please note:__ To run Marlin protocol componets you need to setup [Ethereum full node](https://github.com/ethereum/go-ethereum) first.

## System requirements

Configuration tested on Debian/Ubuntu Linux only, so using another distributions can requre some additional work.
For additonal information please read corresponding repositories READMEs to build logging stack and Marlin core components itself directly from source. 

## Running Marlin monitoring stack locally

* Build Promtail from official [Loki repository](https://github.com/grafana/loki)
* Put Grafana, Loki, and Promtail config files to their respective locations
* Run Promtail from promtail.service systemd unit using 'promtail' user as process owner
* Run Marlin Beacon and Relay servers on their respective VMs or locally using systemd services

## Files and directories

__docker-compose.yml__

The configuration for docker-compose to run Grafana + loki in Docker containers

```shell
docker-compose up
```

__promtail/__

Contains promtail.yaml to put into __/etc/promtail/__ on each VM with Marlin Beacon and Realay servers

__grafana/__

Has grafana.ini config to put it into __/etc/grafana/__
and marlin-loki.json dashboard template to import it into Grafana

__loki/__

Contains local.yaml configuration file which should be placed into __/etc/loki/__

__systemd/__

Contains systemd units to start marlin-server, marlin-relay, and promtail itself. __*.service__ files should be copied to __/usr/lib/systemd/system/__

```shell
systemctl enable marlin-server marlin-relay promtail
systemctl start marlin-server marlin-relay promtail
systemctl status marlin-server marlin-relay promtail
```

__haproxy/__

Contains haproxy.cfg configuration file to serve SSL/TLS requests to Grafana Web server Docker intances

```shell
systemctl enable haproxy
systemctl start haproxy
systemctl status haproxy
```

## Lincense

Apache License 2.0
