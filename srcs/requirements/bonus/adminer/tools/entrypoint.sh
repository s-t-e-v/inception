#!/bin/bash
set -e # Exit on error

# Start PHP-FPM in the foreground
echo "Starting php-fpm..."
exec php-fpm${PHP_VERSION} -F