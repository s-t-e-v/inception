#!/bin/bash
set -e # Exit on error

set -a
# Detect PHP version
PHP_VERSION=$(php -v | grep -oP 'PHP \K[0-9]+\.[0-9]+')
set +a

# Create wp-config.php if it doesn't exist
if [ ! -f wp-config.php ]; then
    echo "Configuring wordpress for the first time..."
    set -a
    MYSQL_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")
    source "$WORDPRESS_CREDENTIALS_FILE"
    set +a
    wp-cli config create --allow-root \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST"

    wp-cli core install --allow-root \
        --url="$FQDN" \
        --title="$WP_BLOG_TITLE" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_MAIL"

    wp-cli user create --allow-root \
        "$WP_USER" \
        "$WP_USER_MAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author

    # Set permalink structure
    wp-cli rewrite structure '/%year%/%monthnum%/%day%/%postname%/' --allow-root
    echo "First time configuration done."
fi

# Start PHP-FPM in the foreground
echo "Starting php-fpm..."
exec php-fpm${PHP_VERSION} -F


# php-fpm${PHP_VERSION}

# sleep 4

# # SCRIPT_FILENAME=/ping.php \
# # REQUEST_METHOD=GET \
# # cgi-fcgi -bind -connect wordpress:9000 || echo "KO"

# SCRIPT_NAME=/healthcheck.php \
# SCRIPT_FILENAME=/healthcheck.php \
# QUERY_STRING=VAR1 \
# DOCUMENT_ROOT=/var/www/html/ \
# REQUEST_METHOD=GET \
# cgi-fcgi -bind -connect wordpress:9000 
# # cgi-fcgi -bind -connect wordpress:9000 | grep 'OK' || echo "KO"

# tail -f