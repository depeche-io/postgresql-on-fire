
#!/bin/bash

docker exec pg_green_1 pg_basebackup -c fast -C -P -v --slot=green -R -h red -D /var/lib/postgresql/data
docker exec pg_green_1 chown -R postgres /var/lib/postgresql/data
docker exec pg_green_1 chmod 750 /var/lib/postgresql/data
