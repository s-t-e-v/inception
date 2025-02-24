#!/bin/bash
set -e  # Exit on error

# Define certificate details
CERT_DETAILS=(
    # "<subject> <domain_name"
    "/C=FR/ST=IDF/L=Paris/O=42/OU=42inception/CN=${FQDN} ${FQDN}"
    # -- Bonus
    "/C=FR/ST=IDF/L=Paris/O=42/OU=42inception/CN=${STATIC_WEBSITE_FQDN} ${STATIC_WEBSITE_FQDN}"
)

# Function to generate one SSL certificate
generate_ssl_cert() {
    local subject="$1"
    local fqdn="$2"

    echo "📃 Generating SSL certificate for ${fqdn}..."
    
    openssl req -newkey rsa:2048 \
        -keyout "${KEYS_DIR}/${fqdn}.key" \
        -x509 -days 90 \
        -out "${CERTS_DIR}/${fqdn}.crt" \
        -nodes \
        -subj "$subject"

    chmod 600 "${KEYS_DIR}/${fqdn}.key"
    chmod 644 "${CERTS_DIR}/${fqdn}.crt"

    echo "✅ SSL certificate generated for ${fqdn}"
}

# Function to generate multiple SSL certificates
generate_all_certs() {
    for details in "${CERT_DETAILS[@]}"; do
        generate_ssl_cert $details
    done
}

# Main function
main() {
    generate_all_certs

    # Validate the Nginx configuration
    echo "🔍 Validating Nginx configuration..."
    nginx -t

    # Start Nginx
    echo "🚀 Starting Nginx..."
    exec nginx -g 'daemon off;'
}

main  # Run the script
