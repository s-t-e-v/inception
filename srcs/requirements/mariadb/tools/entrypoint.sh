#!/bin/bash
set -e # Exit on error

# CREDENTIALS
MYSQL_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")
MYSQL_ROOT_PASSWORD=$(cat "$MYSQL_ROOT_PASSWORD_FILE")

# Start MySQL temporarily
mysqld&

# Wait for MariaDB to be fully ready
until mysqladmin ping --silent; do
    sleep 1
done

# Secure and configure MariaDB
mysql <<EOF
-- Secure initialization
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host='%';
DROP DATABASE IF EXISTS test;
-- Wordpress setup
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
-- Update privileges
FLUSH PRIVILEGES;
EOF

# Stop MariaDB after configuration
mysqladmin shutdown

# Start MariaDB normally in the foreground
exec mysqld