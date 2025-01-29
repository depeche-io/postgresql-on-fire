
#!/bin/bash

docker exec pg_blue_1 pg_basebackup -c fast -C -P -v --slot=blue -R -h red -D /var/lib/postgresql/data
docker exec pg_blue_1 chown -R postgres /var/lib/postgresql/data
docker exec pg_blue_1 chmod 750 /var/lib/postgresql/data