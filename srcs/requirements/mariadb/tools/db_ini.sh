#!/bin/bash
set -e # Exit on error

# CREDENTIALS
DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# Ensure the MySQL runtime directory exists and set correct permissions
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

INIT_DB=/run/mysqld/init.sql

# Build initialization script
cat > "$INIT_DB" <<EOF
-- Secure initialization
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
ALTER USER 'mysql'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host='%';
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
EOF

# Initialize MariaDB with the SQL file
mysqld --socket=/run/mysqld/mysqld.sock --init-file="$INIT_DB"

# Cleanup
rm -f "$INIT_DB"

# Start mysqld daemon as mysql user
exec mysqld