#!/bin/bash
mysql -u root -p "" <<EOF
-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';

-- Remove anonymous users
DELETE FROM mysql.user WHERE User='';

-- Disallow remote root login
UPDATE mysql.user SET Host='localhost' WHERE User='root';

-- Remove test database
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

-- Reload privilege tables
FLUSH PRIVILEGES;
EOF

mysql -u root -p "${DB_ROOT_PASSWORD}" <<EOF
SHOW DATABASES;
EOF