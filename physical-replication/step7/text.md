# Switchover - stop Old Leader

Switchover is a planned switch of the Leader to other PG instance. (In comparison to Failover, which is not planned.)<br />

Procedure
1. Start with a healthy Leader + 2 Replicas
1. Stop a Leader, let Replicas catch up
1. Choose a New Leader
1. Create replication slots on a new Leader
1. Promote a new Leader
1. Make the Old Leader + 2nd Replica follow the New Leader

Result
* Another PG instance is the Leader, 2 Replicas follow
* We didn't lose ANY data
* WAL timeline has changed


First we enter *red* Leader's container *pg_red_1*.
<details><summary>Solution</summary>
<br />
```plain
docker exec -it pg_red_1 /bin/bash
```{{exec}}
</details>

Now we stop Postgres (as user `postgres`).
<details><summary>Solution</summary>
<br />
```plain
su - postgres -c '/usr/local/bin/pg_ctl -D /var/lib/postgresql/data stop'
```{{exec}}
</details>
(exit the container)<br />
<br />

Also it would be a good idea to stop `pgbench` on the host at this point.
<details><summary>Solution</summary>
<br />
```plain
pkill pgbench
```{{exec}}
</details>

<br />