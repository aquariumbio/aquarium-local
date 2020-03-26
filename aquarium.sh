#!/bin/sh
if [ $1 = "up" ]; then
    docker-compose pull && docker-compose $@
elif [ $1 = "down" ]; then
    docker-compose $@ -v
else
    docker-compose $@
fi
