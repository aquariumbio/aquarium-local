# Running Aquarium Locally

[Aquarium](aquarium.bio) is a whole lab automation system integrating inventory, workflow and data management for improved efficiency and reproducibility.

Aquarium is available as a Docker image that can be configured for different deployments.
This repository provides a configuration that allows running Aquarium on a single computer such as a laptop, and these instructions are focused on managing a local instance for protocol development.
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
    On WSL (on Windows) the address will be `192.168.99.100` instead of `localhost`.

    When started using the default database, aquarium has a single user with login `neptune` and password `aquarium`.

## Stopping Aquarium in Docker

To halt the Aquarium services, first type `ctrl-c` in the terminal to stop the running containers, then remove the containers by running

```bash
./aquarium.sh down
```

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

## When things go wrong

Should you encounter an error, there are a couple of things you can do while Aquarium is still running to collect information that may help us understand what is going on.

1. share any error output in the terminal where you started Aquarium.

2. run

   ```shell
   ./aquarium.sh ps
   ```

   and let us know what you see.

   This command will help us see whether any of the services used by Aquarium have crashed.
   It should look like this, with all services other than the `createbucket` service in the `Up` state.

   ```shell
   Name                           Command               State                      Ports                   
   --------------------------------------------------------------------------------------------------------------------
   aquarium-local_app_1            /aquarium/entrypoint.sh pr ...   Up       3000/tcp                                  
   aquarium-local_createbucket_1   /bin/sh -c  while ! nc -z  ...   Exit 0                                             
   aquarium-local_db_1             docker-entrypoint.sh mysqld      Up       3306/tcp, 33060/tcp                       
   aquarium-local_krill_1          /aquarium/entrypoint.sh kr ...   Up       3500/tcp                                  
   aquarium-local_s3_1             /usr/bin/docker-entrypoint ...   Up       9000/tcp                                  
   aquarium-local_web_1            /docker-entrypoint.sh ngin ...   Up       0.0.0.0:80->80/tcp, 0.0.0.0:9000->9000/tcp
   ```

   We are looking for any services other than `createbucket` that have exited.

   > Note: If you named the directory for the repository something other than `aquarium-local` that name will appear at the front of the service names.)

3. run

   ```shell
   ./aquarium.sh logs > aquarium-error-logs.txt
   ```

4. make an [issue](https://github.com/aquariumbio/aquarium-local/issues) and include the information you've gathered.

   > Logs may have information you don't want public. So be careful if you post this file in a github issue