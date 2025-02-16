#!/bin/bash
set -e # exit on error

set -a
REDIS_PASSWORD=$(cat "$REDIS_PASSWORD_FILE")
set +a

# redis-server -v
# ls /etc/redis/

# cat /etc/redis/redis.conf | head -n 200

sed -i "s/^# requirepass.*/requirepass $REDIS_PASSWORD/" \
        /etc/redis/redis.conf
sed -i 's/^bind .*/bind 0.0.0.0/' /etc/redis/redis.conf
sed -i 's/^daemonize .*/daemonize no/' /etc/redis/redis.conf

# cat /etc/redis/redis.conf | head -n 200

# redis-server --version
# redis-server --help | grep conf

# exec redis-server
echo "redis starting..."
redis-server /etc/redis/redis.conf
# tail -f
