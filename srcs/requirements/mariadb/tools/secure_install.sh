#!/bin/bash

# Store root password securely in a temp config
cat > /root/.my.cnf <<EOF
[client]
user="root"
password="$(cat /run/secrets/db_root_password)"
EOF
chmod 600 /root/.my.cnf

exec mysqld_safe --skip-networking&

# Wait for MariaDB to be fully ready
until mysqladmin ping --silent; do
    sleep 1
done

# Secure MariaDB
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
mysql --defaults-file=/root/.my.cnf -e "ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('${DB_ROOT_PASSWORD}');"
mysql --defaults-file=/root/.my.cnf -e "DELETE FROM mysql.user WHERE User='';"
mysql --defaults-file=/root/.my.cnf -e "DROP DATABASE IF EXISTS test;"
mysql --defaults-file=/root/.my.cnf -e "FLUSH PRIVILEGES;"

# Stop MariaDB after securing it
mysqladmin --defaults-file=/root/.my.cnf shutdown

# Remove password file for security
rm -f /root/.my.cnf