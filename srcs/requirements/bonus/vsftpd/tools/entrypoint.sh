#!/bin/bash
set -e # exit on error

set -a
VSFTPD_PASSWORD=$(cat "${VSFTPD_PASSWORD_FILE}")
set +a

chown -R ftp:ftp /var/www/html

VSFTPD_USER="$LOGIN"
LOGIN_FILE=/etc/vsftpd/login.txt

# Set login.txt file
echo "$VSFTPD_USER" > "$LOGIN_FILE"
echo "$VSFTPD_PASSWORD" >> "$LOGIN_FILE"
echo "joe" >> "$LOGIN_FILE"
echo "faux" >> "$LOGIN_FILE"
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

echo "local_root=/var/www" > /etc/vsftpd/vsftpd_user_conf/joe
echo "write_enable=NO" >> /etc/vsftpd/vsftpd_user_conf/joe
echo "anon_upload_enable=NO" >> /etc/vsftpd/vsftpd_user_conf/joe
echo "anon_mkdir_write_enable=NO" >> /etc/vsftpd/vsftpd_user_conf/joe
echo "anon_other_write_enable=NO" >> /etc/vsftpd/vsftpd_user_conf/joe


# TLS set up

# Generate SSL private key and contract
echo "📃  Generating SSL certificate..."

SUBJECT="/C=FR/ST=IDF/L=Paris/O=42/OU=42inception/CN=${FQDN}"

if ! openssl req -newkey rsa:2048 \
    -keyout /etc/ssl/private/vsftpd.key.pem \
    -x509 -days 365 \
    -out /etc/ssl/private/vsftpd.cert.pem \
    -nodes \
    -subj "$SUBJECT"; then
    echo "❌  Failed to generate SSL certificate"
    exit 1
fi

chmod 600 /etc/ssl/private/vsftpd.key.pem
chmod 644 /etc/ssl/private/vsftpd.cert.pem

echo "Starting vsftpd..."
exec vsftpd /etc/vsftpd/vsftpd.conf
