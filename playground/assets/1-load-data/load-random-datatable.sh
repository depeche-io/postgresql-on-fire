createdb datatable

echo "create table datatable as select generate_series as rowid, random() as rand from generate_series(0, 1000000);" | psql datatable

