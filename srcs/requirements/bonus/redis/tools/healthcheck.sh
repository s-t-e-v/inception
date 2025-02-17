#!/bin/bash
set -e  # Exit if any command fails

REDIS_PASSWORD=$(cat $REDIS_PASSWORD_FILE)

if redis-cli -a "$REDIS_PASSWORD" ping | grep -q "PONG"; then
  exit 0
else
  exit 1
fi