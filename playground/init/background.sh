#!/bin/bash

mkdir -p /root/bin/
mkdir -p /mnt/red/ /mnt/green/ /mnt/blue/ /mnt/wal-archive/

echo >>/root/.bashrc export PGUSER=postgres
echo >>/root/.bashrc export PGHOST=localhost

# wait fo k8s ready
cd /ks/pg
docker-compose up -d
touch /ks/.k8sfinished

# mark init finished
touch /ks/.initfinished
