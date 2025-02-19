#!/bin/bash
set -e # exit on error

set -a
VSTFP_PASSWORD=$(cat "${VSTFP_PASSWORD_FILE}")
set +a

LOGIN_FILE=/etc/vsftpd/login.txt

# Set login.txt file
echo "$LOGIN" > "$LOGIN_FILE"
echo "$VSTFP_PASSWORD" >> "$LOGIN_FILE"
echo "" >> "$LOGIN_FILE"

cd /etc/vsftpd
txt2db.sh login.txt login.db
cleanconf.sh
cd /

echo "Starting vsftpd..."
exec vsftpd /etc/vsftpd/vsftpd.conf
