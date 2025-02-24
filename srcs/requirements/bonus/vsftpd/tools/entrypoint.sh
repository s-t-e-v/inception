#!/bin/bash
set -e  # Exit on error

LOGIN_FILE="/etc/vsftpd/login.txt"
DB_FILE="/etc/vsftpd/login.db"

set -a
VSFTPD_PASSWORD=$(cat "${VSFTPD_PASSWORD_FILE}")
set +a

create_db() {
    rm -f "$LOGIN_FILE"
    
    for entry in "$@"; do
        IFS="," read -r user password <<< "$entry"
        echo "$user" >> "$LOGIN_FILE"
        echo "$password" >> "$LOGIN_FILE"
    done
    echo "" >> "$LOGIN_FILE"
    
    rm -f "$DB_FILE"
    db_load -T -t hash -f "$LOGIN_FILE" "$DB_FILE"
    chmod 600 /etc/vsftpd/login.*
    echo "Database created."
}

configure_users() {
    while read -r user; do
        [ -z "$user" ] && continue  # Skip empty lines
        CONFIG_FILE="$USER_CONFIG_DIR/$user"
        
        echo "local_root=$WEB_CONTENT_DIR" > "$CONFIG_FILE"
        echo "write_enable=YES" >> "$CONFIG_FILE"
        echo "anon_upload_enable=YES" >> "$CONFIG_FILE"
        echo "anon_mkdir_write_enable=YES" >> "$CONFIG_FILE"
        echo "anon_other_write_enable=YES" >> "$CONFIG_FILE"
        echo "Configuration set for user: $user"
    done < <(awk 'NR % 2 == 1' "$LOGIN_FILE")  # Read only usernames
}

main() {
    local users=(
        "$VSFTPD_USER,$VSFTPD_PASSWORD"
        )
    create_db "${users[@]}"
    configure_users
    echo "Starting vsftpd..."
    exec vsftpd /etc/vsftpd/vsftpd.conf
}

main
