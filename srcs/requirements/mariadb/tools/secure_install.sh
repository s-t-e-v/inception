#!/bin/bash

TMP_CNF=/root/.my.cnf

# Ensure the MySQL runtime directory exists and set correct permissions
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# Store root password securely in a temp config
cat > "$TMP_CNF" <<EOF
[client]
user="root"
password="${DB_ROOT_PASSWORD}"
EOF
chmod 600 "$TMP_CNF"

mysqld&

# Wait for MariaDB to be fully ready
until mysqladmin ping --silent; do
    sleep 1
done

# Secure MariaDB
mysql --defaults-file="$TMP_CNF" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';"
mysql --defaults-file="$TMP_CNF" -e "DELETE FROM mysql.user WHERE User='';"
# Disable Root Login from Remote Hosts
mysql --defaults-file="$TMP_CNF" -e "DELETE FROM mysql.user WHERE User='root' AND Host='%';"
mysql --defaults-file="$TMP_CNF" -e "DROP DATABASE IF EXISTS test;"
mysql --defaults-file="$TMP_CNF" -e "FLUSH PRIVILEGES;"

# Stop MariaDB after securing it
mysqladmin --defaults-file="$TMP_CNF" shutdown

# Remove the password file immediately after setup
rm -f "$TMP_CNF"