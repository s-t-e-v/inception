#!/bin/bash
set -e # exit on error

# Generate nginx.conf from template and environment variables
envsubst '$FQDN $WEB_ROOT' < "$CONF_DIR"/"$CONF_TEMPLATE" > "$CONF_DIR"/nginx.conf

# Validate the configuration
nginx -t

# Start nginx
exec nginx -g 'daemon off;'