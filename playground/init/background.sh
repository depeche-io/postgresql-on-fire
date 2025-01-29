#!/bin/bash

mkdir -p /root/bin/
mkdir -p /mnt/red/ /mnt/green/ /mnt/blue/ /mnt/wal-archive/

echo >>/root/.bashrc export PORT_RED=6432
echo >>/root/.bashrc export PORT_GREEN=7432
echo >>/root/.bashrc export PORT_BLUE=8432

echo >>/root/.bashrc export PGUSER=postgres
echo >>/root/.bashrc export PGHOST=localhost
echo >>/root/.bashrc export PGPORT=6432 # red

sudo apt install -y curl ca-certificates
sudo install -d /usr/share/postgresql-common/pgdg
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
sudo sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt update
sudo apt install -y postgresql-client-17

cd /ks/pg
docker-compose up -d
touch /ks/.k8sfinished

# mark init finished
touch /ks/.initfinished
