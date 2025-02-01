#!/bin/bash

pgbench -d mydb -i
pgbench -d mydb -P1 -j 10 -T 10