#!/bin/bash
set -a
MYSQL_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")
source "$WORDPRESS_CREDENTIALS_FILE"
set +a

# echo $WP_ADMIN | cat -e
# echo $WP_ADMIN_MAIL | cat -e
# echo "$WP_ADMIN_PASSWORD" | cat -e
# echo $WP_USER | cat -e
# echo $WP_USER_MAIL | cat -e
# echo "$WP_USER_PASSWORD" | cat -e

sleep 10
wp-cli config create --allow-root --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --dbhost="$WORDPRESS_DB_HOST" --locale="en_DB" 
wp-cli core install --allow-root --url="$FQDN" --title="$WP_BLOG_TITLE" --admin_user="$WP_ADMIN" --admin_password="$WP_ADMIN_PASSWORD" --admin_email="$WP_ADMIN_MAIL"
wp-cli user create --allow-root "$WP_USER" "$WP_USER_MAIL" --user_pass="$WP_USER_PASSWORD" --role=author
wp-cli user list --allow-root

tail -f