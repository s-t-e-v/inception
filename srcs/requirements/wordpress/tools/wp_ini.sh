#!/bin/bash
set -a
MYSQL_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")
source "$WORDPRESS_CREDENTIALS_FILE"
set +a

# TODO: remove user listing
# TODO: avoid Error displays for user creation
# FIXME: wordpress-1  | sh: 1: /usr/sbin/sendmail: not found on first wp init
wp-cli config create --allow-root --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --dbhost="$WORDPRESS_DB_HOST"
wp-cli core install --allow-root --url="$FQDN" --title="$WP_BLOG_TITLE" --admin_user="$WP_ADMIN" --admin_password="$WP_ADMIN_PASSWORD" --admin_email="$WP_ADMIN_MAIL"
wp-cli user create --allow-root "$WP_USER" "$WP_USER_MAIL" --user_pass="$WP_USER_PASSWORD" --role=author
# wp-cli user list --allow-root

# tail -f
# Start PHP-FPM in the foreground
exec php-fpm8.3 -F
# exec php-fpm -F