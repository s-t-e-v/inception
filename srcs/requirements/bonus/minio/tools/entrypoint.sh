#!/bin/bash
set -e

# Load credentials
MINIO_ROOT_PASSWORD=$(cat "$MINIO_ROOT_PASSWORD_FILE")
MINIO_WP_PASSWORD=$(cat "$MINIO_WP_PASSWORD_FILE")
source "$MINIO_ACCESS_KEYS_FILE"

# Start MinIO in the background
minio server /minio --console-address :9001 &
MINIO_PID=$!

# Wait for MinIO to be ready
sleep 5  

echo "access key = $MINIO_WP_USER"
echo "secret key = $MINIO_WP_PASSWORD"
echo "bucket name = $MINIO_BUCKET_NAME"
echo "minio root pswd = $MINIO_ROOT_PASSWORD"
echo "minio root user = $MINIO_ROOT_USER"

# Configure MinIO (create alias and bucket)
mc alias set minio http://127.0.0.1:9000 "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD"
mc mb --ignore-existing minio/"$MINIO_BUCKET_NAME"


# Create a dedicated user for WordPress uploads.
# (If the user already exists, the command will error; we ignore errors with '|| true')
mc admin user add minio "$MINIO_WP_USER" "$MINIO_WP_PASSWORD" || true

# Now create (or update) the access key for the WP user using a custom policy.
# The policy file is assumed to be available at /policy/wp-policy.json.
mc admin accesskey create minio "$MINIO_WP_USER" \
    --access-key "$MINIO_WP_ACCESS_KEY" \
    --secret-key "$MINIO_WP_SECRET_KEY"

mc admin policy attach minio readwrite --user "$MINIO_WP_USER"

# Stop background MinIO process
kill "$MINIO_PID"
wait "$MINIO_PID" 2>/dev/null || true  # Ignore errors if already stopped

# Restart MinIO properly as main process
exec minio server /minio --console-address :9001
