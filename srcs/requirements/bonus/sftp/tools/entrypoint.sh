#!/bin/bash
set -e

# Load credentials
MINIO_ROOT_PASSWORD=$(cat "$MINIO_ROOT_PASSWORD_FILE")
MINIO_WP_PASSWORD=$(cat "$MINIO_WP_PASSWORD_FILE")
source "$MINIO_ACCESS_KEYS_FILE"

# Restart MinIO properly as main process
exec minio server /minio --console-address :9001
