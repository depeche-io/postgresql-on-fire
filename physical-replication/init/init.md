<br>

You are currently in an empty environment that we will install in the next steps. <br />
This scenario covers manual PostgreSQL cluster creation and basic High-Availability (H-A) practises.

Scenarios are constructed step-by-step with a correct answer hidden at first, so you can either try yourself or get help if needed.<br />

 <br />

There are 3 PG containers controlled via /ks/pg/docker-compose.yaml <br />
*red*
* port $PORT_RED = 6432 -> 5432
* datadir /mnt/red
```plain
docker exec -it pg_red_1 /bin/bash
```{{exec}}

*green*
* port $PORT_GREEN = 7432 -> 5432
* datadir /mnt/green
```plain
docker exec -it pg_green_1 /bin/bash
```{{exec}}

*blue*
* port $PORT_BLUE = 8432 -> 5432
* datadir /mnt/blue
```plain
docker exec -it pg_blue_1 /bin/bash
```{{exec}}

Also, there is a PgAdmin4, if you like:
* Check out Menu (next to time, upper right corner) -> Ports to access port 80
* postgres@killercoda.sh / postgres

(setup connection to `red` (leader), `green` or `blue` host, credentials will be set upon cluster creation) <br />
(takes ~4 mins to start, be patient or use `psql`)<br />

<br />

You can also follow my [presentation for P2D2 2025](https://docs.google.com/presentation/d/1pm-GaYRyMo3v0CtgrKTGPHRCnf30ki3lGc4tPOPSnmg/edit?usp=sharing).
