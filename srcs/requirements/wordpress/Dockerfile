FROM debian:bullseye

ARG WEB_ROOT
ARG PHP_VERSION
ARG WP_VERSION

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
        php${PHP_VERSION}-cli && \
    rm -rf /var/lib/apt/lists/*

# Set up directories and permissions
RUN mkdir -p ${WEB_ROOT} /run/php /var/log/php-fpm /var/www/.wp-cli/cache && \
    chown -R www-data:www-data ${WEB_ROOT} /run/php /var/log/php-fpm /var/www/.wp-cli

# Set up PHP-FPM config
COPY conf/www.conf /etc/php/${PHP_VERSION}/fpm/pool.d/
RUN sed -i 's/^error_log =.*/error_log = \/var\/log\/php-fpm\/php'"${PHP_VERSION}"'-fpm.log/' \
/etc/php/${PHP_VERSION}/fpm/php-fpm.conf

WORKDIR ${WEB_ROOT}

# Install wp cli && download Wordpress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
chmod +x wp-cli.phar && \
mv wp-cli.phar  /usr/local/bin/wp && \
wp core download --version=${WP_VERSION} --allow-root

# Update permission for the Web root folder and wp-cli
RUN chown -R www-data:www-data ${WEB_ROOT}

# Set up healthcheck and entrypoint 
COPY tools/healthcheck.php /
COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

# Run wordpress+php-fpm as a non-root user
USER www-data
ENTRYPOINT [ "entrypoint.sh" ]