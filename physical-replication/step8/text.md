# Switchover - choose and promote New Leader

Now we are in a situation that the *red* Leader is stopped and we have two Replicas running. We can assume that they are both healthy and we can promote any of them to become a new Leader, let's say *green*. We can do this online just with `psql`. We should also create replication slots before the promotion, just to make sure that we won't lose any WAL data in the process.

<details><summary>Solution</summary>
<br />
```plain
psql -p $PORT_GREEN
SELECT pg_create_physical_replication_slot('red');
SELECT pg_create_physical_replication_slot('blue');
SELECT pg_promote();
```{{exec}}
</details>

And that's basically it. If clients connect to this PG instance, they are able to continue write transactions.<br />
We can now start `pgbench` against *green* to simulate some workload (in a new Tab).

<details><summary>Solution</summary>
<br />
```plain
pgbench -d mydb -p $PORT_GREEN -P1 -j 1 -T 3600
```{{exec}}
</details>

<br />