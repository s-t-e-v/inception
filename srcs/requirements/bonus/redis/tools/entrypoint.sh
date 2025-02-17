#!/bin/bash
set -e # exit on error

set -a
REDIS_PASSWORD=$(cat "$REDIS_PASSWORD_FILE")
set +a

# Tweak Redis configuration
echo "requirepass $REDIS_PASSWORD" >> /etc/redis/redis.conf
echo "bind 0.0.0.0" >> /etc/redis/redis.conf
echo "daemonize no" >> /etc/redis/redis.conf

echo "redis starting..."
exec redis-server /etc/redis/redis.conf