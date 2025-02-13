#!/bin/bash
set -e # Exit on error

# Retrieve environment variables from build time
source /etc/environment

# Install Wordpress if wp-config.php doesn't exist
if [ ! -f wp-config.php ]; then
    echo "🏗️  Setting up Wordpress..."
    # Load credentials
    set -a
    MYSQL_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")
    source "$WORDPRESS_CREDENTIALS_FILE"
    set +a
    # Create the wp-config.php file
    wp-cli config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST"

    # Install Wordpress
    wp-cli core install \
        --url="$FQDN" \
        --title="$WP_BLOG_TITLE" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_MAIL"

    # Add the wordpress user
    wp-cli user create \
        "$WP_USER" \
        "$WP_USER_MAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author

    # Set permalink structure
    wp-cli rewrite structure '/%year%/%monthnum%/%day%/%postname%/'
    echo "Wordpress is ready!  🚀"
fi

# Start PHP-FPM in the foreground
echo "Starting php-fpm..."
exec php-fpm${PHP_VERSION} -F