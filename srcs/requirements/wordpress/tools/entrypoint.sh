#!/bin/bash
set -e # Exit on error

cd ${WP_ROOT}

# Install Wordpress if wp-config.php doesn't exist
if [ ! -f wp-config.php ]; then
    echo "🏗️  Setting up Wordpress..."
    # Load credentials
    set -a
    MYSQL_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")
    source "$WORDPRESS_CREDENTIALS_FILE"
    # ---- Bonus
    REDIS_PASSWORD=$(cat "$REDIS_PASSWORD_FILE")
    set +a

    # Install wp cli 
    curl -OL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar  /usr/local/bin/wp

    # Install wordpress as non-root
    chown -R www-data:www-data ${WP_ROOT}
    gosu www-data wordpress_install.sh
    
    echo "Wordpress is ready!  🚀"
fi


# Start PHP-FPM in the foreground
echo "Starting php-fpm..."
exec gosu www-data php-fpm${PHP_VERSION} -F
