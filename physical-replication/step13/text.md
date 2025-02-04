*green* is Leader followed by *red* Replica and next to them we have disabled *blue* Leader2 with a split-brain condition. We would like to make *blue* Replica again following *green*. There are basically three options on how to achieve this:
* recreate *blue* as a Replica (delete it and follow the `pg_basebackup` steps)
* recreate *blue* from backups (similar as before but typically much faster for larger DBs)
* use `pg_rewind` tool bundled in Postgres

"[pg_rewind](https://www.postgresql.org/docs/current/app-pgrewind.html) examines the timeline histories of the source and target clusters to determine the point where they diverged, and expects to find WAL in the target cluster's pg_wal directory reaching all the way back to the point of divergence."<br />

So in order for this to work, you need WAL file history up to a branching point. In our case we should have it.

Enter *blue* container *pg_blue_1*.
<details><summary>Solution</summary>
<br />

```plain
docker exec -it pg_blue_1 /bin/bash
```{{exec}}
</details>


Let's `pg_rewind` to *green* (as user `postgres`).
<details><summary>Solution</summary>
<br />

```plain
su - postgres -c 'pg_rewind -D /var/lib/postgresql/data --source-server=host=green -P'
```{{exec}}
</details>

If the process has succeeded, we should now have the same datadir as the Leader has. So we should turn *blue* into *green* replica.
<details><summary>Solution</summary>
<br />

```plain
touch /var/lib/postgresql/data/standby.signal
echo >>/var/lib/postgresql/data/postgresql.auto.conf "primary_conninfo = 'user=postgres passfile=''/root/.pgpass'' channel_binding=prefer host=''green'' port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'"
echo >>/var/lib/postgresql/data/postgresql.auto.conf "primary_slot_name = 'blue'"
```{{exec}}
</details>
(In this scenario, we are reusing already created replication slot, but typically you might need to create a replication slot before the process.)<br />

And start Postgres (as user `postgres`).
<details><summary>Solution</summary>
<br />

```plain
su - postgres -c '/usr/local/bin/pg_ctl -D /var/lib/postgresql/data start'
```{{exec}}
</details>

(exit the container)

```plain
exit
```{{exec}}

So what has just happened? *blue* was turned into a Replica again, but we've lost some data in the process. You can verify that the `datatable` is no more.
<details><summary>Solution</summary>
<br />

```plain
psql -p $PORT_BLUE -c 'SELECT * FROM datatable;'
```{{exec}}
</details>
