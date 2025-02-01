#!/bin/bash

mkdir -p /root/bin/
mkdir -p /mnt/red/ /mnt/green/ /mnt/blue/ /mnt/wal-archive/

echo >>/root/.bashrc export PORT_RED=6432
echo >>/root/.bashrc export PORT_GREEN=7432
echo >>/root/.bashrc export PORT_BLUE=8432
echo >>/root/.bashrc "export PATH=$PATH:/root/bin/:/root/bin/0-init/:/root/bin/1-load-data/"

echo >>/root/.bashrc export PGUSER=postgres
echo >>/root/.bashrc export PGHOST=localhost
echo >>/root/.bashrc export PGPORT=6432 # red

sudo apt install -y curl ca-certificates
sudo install -d /usr/share/postgresql-common/pgdg
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
sudo sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt update
sudo apt install -y postgresql-client-17 postgresql-17
sudo systemctl disable --now postgresql
sudo systemctl mask postgresql

cd /ks/pg
docker-compose up -d
touch /ks/.k8sfinished

# mark init finished
touch /ks/.initfinished

# delayed - ~3 mins of startup
cd /ks/pgadmin
docker-compose up -d
