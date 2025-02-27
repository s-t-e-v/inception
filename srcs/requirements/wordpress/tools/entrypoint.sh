#!/bin/bash
set -e # Exit on error

# Install Wordpress if wp-config.php doesn't exist
if [ ! -f wp-config.php ]; then
    echo "🏗️  Setting up Wordpress..."
    # Load credentials
    set -a
    MYSQL_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")
    source "$WORDPRESS_CREDENTIALS_FILE"
    # ---- Bonus
    REDIS_PASSWORD=$(cat "$REDIS_PASSWORD_FILE")
    MINIO_WP_PASSWORD=$(cat "$MINIO_WP_PASSWORD_FILE")
    source "$MINIO_ACCESS_KEYS_FILE"
    set +a
    # Create the wp-config.php file
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST"

    # Install Wordpress
    wp core install \
        --url="$FQDN" \
        --title="$WP_BLOG_TITLE" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_MAIL" \
        --skip-email

    # Add the wordpress user
    wp user create \
        "$WP_USER" \
        "$WP_USER_MAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author

    # Set permalink structure
    wp rewrite structure '/%year%/%monthnum%/%day%/%postname%/'

    # Disable Email Notifications for Comments
    wp option update comments_notify 0

    # Disable Email Notifications for Comment Moderation
    wp option update moderation_notify 0

    # ----- BONUS -------
    # Redis set up
    wp config set WP_REDIS_HOST "redis" --quiet
    wp config set WP_REDIS_PORT --raw "6379" --quiet
    wp config set WP_REDIS_PASSWORD "$REDIS_PASSWORD" --quiet
    wp config set WP_REDIS_MAXTTL --raw 3600 --quiet # Set the maximum TTL (time to live) for cached data in seconds
    wp config set WP_REDIS_DISABLED --raw false --quiet
    
    wp plugin install redis-cache --activate

    wp redis enable


    # Ensure AS3CF_SETTINGS is added *before* the "stop editing" line
    if grep -q "That's all, stop editing" wp-config.php; then
        sed -i "/That's all, stop editing/i\\
define( 'AS3CF_SETTINGS', serialize( array(\\
    'provider'              => 'aws',\\
    'access-key-id'         => '${MINIO_WP_ACCESS_KEY}',\\
    'secret-access-key'     => '${MINIO_WP_SECRET_KEY}',\\
    'bucket'                => 'wpbucket',\\
    'region'                => 'eu-east-1',\\
    'endpoint'              => 'http://minio:9000',\\
    'use-path-style-endpoint'=> true,\\
    'copy-to-s3'            => true,\\
    'serve-from-s3'         => true,\\
    'remove-local-file'     => true\\
) ) );\\
" wp-config.php
    fi

       # Install & Activate WP Offload Media Plugin
    wp plugin install amazon-s3-and-cloudfront --activate

    echo "Wordpress is ready!  🚀"
fi


# Start PHP-FPM in the foreground
echo "Starting php-fpm..."
exec php-fpm${PHP_VERSION} -F