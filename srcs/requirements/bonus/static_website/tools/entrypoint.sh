#!/bin/bash
set -e # Exit on error

# Start PHP-FPM in the foreground
echo "🚀 Starting Nginx..."
exec nginx -g 'daemon off;'