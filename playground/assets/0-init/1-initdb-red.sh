#!/bin/bash

docker exec pg_red_1 rm -rf /var/log/postgresql/data/*
docker exec pg_red_1 mkdir -p /var/log/postgresql/data/
docker exec pg_red_1 chown postgres /var/lib/postgresql/data/ /var/log/postgresql/

docker exec pg_red_1 /bin/su - postgres  -c '/usr/local/bin/initdb -D /var/lib/postgresql/data/ -k'

docker exec pg_red_1 sh -c 'echo >> /var/lib/postgresql/data/pg_hba.conf "host all all  0.0.0.0/0 trust"'
docker exec pg_red_1 sh -c 'echo >> /var/lib/postgresql/data/pg_hba.conf "host replication all  0.0.0.0/0 trust"'

docker exec -d pg_red_1 sh -c "/bin/su - postgres -c '/usr/local/bin/pg_ctl -D /var/lib/postgresql/data start'"
psql -p $PORT_RED -c 'create user repl with superuser'
psql -p $PORT_RED -c 'create database mydb'

#pgbench -h localhost -U postgres -d mydb -i
#pgbench -h localhost -U postgres -d mydb -P1 -j 10 -t 1000
#select pg_current_wal_lsn(); \watch 1
#select pg_current_wal_lsn(), pg_current_wal_insert_lsn();
