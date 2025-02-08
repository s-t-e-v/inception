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

# Download and extract WordPress
RUN mkdir -p /var/www/html && \
    curl -o /tmp/wordpress.zip https://wordpress.org/latest.zip && \
    unzip /tmp/wordpress.zip -d /var/www/html && \
    rm /tmp/wordpress.zip

# Expose PHP-FPM port
EXPOSE 9000

ENTRYPOINT [ "php" ]
CMD [ "-v" ]
# Start PHP-FPM in the foreground
# ENTRYPOINT [ "php-fpm" ]
# CMD [ "-F" ]
