FILE=/ks/wait-background.sh; while ! test -f ${FILE}; do clear; sleep 0.1; done; bash ${FILE}

#mkdir -p /root/profiles
#mv /tmp/demo*.yaml /root/profiles/

ssh node01  <<EOF
# scenario 1:
#dd if=/dev/zero of="/var/lib/postgresql/16/some-file.bin" bs=1M

# scenario 2:
# replication slot

# scenario 3:
# archive command

# scenario 4
# large table -> delete except last data
https://www.cybertec-postgresql.com/en/vacuum-does-not-shrink-my-postgresql-table/
+ pg_partman



Graceful restart

there is some heavy write operations, restart the postgres, so the downtime is minimal as possible
every 15s, there is a heavy... 
date 

UPDATE larger table, update again, rollback, again


Problem killing postgres
too large work_mem -> ?? or limit the process mem?


Transacation ID wrap-around
https://www.cybertec-postgresql.com/en/transaction-id-wraparound-a-walk-on-the-wild-side/


Can't insert data to a table
https://www.cybertec-postgresql.com/en/error-nextval-reached-maximum-value-of-sequence/

Basic slow queries
# large sort, small work-mem

# missing JSON index (GIN)

# funkce nad atributem

# stored procedure for insert



Traffic problems

+ pg_stat_statments
kill client + limit his connections
limit to 0.5 CPU

Long transaction with lock blocks others

Slow analytical query kill the performance

autovacuum lock


2 conflicting apps dead-locking
https://www.cybertec-postgresql.com/en/debugging-deadlocks-in-postgresql/

- invalid index - (set invalid in a catalogue)
https://www.cybertec-postgresql.com/en/postgresql-the-power-of-a-single-missing-index/

TMP FILES

https://www.cybertec-postgresql.com/en/postgresql-detecting-slow-queries-quickly/

max connections -> limit


2 PGs

Primary + replica
replica lost LSN




https://www.cybertec-postgresql.com/en/monitoring-postgresql-replication/
Primary + repliac
- large replication lag


2 PGs
There has been a change in Postgres+pgbouncer. restart the primary, so the read clients are not affected at all
(RELOAD pgbouncer)

Provision a read replica

Do a switchover with minimal disruption



Near zero downtime
2 PGs, 15 + 16 + pgbouncer
do an upgrade with new zero downtime.


Recovery

pg_basebackup
wal archive

delete, recover before it

(pg_rewind vs. restore backup)


just recovery?
https://www.cybertec-postgresql.com/en/kill-9-explained-postgresql/



Corruption

your postgresql is sick! Fix it.

select, where it show a stats corruption
analyze;


corrupted index
amtool
reindex

corrupted data
-> checksums
clone fs...
https://www.cybertec-postgresql.com/en/how-to-corrupt-your-postgresql-database/


WAL corruption?
https://www.cybertec-postgresql.com/en/pg_resetwal-when-to-reset-the-wal-in-postgresql/

mention: https://www.cybertec-postgresql.com/en/icu-collations-against-postgresql-data-corruption/


EOF

clear
echo "YOU ARE READY TO GO!"