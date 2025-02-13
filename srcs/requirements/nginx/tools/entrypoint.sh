#!/bin/bash
set -e # exit on error

# Generate SSL private key and contract
echo "📃  Generating SSL certificate..."

SUBJECT="/C=FR/ST=IDF/L=Paris/O=42/OU=42inception/CN=${FQDN}"

if ! openssl req -newkey rsa:2048 \
    -keyout "${CONF_DIR}/${FQDN}.key" \
    -x509 -days 90 \
    -out "${CONF_DIR}/${FQDN}.crt" \
    -nodes \
    -subj "$SUBJECT"; then
    echo "❌  Failed to generate SSL certificate"
    exit 1
fi

chmod 600 "${CONF_DIR}/${FQDN}.key"
chmod 644 "${CONF_DIR}/${FQDN}.crt"

# Validate the configuration
nginx -t

# Start nginx
exec nginx -g 'daemon off;'