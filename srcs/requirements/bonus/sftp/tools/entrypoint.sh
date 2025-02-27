#!/bin/bash
set -e

# Load credentials
SFTP_PASSWORD=$(cat "$SFTP_PASSWORD_FILE")

groupadd sftpusers
useradd -m -g sftpusers -s /bin/false "$SFTP_USER"
usermod -a -G www-data "$SFTP_USER"
echo "$SFTP_USER:$SFTP_PASSWORD" | chpasswd

chown -R root:sftpusers "${STATIC_WEBSITE_ROOT}"


cat <<EOF >> /etc/ssh/sshd_config
Match Group sftpusers
ChrootDirectory ${WEB_CONTENT_DIR}
ForceCommand internal-sftp
EOF

echo "sftp starting..."
exec /usr/sbin/sshd -D
