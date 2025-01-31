# https://neon.tech/postgresql/postgresql-getting-started/postgresql-sample-database
createdb dvdrental

docker exec pg_red_1 /bin/bash -c 'cd /tmp/ && rm -rf dvdrental* && wget https://neon.tech/postgresqltutorial/dvdrental.zip && unzip dvdrental.zip && pg_restore -d dvdrental dvdrental.tar'
