# Understanding status from Leader

Connect to *red* Leader.

<details><summary>Solution</summary>
<br />
```plain
psql -p $PORT_RED
```{{exec}}
</details>

Few `psql` [tricks](https://www.crunchydata.com/blog/magic-tricks-for-postgres-psql-settings-presets-cho-and-saved-queries):
* \x auto # toggle the view if needed - larger records are more readable in console
* \watch 1 # can be added after any command basically to run the line in the loop every 1s, very useful for inspecting changing state

It's very useful to see some load being constantly generated to simulate traffic to the cluster.
If you are not running `pgbench` in a separated tab from the previous steps, it would be useful to do it now:

<details><summary>Solution</summary>
<br />
```plain
pgbench -d mydb -i -P1 -j 1 -T 3600
```{{exec}}
</details>

First of all, each cluster gets a unique identifier on creation called `Database System Identifier`.
<details><summary>Solution</summary>
<br />
```plain
SELECT system_identifier FROM pg_control_system();
```{{exec}}
</details>

A central concept to the replication is the [Write Ahead Log (WAL)](https://www.interdb.jp/pg/pgsql09/01.html) and [Log Sequence Number (LSN)](https://www.interdb.jp/pg/pgsql09/06.html).

You can easily access current LSN record and writing position.
<details><summary>Solution</summary>
<br />
```plain
SELECT pg_current_wal_lsn(), pg_current_wal_insert_lsn();
```{{exec}}
</details>

LSN is also a pg_lsn record type, which makes it available for calculation. For example you can get the total number of bytes writen since the cluster creation or see a difference in two LSN point in bytes.
<details><summary>Solution</summary>
<br />
```plain
SELECT pg_current_wal_lsn() - '0/0';
SELECT '0/C6F54810'::pg_lsn - '0/BCD270D0'::pg_lsn;
```{{exec}}
</details>


For tracking logical drifts in the WAL, there is also [timelineID](https://www.interdb.jp/pg/pgsql10/03.html). This is in simple terms incremented with every recovery event to distinguish another leader being promoted. Now let's inspect our current timelineID
<details><summary>Solution</summary>
<br />
```plain
SELECT timeline_id FROM pg_control_checkpoint();
```{{exec}}
</details>

TimelineID and LSN position together form a WAL file name.
<details><summary>Solution</summary>
<br />
```plain
SELECT pg_walfile_name(pg_current_wal_lsn());
```{{exec}}
</details>

The broadest info probably can be seen from the last checkpoint - to understand current Leader's state.
<details><summary>Solution</summary>
<br />
```plain
SELECT * FROM pg_control_checkpoint();
```{{exec}}
</details>

How to tell that we are on the Leader or not? (Not being in a recovery means we are on a Leader.)
<details><summary>Solution</summary>
<br />
```plain
SELECT pg_is_in_recovery();
```{{exec}}
</details>

Now let's inspect the replication slots to how the replicas are doing.
<details><summary>Solution</summary>
<br />
```plain
SELECT * FROM pg_replication_slots;
```{{exec}}
</details>

You can also see the latest data from the replica's view on the Leader.
<details><summary>Solution</summary>
<br />
```plain
SELECT * FROM pg_stat_replication;
```{{exec}}
</details>
(exit from `psql`)

Also there is a `walsender` process for each Replica running which you can see with simple Linux OS tools in the *pg_red_1* container.
<details><summary>Solution</summary>
<br />
```plain
docker exec -it pg_red_1 /bin/bash
ps uax | grep walsender
```{{exec}}
</details>

<br />