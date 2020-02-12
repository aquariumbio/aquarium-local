#!/bin/bash
key_base=`openssl rand -hex 64`
s3_key=`openssl rand -hex 40`
ENV_FILE=.env

if [[ ! -f "$ENV_FILE" ]]; then
    echo 'DB_NAME=production' >> $ENV_FILE 
    echo 'DB_USER=aquarium' >> $ENV_FILE
    echo 'DB_PASSWORD=aSecretAquarium' >> $ENV_FILE
    echo 'S3_SERVICE=minio' >> $ENV_FILE
    echo 'S3_ID=aquarium_minio' >> $ENV_FILE
    echo 'S3_SECRET_ACCESS_KEY='$s3_key >> $ENV_FILE
    echo 'TIMEZONE=America/Los_Angeles' >> $ENV_FILE
    echo 'SECRET_KEY_BASE='$key_base >> $ENV_FILE 
fi