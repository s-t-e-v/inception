#!/bin/bash/
set -e # exit on error

# Generate ssl private key and contract
echo "Generating SSL certificate..."
if ! openssl req -newkey rsa:2048 -keyout ${CONF_DIR}/${FQDN}.key -x509 -days 90 -out ${CONF_DIR}/${FQDN}.crt -nodes -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42inception/CN=${FQDN}"; then
    echo "Failed to generate SSL certificate"
    exit 1
fi
chown root:root ${CONF_DIR}/${FQDN}.key
chmod 600 ${CONF_DIR}/${FQDN}.key
chmod 644 ${CONF_DIR}/${FQDN}.crt

# Generate nginx.conf from template and environment variables
if [ -z "$FQDN" ] || [ -z "$WEB_ROOT" ]; then
    echo "Environment variables FQDN and WEB_ROOT must be set"
    exit 1
fi
envsubst '$FQDN $WEB_ROOT' < "$CONF_DIR"/nginx.conf.template > "$CONF_DIR"/nginx.conf

# Validate the configuration
nginx -t

# Start nginx
exec nginx -g 'daemon off;'