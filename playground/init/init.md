<br>

You are currently in an empty playground environment.

There are 3 PG containers controlled via /ks/pg/docker-compose.yaml <br />
*red*
* port $PORT_RED = 6432 -> 5432
* datadir /mnt/red
```plain
docker exec -it pg_red_1 /bin/bash
```{{exec}}

*green*
* port $PORT_GREEN = 7432 -> 5432
* datadir /mnt/green
```plain
docker exec -it pg_green_1 /bin/bash
```{{exec}}

*blue*
* port $PORT_BLUE = 8432 -> 5432
* datadir /mnt/blue
```plain
docker exec -it pg_blue_1 /bin/bash
```{{exec}}

# Creating a Postgres database cluster

You can either continue yourself or let a script start Postgres in each of the containers:
```plain
0-init-all-for-me.sh
```{{exec}}

Or you can go more granular:
```plain
1-initdb-red.sh
```{{exec}}
```plain
2-create-replica-green.sh
```{{exec}}
```plain
3-create-replica-blue.sh
```{{exec}}

# Loading sample data

You can use these to load some sample data creating `pagilla`, `datatable`, `exercises`, `dvdrental` and `mydb` databases:
```plain
load-pagilla-dataset.sh
load-random-datatable.sh
load-pgexercises.sh
load-neon-tutorial-dvdrental.sh
pgbench.sh
```{{exec}}

(pgbench will run for 10s)

# Accessing PG nodes

Either exec inside docker via previous commands, or you can `psql -p PORT` from the host:
```plain
psql -p $PORT_RED mydb
```{{exec}}
```plain
psql -p $PORT_GREEN mydb
```{{exec}}
```plain
psql -p $PORT_BLUE mydb
```{{exec}}

Also, there is a PgAdmin4, if you like:
* Check out Menu (next to time, upper right corner) -> Ports to access port 80
* postgres@killercoda.sh / postgres

(setup connection to `red` (leader), `green` or `blue` host as user `postgres`, password does not matter) <br />
(takes ~4 mins to start, be patient or use `psql`)

<br />