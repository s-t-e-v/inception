#!/bin/bash
set -e # Exit on error

exec minio server /minio --console-address :9001