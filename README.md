# Aquarium-Local

Docker configuration for running Aquarium with a local (non-deployment) configuration.

This configuration is intended to support protocol development or evaluation, and supports all Aquarium services except for email notifications.

## Quick Start

1. Install [Docker](https://www.docker.com/get-started) on your computer.

2. Clone this repository

   ```bash
   git clone https://github.com/klavinslab/aquarium-local.git
   ```

3. Change into directory

   ```bash
   cd aquarium-local
   ```

4. Run

   ```bash
   chmod u+x aquarium.sh
   ./aquarium.sh up
   ```

   to run Aquarium.

   You wont need to change the permissions with `chmod` each time.

5. To stop Aquarium, run

   ```bash
   ./aquarium.sh down
   ```

## [Documentation](http://klavinslab.org/aquarium-local/)

