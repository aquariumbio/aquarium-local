#!/bin/sh
ENV_FILE=.env

_has_variable() {
    local variable=$1
    grep -q "^$variable" $ENV_FILE
    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

_set_value() {
    local variable=$1
    local value=$2
    echo $variable=$value >> $ENV_FILE
}

_set_variable() {
    local variable=$1
    local value=$2
    _has_variable $variable
    if [ $? -gt 0 ]; then
       _set_value $variable $value
    fi
}

_set_random() {
    local variable=$1
    local length=$2
    _has_variable $variable
    if [ $? -gt 0 ]; then
        local value=`openssl rand -hex $length`
        _set_value $variable $value
    fi
}

_get_timezone() {
    if [[ -z ${timezone+x} ]]; then
        timezone=`curl https://ipapi.co/timezone` 2> /dev/null
    fi

    if [[ ${timezone} =~ 'error' ]]; then
        echo 'Error getting timezone'
        timezone='America/Los_Angeles'
        echo 'Using ${timezone}'
    fi
}

_set_timezone() {
    _has_variable 'TIMEZONE'
    if [ $? -gt 0 ]; then
        _get_timezone
        _set_variable 'TIMEZONE' $timezone
    fi
}

_setup() {
    if [ ! -f "$ENV_FILE" ]; then
        echo "Initializing configuration file"
        touch $ENV_FILE
    fi

    _set_variable 'AQUARIUM_VERSION' '2.9.0'
    _set_variable 'APP_PUBLIC_PORT' '80'
    _set_variable 'S3_PUBLIC_PORT' '9000'
    _set_variable 'DB_NAME' 'production'
    _set_variable 'DB_USER' 'aquarium'
    _set_variable 'DB_PASSWORD' 'aSecretAquarium'
    _set_variable 'S3_SERVICE' 'minio'
    _set_variable 'S3_ID' 'aquarium_minio'
    _set_variable 'S3_REGION' 'us-west-1'
    _set_variable 'TECH_DASHBOARD' 'false'
    _set_random 'S3_SECRET_ACCESS_KEY' '40'
    _set_random 'SECRET_KEY_BASE' '64'
    _set_timezone

    DB_INIT_DIR=./data/mysql_init
    DB_FILE=$DB_INIT_DIR/dump.sql
    if [ ! -f "$DB_FILE" ]; then
        cp $DB_INIT_DIR/default.sql $DB_INIT_DIR/dump.sql
    fi
}

_dump_database() {
    local user=`perl -lne '/^DB_USER=(.*)/ && print "$1"' $ENV_FILE`
    local password=`perl -lne '/^DB_PASSWORD=(.*)/ && print "$1"' $ENV_FILE`
    local database=`perl -lne '/^DB_NAME=(.*)/ && print "$1"' $ENV_FILE`
    local dump_file=${database}_dump.sql
    docker-compose exec db mysqldump -u "$user" -p"$password" $database | grep -v "mysqldump:" > $dump_file
}

if [ $# -eq 0 ]; then
    echo "Expecting arguments: up, down or valid docker-compose argument"
elif [ $1 = "up" ]; then
    _setup
    grep -q -s "Microsoft" /proc/version
    if [ $? -eq 0 ]; then
        docker-compose pull && docker-compose -f docker-compose.yml -f docker-compose.windows.yml $@
    else
        docker-compose pull && docker-compose $@
    fi
elif [ $1 = "update" ]; then
    # TODO: this should just replace anything that has been changed
    rm $ENV_FILE
    _setup
    docker-compose pull && docker-compose run --rm app $@
elif [ $1 = "dump" ]; then
    _dump_database
elif [ $1 = "down" ]; then
    docker-compose $@ -v
else
    docker-compose $@
fi
