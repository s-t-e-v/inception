#!/bin/bash
set -e  # Exit if any command fails

REDIS_PASSWORD=$(cat $REDIS_PASSWORD_FILE)

redis-cli -a "$REDIS_PASSWORD" ping | grep "PONG" || exit 1
