Each cluster is created by creating a leader (primary instance). Running container *red* should be used for this.

Connect inside the *pg_red_1* container.

<details><summary>Solution</summary>
<br />

```plain
docker exec -it pg_red_1 /bin/bash
```{{exec}}
</details>

Create `/var/log/postgresql/data/` and change owner to `postgres` (you are a root inside the container, PG needs to be run as `postgres` user).

<details><summary>Solution</summary>
<br />
```plain
mkdir -p /var/log/postgresql/data/
chown postgres /var/lib/postgresql/data/ /var/log/postgresql/
```{{exec}}
</details>

As a user `postgres` [initialize empty database cluster](https://www.postgresql.org/docs/current/app-initdb.html). Enable checksums (we will need them later on).

<details><summary>Solution</summary>
<br />

```plain
su - postgres  -c '/usr/local/bin/initdb -D /var/lib/postgresql/data/ -k'
```{{exec}}
</details>

Now enable network login for other users. In our solution, we enable `trust` for all users and also for `replication`. This is NOT a production setup, however it makes it much easier go through the tutorial later on.

<details><summary>Solution</summary>
<br />
```plain
echo >> /var/lib/postgresql/data/pg_hba.conf "host all all  0.0.0.0/0 trust"
echo >> /var/lib/postgresql/data/pg_hba.conf "host replication all  0.0.0.0/0 trust"
```{{exec}}
</details>

Now let's start the Postgres (as `postgres` user).

<details><summary>Solution</summary>
<br />
```plain
su - postgres -c '/usr/local/bin/pg_ctl -D /var/lib/postgresql/data start'
```{{exec}}
</details>

And let's quit container shell.
```plain
exit
```{{exec}}

Let's now work from the host OS and create a user `repl` with superuser priviledges and `mydb` database.

<details><summary>Solution</summary>
<br />
```plain
psql -p $PORT_RED -c 'create user repl with superuser'
psql -p $PORT_RED -c 'create database mydb'
```{{exec}}
</details>
(and exit)

We should generate some small load. This way there will be some constant data influx to *red* and you can check these data changes later on.

Open the second shell (+ Tab) and run [pgbench](https://www.postgresql.org/docs/current/pgbench.html) there. You can keep it running with `1 thread` during the whole scenario.

<details><summary>Solution</summary>
<br />
```plain
pgbench -d mydb -i -P1 -j 1 -T 3600
```{{exec}}
</details>



<br />