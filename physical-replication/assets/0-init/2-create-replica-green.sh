#!/bin/bash

docker exec pg_green_1 pg_basebackup -c fast -C -P -v --slot=green -R -h red -D /var/lib/postgresql/data
docker exec pg_green_1 chown -R postgres /var/lib/postgresql/data
docker exec pg_green_1 chmod 750 /var/lib/postgresql/data

docker exec -d pg_green_1 sh -c "/bin/su - postgres -c '/usr/local/bin/pg_ctl -D /var/lib/postgresql/data start'"