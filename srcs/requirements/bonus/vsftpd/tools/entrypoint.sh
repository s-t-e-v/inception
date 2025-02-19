#!/bin/bash
set -e # exit on error

set -a
VSFTPD_PASSWORD=$(cat "${VSFTPD_PASSWORD_FILE}")
set +a

VSFTPD_USER="$LOGIN"
LOGIN_FILE=/etc/vsftpd/login.txt

# Set login.txt file
echo "$VSFTPD_USER" > "$LOGIN_FILE"
echo "$VSFTPD_PASSWORD" >> "$LOGIN_FILE"
echo "" >> "$LOGIN_FILE"


cd /etc/vsftpd
txt2db.sh login.txt login.db
cleanconf.sh
cd /

echo "local_root=/var/www" > /etc/vsftpd/vsftpd_user_conf/"$VSFTPD_USER"
echo "write_enable=YES" >> /etc/vsftpd/vsftpd_user_conf/"$VSFTPD_USER"
echo "anon_upload_enable=YES" >> /etc/vsftpd/vsftpd_user_conf/"$VSFTPD_USER"
echo "anon_mkdir_write_enable=YES" >> /etc/vsftpd/vsftpd_user_conf/"$VSFTPD_USER"
echo "anon_other_write_enable=YES" >> /etc/vsftpd/vsftpd_user_conf/"$VSFTPD_USER"

echo "Starting vsftpd..."
exec vsftpd /etc/vsftpd/vsftpd.conf
