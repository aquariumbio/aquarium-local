# Aquarium-Local

Docker configuration for running Aquarium with a local (non-deployment) configuration.

## Getting started

1. Clone this repository.
2. Change into directory.
3. Setup the directory

   ```bash
   bash ./setup.sh
   ```

4. Run

   ```bash
   docker-compose up --build
   ```

For future runs the command

```bash
docker-compose up
```

should be sufficient

## Changing the database

The database is initialized from the file `data/mysql_init/dump.sql` that does not exist by default.
The `setup.sh` script will copy `data/mysql_init/default.sql` to this file, if the dump file does not already exist.
