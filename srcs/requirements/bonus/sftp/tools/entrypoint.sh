#!/bin/bash
set -e

SSHD_CONFIG=/etc/ssh/sshd_config

# Load credentials
SFTP_PASSWORD=$(cat "$SFTP_PASSWORD_FILE")

groupadd sftpusers
useradd -m -g sftpusers -s /bin/false "$SFTP_USER"
echo "$SFTP_USER:$SFTP_PASSWORD" | chpasswd

chown -R root:sftpusers "${STATIC_WEBSITE_ROOT}"
chmod 775 "${STATIC_WEBSITE_ROOT}"

sed -i 's/^Subsystem.*sftp.*/Subsystem sftp internal-sftp/' "$SSHD_CONFIG" 

cat <<EOF >> "$SSHD_CONFIG"
Match Group sftpusers
    X11Forwarding no
    AllowTcpForwarding no
    PermitTTY no
    PermitTunnel no
    ForceCommand internal-sftp -d ${STATIC_WEBSITE_ROOT}
    ChrootDirectory ${WEB_CONTENT_DIR}
EOF

echo "sftp starting..."
exec /usr/sbin/sshd -D
