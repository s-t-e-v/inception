FROM debian:bullseye

ARG WEB_ROOT

# Install PHP and dependencies
RUN apt update && \
    apt install -y \
        curl \
        software-properties-common \
        ca-certificates \
        lsb-release \
        apt-transport-https \
        sendmail \
        gettext-base \
        libfcgi0ldbl && \
    curl -sSL https://packages.sury.org/php/README.txt | bash -x && \
    apt update && \
    apt install -y --no-install-recommends \
        php \
        php-mysql \
        php-fpm && \
    rm -rf /var/lib/apt/lists/*

# Dynamically detect PHP version at build time
RUN PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;') && \
    echo "PHP_VERSION=${PHP_VERSION}" >> /etc/environment

# Set up directories and permissions
RUN mkdir -p ${WEB_ROOT} /run/php /var/log/php-fpm && \
    chown -R www-data:www-data ${WEB_ROOT} /run/php /var/log/php-fpm

WORKDIR ${WEB_ROOT}

# Install wp-cli and download WordPress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    wp core download --allow-root

# Copy PHP-FPM config templates
COPY conf/www.conf /tmp
COPY conf/php-fpm.template.conf /tmp

# Generate PHP-FPM configs with detected PHP version
SHELL ["/bin/bash", "-c"] 
RUN source /etc/environment && \
    mv /tmp/www.conf /etc/php/${PHP_VERSION}/fpm/pool.d/ && \
    export PHP_VERSION && \
    envsubst '$PHP_VERSION' < /tmp/php-fpm.template.conf > /etc/php/${PHP_VERSION}/fpm/php-fpm.conf
SHELL ["/bin/sh", "-c"]

# Copy entrypoint and healthcheck
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY tools/healthcheck.php /healthcheck.php

# Ensure scripts are executable
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

USER www-data
ENTRYPOINT [ "entrypoint.sh" ]