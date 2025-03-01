FROM debian:bullseye

ARG PHP_VERSION
ARG WEB_BASE_DIR

# Install PHP and dependencies
RUN apt update && \
    apt install -y \
        curl \
        gosu \
        software-properties-common \
        ca-certificates \
        lsb-release \
        libfcgi0ldbl \
        apt-transport-https && \
    curl -sSL https://packages.sury.org/php/README.txt | bash -x && \
    apt update && \
    apt install -y --no-install-recommends \
        php${PHP_VERSION} \
        php${PHP_VERSION}-mysql \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-cli \
        # Bonus
        php${PHP_VERSION}-redis && \
    rm -rf /var/lib/apt/lists/*


RUN mkdir -p /run/php /var/log/php-fpm ${WEB_BASE_DIR}/.wp-cli && \
    chown -R www-data:www-data /run/php /var/log/php-fpm ${WEB_BASE_DIR}/.wp-cli

# Set up PHP-FPM config
COPY conf/www.conf /etc/php/${PHP_VERSION}/fpm/pool.d/
RUN sed -i 's/^error_log =.*/error_log = \/var\/log\/php-fpm\/php'"${PHP_VERSION}"'-fpm.log/' \
    /etc/php/${PHP_VERSION}/fpm/php-fpm.conf

# Set up wordpress install script
COPY tools/wordpress_install.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wordpress_install.sh

# Set up healthcheck and entrypoint 
COPY tools/healthcheck.php /
COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

ENTRYPOINT [ "entrypoint.sh" ]