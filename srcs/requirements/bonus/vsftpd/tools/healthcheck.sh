#!/bin/sh
set -eu  # Exit on error and treat unset variables as errors

VSFTPD_PASSWORD=$(cat "$VSFTPD_PASSWORD_FILE")

ftp -inv <<EOF | grep "226"
open localhost
user $VSFTPD_USER $VSFTPD_PASSWORD
ls
bye
EOF
