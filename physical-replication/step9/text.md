Now *red* Old Leader is stopped, *green* New Leader is running and we should make the *blue* Replica follow a *green* New Leader. This can be done online via `psql` simple configuration change.

<details><summary>Solution</summary>
<br />

```plain
psql -p $PORT_BLUE
ALTER SYSTEM SET primary_conninfo = 'user=postgres passfile=''/root/.pgpass'' channel_binding=prefer host=''green'' port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable';
SELECT pg_reload_conf();
CHECKPOINT;
```{{exec}}
</details>
(We assume that the replication slot name is unchanged.)<br />

(exit `psql`)
```plain
\q
```{{exec}}
