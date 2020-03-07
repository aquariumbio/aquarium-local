# Aquarium-Local

Docker configuration for running Aquarium with a local (non-deployment) configuration.

This configuration is intended to support protocol development or evaluation, and supports all Aquarium services except for email notifications.

## Getting started

1. Install [Docker](https://www.docker.com/get-started) on your computer.
2. Clone this repository

   ```bash
   git clone https://github.com/klavinslab/aquarium-local.git
   ```

3. Change into directory

   ```bash
   cd aquarium-local
   ```

4. Setup the directory

   ```bash
   bash ./setup.sh
   ```

5. Run

   ```bash
   docker-compose up --build
   ```

   For future runs the command

   ```bash
   docker-compose up
   ```

   should be sufficient
   
## Udating the Docker image
To update the Docker image with the latest version, run
```bash
docker-compose down
docker-compose pull app
docker-compose up
```

## Changing the database

The database is initialized from the file `data/mysql_init/dump.sql` that does not exist by default.
The `setup.sh` script will copy `data/mysql_init/default.sql` to this file, if the dump file does not already exist.

If you want a new `dump.sql` file to be loaded, your need to remove the database files with the command

   ```bash
   rm -rf data/db/*
   ```

before running `docker-compose up`.
Depending on the size of the database dump, the first run may be slower.

If you need to change the database frequently, for example while testing code, you can use [this script](https://github.com/dvnstrcklnd/aq-hot-swap-db).
