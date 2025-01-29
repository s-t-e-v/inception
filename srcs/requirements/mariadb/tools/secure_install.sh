#!/bin/bash
mysql_secure_installation <<EOF
n
$DB_ROOT_PASSWORD
$DB_ROOT_PASSWORD
y
y
y
y
y
EOF