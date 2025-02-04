*green* is the Leader, *red* and *blue* are the replicas. Manual failover is very similar to a switchover with one very crucial difference - you need to make absolutely sure, that the Old Leader can't start again. More precisely - that the Old Leader won't get any writes. <br />

Procedure
1. Start with 1 Leader (DEAD !) + healthy 2 Replicas
1. (!!!) Make sure Old Leader can't start
1. Choose the most advanced (?) Replica as a New Leader
1. Create a replication slot for Replica on a New Leader
1. Promote chosen Replica to a new Leader
1. Make 2nd Replica follow a new Leader
1. Make old Leader follow a new Leader BEFORE it starts (it MUST NOT get any writes)

Result
* Another PG instance is the Leader, 1 Replica follow
* Minimal data loss
* WAL timeline has changed
* Leader is fenced, Old Leader can be turned to Replica (no split-brain) without reinit

<br />

The "Old Leader can't start" guarantee is very technology specific ranging from taking it off the physical network up to masking the service in systemd etc. So we'll showcase just a simple situation that the whole replication will smoothly continue after the Leader is unavailable for a while.<br />

Enter the *green* container *pg_green_1*.
<details><summary>Solution</summary>
<br />

```plain
docker exec -it pg_green_1 /bin/bash
```{{exec}}
</details>

And stop Postgres (as user `postgres`).
<details><summary>Solution</summary>
<br />

```plain
su - postgres -c '/usr/local/bin/pg_ctl -D /var/lib/postgresql/data stop'
```{{exec}}
</details>

Now you can wait a bit and check replication status on any of the Replicas (in other Tab).
<details><summary>Solution</summary>
<br />

```plain
psql -h red -c 'SELECT * FROM pg_stat_wal_receiver;'
```{{exec}}
</details>

Start Postgres again (as user `postgres`)

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

And after few seconds, you should see the process working again.
<details><summary>Solution</summary>
<br />

```plain
psql -p $PORT_RED -c 'SELECT * FROM pg_stat_wal_receiver;'
```{{exec}}
</details>
