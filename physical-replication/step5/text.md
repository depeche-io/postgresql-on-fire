Now let's inspect replica. It doesn't matter which of them, both are equal.

<details><summary>Solution</summary>
<br />

```plain
psql -p $PORT_GREEN
```{{exec}}
</details>

We don't have some of the previous Leader's functions available.
<details><summary>Solution</summary>
<br />

```plain
SELECT pg_current_wal_lsn();
SELECT pg_current_wal_insert_lsn();
```{{exec}}
</details>

Replica is "in recovery" in the PG terminology.
<details><summary>Solution</summary>
<br />

```plain
SELECT pg_is_in_recovery();
```{{exec}}
</details>

We can also see a current status.
<details><summary>Solution</summary>
<br />

```plain
SELECT * FROM pg_stat_wal_receiver;
```{{exec}}
</details>

There are [4 different LSNs](https://www.cybertec-postgresql.com/en/monitoring-replication-pg_stat_replication/) in fact:
* `sent_lsn`: How much WAL has been sent over the network already?
* `write_lsn`: How much WAL has been sent to the operating system? (without flushing)
* `flush_lsn`: How much WAL has been flushed to disk already?
* `replay_lsn`: How much WAL has been replayed and is therefore visible to queries?

Probably the most important one will be `flush_lsn`, since this means that you should not lose the data. Or maybe the `replay_lsn` if for example you are checking from your application, if some transactions are available from the Leader or not. (There are also ther means how to do this.)

(exit from `psql`)

Also there is a `walreceiver` process in the Replica's OS.
<details><summary>Solution</summary>
<br />

```plain
docker exec -it pg_green_1 /bin/bash
ps uax | grep walreceiver
```{{exec}}
</details>

<br />