#!/bin/bash

# wait fo k8s ready
while ! kubectl get nodes | grep -w "Ready"; do
  echo "WAIT FOR NODES READY"
  sleep 1
done
touch /ks/.k8sfinished

# allow pods to run on controlplane
kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule-
kubectl drain --ignore-daemonsets node01

ssh node01  <<EOF
dd if=/dev/zero of="/pgroot" bs=1M count=5000
mkfs.ext4 /pgroot 
mkdir -p /mnt/pgroot
mount /pgroot /var/lib/postgresql/16

sudo apt install -y postgresql-common
sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh <<< ""

#sudo apt install curl ca-certificates
#sudo install -d /usr/share/postgresql-common/pgdg
#sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
#sudo sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

sudo apt update
sudo apt install postgresql-16


curl https://raw.githubusercontent.com/devrimgunduz/pagila/refs/heads/master/pagila-schema.sql | sudo -u postgres psql
curl https://raw.githubusercontent.com/devrimgunduz/pagila/refs/heads/master/pagila-data.sql | sudo -u postgres psql

# scenario 1:
dd if=/dev/zero of="/var/lib/postgresql/16/some-file.bin" bs=1M
EOF

# mark init finished
touch /ks/.initfinished
