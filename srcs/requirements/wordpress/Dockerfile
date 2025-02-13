FROM debian:bullseye

ARG WEB_ROOT

RUN apt update && \
    # Prepare php install & get some helper programs
    apt install -y \
        curl \
        software-properties-common \
        ca-certificates \
        lsb-release \
        apt-transport-https \
        sendmail \
        libfcgi0ldbl && \
    curl -sSL https://packages.sury.org/php/README.txt | bash -x && \
    # Install php + php-fpm & php-mysql
    apt update && \
    apt install -y --no-install-recommends \
        php \
        php-mysql \
        php-fpm && \
    rm -rf /var/lib/apt/lists/* && \
    # Prepare necessary directories
    mkdir -p ${WEB_ROOT} /run/php

WORKDIR ${WEB_ROOT}

# Install wordpress wp-cli & download wordpress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp-cli && \
    wp-cli core download --allow-root
    
# Set up www.conf
COPY conf/www.conf /tmp
RUN PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;') && \
    echo "PHP_VERSION=${PHP_VERSION}" >> /etc/environment && \
    mv /tmp/www.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

# Set up entrypoint script
COPY tools/entrypoint.sh /usr/local/bin

# Set up healthcheck script
COPY tools/healthcheck.php /

# Expose PHP-FPM port
EXPOSE 9000

ENTRYPOINT [ "bash", "entrypoint.sh"]
