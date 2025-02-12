#!/bin/bash
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
mysqladmin ping -h 127.0.0.1 -u root --password="$MYSQL_ROOT_PASSWORD"