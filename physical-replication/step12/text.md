*green* is the Leader, <span style='color:red'>red</span> and *blue* are the replicas. In the previous steps, the Old Leader never got any new writes after New Leader was promoted. So in these scenarios it's safe to switch Old Leader to Replica. However this is not always the case. Let's now simulate the worst possible scenario `split-brain`.<br />

We just promote one the Replicas and do few writes there. To hold this scenario, we should have `pgbench` running against *green* Leader, so the WAL files indeed diverge.<br />

Let's promote *blue*.
<details><summary>Solution</summary>
<br />

```plain
psql -p $PORT_BLUE mydb
SELECT pg_promote();
```{{exec}}
</details>

And also do some writes there to simulate the diverging WAL.
<details><summary>Solution</summary>
<br />

```plain
CREATE TABLE datatable AS SELECT generate_series AS rowid, random() as rand from generate_series(0, 1000000);"
```{{exec}}
</details>
(exit `psql`)

Now we are in the situation where *green* is the Leader with <span style='color:red'>red</span> Replica following. And there is a completely separate PG cluster with *blue* Leader2 that currently don't share the writes. You can for example see that <span style='color:red'>red</span> don't have a table created for *blue*.
<details><summary>Solution</summary>
<br />

```plain
psql -p $PORT_RED mydb
SELECT * FROM datatable;
```{{exec}}
</details>
(exit `psql`)<br />

<br />

Split-brain scenario is never beneficial, we should act fast and stop problematic *blue* Leader2. It's much better if some applications fails to connection instead of silently writing to a diffent cluster (because there is no tool to resolve the conflicts later on).

Stop *blue* Postgres (as user `postgres`)
<details><summary>Solution</summary>
<br />

```plain
docker exec -it pg_blue_1 /bin/bash
su - postgres -c '/usr/local/bin/pg_ctl -D /var/lib/postgresql/data stop'
```{{exec}}
</details>

We can also inspect PG datata via [pg_controldata](https://www.postgresql.org/docs/current/app-pgcontroldata.html) CLI tool to get a lot of details even when the PG is not started.
<details><summary>Solution</summary>
<br />

```plain
pg_controldata -D /var/lib/postgresql/data
```{{exec}}
</details>
(exit the container)

We can compare it *green* Leader's data to confirm the divergence.
<details><summary>Solution</summary>
<br />

```plain
psql -p $PORT_GREEN -c 'SELECT * FROM pg_control_checkpoint();'
```{{exec}}
</details>

<br />