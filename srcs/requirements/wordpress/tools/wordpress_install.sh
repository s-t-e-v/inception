#!/bin/bash
set -e # Exit on error

# -- Download Wordpress
wp core download --version=${WP_VERSION}

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