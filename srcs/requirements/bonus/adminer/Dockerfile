FROM debian:bullseye

ARG ADMINER_ROOT
ARG PHP_VERSION
ARG ADMINER_VERSION

# Install PHP and dependencies
RUN apt update && \
    apt install -y \
        curl \
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
        && \
    rm -rf /var/lib/apt/lists/*

# Set up directories and permissions
RUN mkdir -p ${ADMINER_ROOT} /run/php /var/log/php-fpm && \
    chown -R www-data:www-data ${ADMINER_ROOT} /run/php /var/log/php-fpm

# Set up PHP-FPM config
COPY conf/www.conf /etc/php/${PHP_VERSION}/fpm/pool.d/
RUN sed -i 's/^error_log =.*/error_log = \/var\/log\/php-fpm\/php'"${PHP_VERSION}"'-fpm.log/' \
/etc/php/${PHP_VERSION}/fpm/php-fpm.conf

WORKDIR ${ADMINER_ROOT}

# Install && download Adminer
RUN curl -O https://github.com/vrana/adminer/releases/download/v${ADMINER_VERSION}/adminer-${ADMINER_VERSION}.php && \
    mv adminer-${ADMINER_VERSION}.php index.php

# Update permission for the Adminer root folder 
RUN chown -R www-data:www-data ${ADMINER_ROOT}

# Set up healthcheck and entrypoint 
# COPY tools/healthcheck.php /
COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

# Run wordpress+php-fpm as a non-root user
USER www-data
ENTRYPOINT [ "entrypoint.sh" ]