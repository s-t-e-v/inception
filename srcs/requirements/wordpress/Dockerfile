FROM debian:bullseye

ARG WEB_ROOT

# TODO: optimise layers + maybe remove some dependancies
# Install dependencies in a single layer to optimize caching and reduce image size
RUN apt update && \
    apt install -y --no-install-recommends \
        curl \
        software-properties-common \
        ca-certificates \
        lsb-release \
        apt-transport-https && \
    curl -sSL https://packages.sury.org/php/README.txt | bash -x
RUN apt update && apt install -y --no-install-recommends php php-mysql php-fpm && \
    rm -rf /var/lib/apt/lists/*
RUN apt update && apt install -y --no-install-recommends sendmail && \
    rm -rf /var/lib/apt/lists/*
RUN apt update && apt install -y libfcgi0ldbl && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${WEB_ROOT} /run/php


WORKDIR ${WEB_ROOT}

# Install wordpress wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp-cli && \
    wp-cli core download --allow-root
    
    # TODO: put the version of PHP into an ENV variable to avoid hardcoding it
    # TODO: if you can and if it is worth it: add clear_env = no + change the line of listen by listen = wordpress:9000
# TODO: if it is worth it, only allow nginx as client thanks to clear_env = no
# TODOL increase number of process www.conf to avoid badgateway 502
COPY conf/www.conf /etc/php/8.3/fpm/pool.d/www.conf
COPY conf/php-fpm.conf /etc/php/8.3/fpm/php-fpm.conf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

COPY tools/healthcheck.php /

RUN mkdir -p /usr/log/

# Expose PHP-FPM port
EXPOSE 9000

ENTRYPOINT [ "bash", "entrypoint.sh"]
