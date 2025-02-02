We have a <span style='color:red'>red</span> leader, *green* Replica, we can now try a different bootstrapping method.
Two terminals will be required, the process is:

1. We ask a Leader to start a backup
2. We just copy the files from Leader's datadir -> Replica
3. We send a Leader stop backup signal
4. We turn Replicas's datadir to Replica

In Tab1 - connect to <span style='color:red'>red</span> Leader, [create a replication slot](https://pgpedia.info/p/pg_create_physical_replication_slot.html) for *blue* and [start a backup](https://pgpedia.info/p/pg_backup_start.html).

<details><summary>Solution</summary>
<br />

```plain
psql -p $PORT_RED
SELECT pg_create_physical_replication_slot('blue');
SELECT pg_backup_start(label => 'blue', fast => true);
```{{exec}}
</details>

Don't close the `psql` (!), the backup will stop at the session termination. Switch to Tab2 (with + button) and we need to copy the Leader's datadir to *blue* Replica.


<details><summary>Solution</summary>
<br />

```plain
docker cp pg_red_1:/var/lib/postgresql/data data
docker cp data/ pg_blue_1:/var/lib/postgresql/
```{{exec}}
</details>

Also chnage ownership to user `postgres` and permissions to `700`.

<details><summary>Solution</summary>
<br />

```plain
docker exec -it pg_blue_1 /bin/bash
chown -R postgres /var/lib/postgresql/data
chmod 700 /var/lib/postgresql/data/
exit
```{{exec}}
</details>

You can close Tab2. Now we can go back to Tab1 and either simply close the session (quit `psql`) or explicitly [end backup](https://pgpedia.info/p/pg_backup_stop.html).

<details><summary>Solution</summary>
<br />

```plain
SELECT * FROM pg_backup_stop(wait_for_archive => false);
\q
```{{exec}}
</details>

We have the corrent datadir for the replica, however it has no idea it should follow <span style='color:red'>red</span> Leader, make it a proper Replica. Connect inside the *pg_blue_1* container.


<details><summary>Solution</summary>
<br />

```plain
docker exec -it pg_blue_1 /bin/bash
```{{exec}}
</details>

Use the [precreated replication slot](https://postgresqlco.nf/doc/en/param/primary_slot_name/) and [let it follow the primary](https://www.postgresql.org/docs/11/standby-settings.html).

<details><summary>Solution</summary>
<br />

```plain
touch /var/lib/postgresql/data/standby.signal
echo >>/var/lib/postgresql/data/postgresql.auto.conf "primary_conninfo = 'user=root passfile=''/root/.pgpass'' channel_binding=prefer host=''red'' port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'"
echo >>/var/lib/postgresql/data/postgresql.auto.conf "primary_slot_name = 'blue'"
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

You can now connect to *blue* Replica and verify that the `mydb` exists there.

<details><summary>Solution</summary>
<br />

```plain
psql -p $PORT_BLUE mydb
\dt
```{{exec}}
</details>

Quit the `psql`.

```plain
\q
```{{exec}}

<br />