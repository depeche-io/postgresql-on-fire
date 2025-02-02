One important aspect of `streaming physical replication` are [replication conflicts](https://www.cybertec-postgresql.com/en/streaming-replication-conflicts-in-postgresql/). Let's connect to any of the Replicas `mydb` and simulate one type of them. (For this you really need to have `pgbench` running from the previous steps, otherwise a conflict won't happen if there are no new data on the Leader.)

<details><summary>Solution</summary>
<br />

```plain
psql -p $PORT_GREEN mydb
```{{exec}}
</details>

We can set `max_standby_streaming_delay` to some very small value.
<details><summary>Solution</summary>
<br />

```plain
ALTER SYSTEM SET max_standby_streaming_delay TO '100ms';
SELECT pg_reload_conf();
```{{exec}}
</details>

Now we execute any query over data taking longer than 100ms.
<details><summary>Solution</summary>
<br />

```plain
BEGIN; SELECT * FROM pgbench_accounts ORDER BY random(), random(), random();
```{{exec}}
</details>

We should see an error and our transaction will be terminated. In fact we have just created 100ms difference between `flush_lsn` and `replay_lsn` (because our query for was blocking WAL replaying for 100ms).

We should not revert the config changes so they don't shoot us in a foot later on.
<details><summary>Solution</summary>
<br />

```plain
ALTER SYSTEM SET max_standby_streaming_delay TO '30s';
SELECT pg_reload_conf();
```{{exec}}
</details>

(exit from `psql`)

```plain
\q
```{{exec}}
