#!/bin/bash
set -e # exit on error

set -a
REDIS_PASSWORD=$(cat "$REDIS_PASSWORD_FILE")
set +a

sed -i "s/^requirepass.*/requirepass $REDIS_PASSWORD/" \
        /etc/redis/redis.conf


exec redis-server /etc/redis/redis.conf