#!/bin/sh
if [ $1 = "up" ]
    docker-compose pull && docker-compose $@
elif [ $1 = "down" ]
    docker-compose $@ -v
else
    docker-compose $@
fi
