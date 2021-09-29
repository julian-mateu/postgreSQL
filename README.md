# postgreSQL

Creates and configures a [postgreSQL DB docker image](https://hub.docker.com/_/postgres) using [docker compose](https://docs.docker.com/compose/)

## Getting started

Just run the script without args to create the container:
```bash
./run.sh
```

or run with the `-i` flag and provide a service name to create default tables and user:
```bash
./run.sh -i myService
```

