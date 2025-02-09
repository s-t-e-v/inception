FROM debian:bullseye

# Install dependencies in a single layer to optimize caching and reduce image size
RUN apt update && \
    apt install -y \
        curl \
        unzip \
        software-properties-common \
        ca-certificates \
        lsb-release \
        apt-transport-https && \
    curl -sSL https://packages.sury.org/php/README.txt | bash -x && \
    apt update && \
    apt install -y php php-cli php-mysql php-curl php-gd php-intl php-fpm && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp-cli && \
    wp-cli core download --allow-root
 
COPY tools/wp_ini.sh /usr/local/bin/wp_ini.sh

# Expose PHP-FPM port
EXPOSE 9000

ENTRYPOINT [ "bash", "wp_ini.sh"]
# Start PHP-FPM in the foreground
# ENTRYPOINT [ "php-fpm", "-F" ]
