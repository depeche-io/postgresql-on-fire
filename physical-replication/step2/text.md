We have a *red* leader, now we can bootstrap a first replica. We'll use standard procedure for this including `pg_basebackup` tool.

Connect inside the *pg_green_1* container.

<details><summary>Solution</summary>
<br />

```plain
docker exec -it pg_green_1 /bin/bash
```{{exec}}
</details>

Now create a replica via pg_basebackup from *red*. Use replication slot *green* for it. You can do this as `root`, we'll corrent permissions later on.

<details><summary>Solution</summary>
<br />

```plain
pg_basebackup -c fast -C -P -v --slot=green -R -h red -D /var/lib/postgresql/data
```{{exec}}
</details>

Now change datadir ownership to `postgres` and permissions to `750`.

<details><summary>Solution</summary>
<br />

```plain
chown -R postgres /var/lib/postgresql/data
chmod 750 /var/lib/postgresql/data
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

You can now connect to *green* Replica and verify that the `mydb` exists there.

<details><summary>Solution</summary>
<br />

```plain
psql -p $PORT_GREEN mydb
\dt
```{{exec}}
</details>
(and exit)

<br />