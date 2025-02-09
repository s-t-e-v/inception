FROM debian:bullseye

# TODO: optimise layers + maybe remove some dependancies
# Install dependencies in a single layer to optimize caching and reduce image size
RUN apt update && \
    apt install -y \
        curl \
        unzip \
        software-properties-common \
        ca-certificates \
        lsb-release \
        apt-transport-https && \
    curl -sSL https://packages.sury.org/php/README.txt | bash -x
RUN apt update && apt install -y php
RUN apt install -y  php-mysql php-mbstring php-bcmath php-zip php-gd php-curl php-xml
RUN apt install php-fpm -y && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

# Install wordpress wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp-cli && \
    wp-cli core download --allow-root

RUN mkdir -p /run/php/
 
# TODO: put the version of PHP into an ENV variable to avoid hardcoding it
COPY conf/www.conf /etc/php/8.3/fpm/pool.d/wwww.conf
COPY tools/wp_ini.sh /usr/local/bin/wp_ini.sh

# Expose PHP-FPM port
EXPOSE 9000

ENTRYPOINT [ "bash", "wp_ini.sh"]
