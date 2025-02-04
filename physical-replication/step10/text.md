Now *red* Old Leader is stopped, *green* New Leader is running and *blue* Replica is following a *green* New Leader. We also need to turn *red* into a replica of *green* New Leader.<br />
<br />
The most important part is to do this procedure *BEFORE* the *red* is started again, otherwise it would start up as a Leader and might get some additional writes (you'll see later on).

Enter the *red* container *pg_red_1*.
<details><summary>Solution</summary>
<br />

```plain
docker exec -it pg_red_1 /bin/bash
```{{exec}}
</details>

Now turn original Leader to a Replica with a similar procedure used in Step3

<details><summary>Solution</summary>
<br />

```plain
touch /var/lib/postgresql/data/standby.signal
echo >>/var/lib/postgresql/data/postgresql.auto.conf "primary_conninfo = 'user=postgres passfile=''/root/.pgpass'' channel_binding=prefer host=''green'' port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'"
echo >>/var/lib/postgresql/data/postgresql.auto.conf "primary_slot_name = 'red'"
```{{exec}}
</details>

And start Postgres (as user `postgres`).
<details><summary>Solution</summary>
<br />

```plain
su - postgres -c '/usr/local/bin/pg_ctl -D /var/lib/postgresql/data start'
```{{exec}}
</details>

(exit the container shell)
```plain
exit
```{{exec}}

Trust, but verify - check some data or replication status from the previous steps.
<details><summary>Solution</summary>
<br />

```plain
psql -p $PORT_RED mydb
\dt
SELECT * FROM pg_stat_wal_receiver;
```{{exec}}
</details>

(and exit `psql`)
```plain
\q
```{{exec}}
