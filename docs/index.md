# Running Aquarium Locally

[Aquarium](aquarium.bio) is a whole lab automation system integrating inventory, workflow and data management for improved efficiency and reproducibility.

Aquarium is available as a Docker image that can be configured for different deployments.
This repo provides a configuration that allows running Aquarium on a single computer such as a laptop, and these instructions are focused on managing a local instance for protocol development.
See the [Aquarium](aquarium.bio) site for guidance for production deployments.

## Running Aquarium with Docker

To run Aquarium in production with Docker on your computer:

1.  Install [Docker](https://www.docker.com/get-started) on your computer.

2.  Get this repository

    ```bash
    git clone https://github.com/klavinslab/aquarium-local.git
    ```

3.  Change into the `aquarium-local` directory

    ```bash
    cd aquarium-local
    ```

4.  Start Aquarium by running the command

    ```bash
    chmod u+x aquarium.sh
    ./aquarium.sh up
    ```

    Note:
    - You wont need to change the permissions with `chmod` each time.
    - The first run initializes the database, and so will be slower than subsequent runs.
      This can take longer than you think is reasonable, but let it finish unmolested.

5.  Once all of the services for Aquarium have started, visit `localhost` with the Chrome browser to find the Aquarium login page.

    When started using the default database, aquarium has a single user with login `neptune` and password `aquarium`.


## Stopping Aquarium in Docker

To halt the Aquarium services, first type `ctrl-c` in the terminal to stop the running containers, then remove the containers by running

```bash
./aquarium.sh down -v
```

## Running on Windows

**this needs to be updated**

On Windows, use the following in place of `docker-compose` 

```bash
docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.windows.yml
```

When running Aquarium inside the Docker toolbox VM, the address will be `192.168.99.100` instead of `localhost`.

## Updating/Migrating Aquarium

The `aquarium.sh` script will pull updates within a version of Aquarium, however, when a new version of Aquarium is released you will need to run the command

```bash
git pull
```

which will update the configuration files.

If there are any necessary `rake` tasks (see the release notes of the new version) run

```bash
docker-compose up -d
docker-compose exec app /bin/sh

```

followed by the rake task. 
For instance, to run a database migration, you would run the command

```bash
RAILS_ENV=production rake db:migrate 
```

After you've run all of the rake tasks, exit from the connection and shutdown Aquarium with

```bash
exit
docker-compose down
```

And, finally, restart Aquarium with `./aquarium.sh up` as before.

## Changing the Database

Aquarium database files are stored in `data/db`, which allows the database to persist between runs.
If this directory is empty, such as the first time Aquarium is run, the database is initialized from the database dump `data/mysql_init/dump.sql`.
The `aquarium.sh` script will copy `data/mysql_init/default.sql` to this file, if the dump file does not already exist.

You can use a different database dump by renaming it to this file with

```bash
mv data/mysql_init/dump.sql data/mysql_init/dump-backup.sql
mv my_dump.sql data/mysql_init/dump.sql
```

then removing the contents of the `data/db` directory

```bash
rm -rf data/db/*
```

and finally restarting Aquarium with `./aquarium.sh up` as before.
If Aquarium has been updated since the database dump was generated, it is a good idea to run database migrations as described above.

> **Important**: If you swap in a large database dump, the database has to be reinitialized.
> And the larger the database, the longer the initialization will take.
> _Let the initialization finish._

If you need to change the database frequently, for example while testing code, you can use [this script](https://github.com/dvnstrcklnd/aq-hot-swap-db).