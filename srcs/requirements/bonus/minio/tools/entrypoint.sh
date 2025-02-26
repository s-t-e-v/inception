#!/bin/bash
set -e

# Load credentials
MINIO_ROOT_PASSWORD=$(cat "$MINIO_ROOT_PASSWORD_FILE")
source "$MINIO_CREDENTIALS_FILE"

# Start MinIO in the background
minio server /minio --console-address :9001 &
MINIO_PID=$!

# Wait for MinIO to be ready
sleep 5  

echo "access key = $MINIO_ACCESS_KEY"
echo "secret key = $MINIO_SECRET_KEY"
echo "bucket name = $MINIO_BUCKET_NAME"
echo "minio root pswd = $MINIO_ROOT_PASSWORD"
echo "minio root user = $MINIO_ROOT_USER"

# Configure MinIO (create alias and bucket)
mc alias set minio http://127.0.0.1:9000 "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD"
mc mb --ignore-existing minio/"$MINIO_BUCKET_NAME"

# Stop background MinIO process
kill "$MINIO_PID"
wait "$MINIO_PID" 2>/dev/null || true  # Ignore errors if already stopped

# Restart MinIO properly as main process
exec minio server /minio --console-address :9001
