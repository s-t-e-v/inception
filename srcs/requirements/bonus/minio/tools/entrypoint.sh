#!/bin/bash
set -e # Exit on error

MINIO_ROOT_PASSWORD=$(cat "$MINIO_ROOT_PASSWORD_FILE")

exec minio server /minio --console-address :9001