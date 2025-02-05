#!/bin/bash

# Make sure that NOBODY can access the server without a password
mysql -u root -p -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"
# Kill the anonymous users
mysql -u root -p"${DB_ROOT_PASSWORD}" -e "DROP USER ''@'localhost'"
# Because our hostname varies we'll use some Bash magic here.
mysql -u root -p"${DB_ROOT_PASSWORD}" -e "DROP USER ''@'$(hostname)'"
# Kill off the demo database
mysql -u root -p"${DB_ROOT_PASSWORD}" -e "DROP DATABASE test"
# Make our changes take effect
mysql -u root -p"${DB_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES"
# Any subsequent tries to run queries this way will get access denied because lack of usr/pwd param
