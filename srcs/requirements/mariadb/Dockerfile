FROM debian:bullseye

# Install MariaDB
RUN apt update && \
    apt install -y --no-install-recommends mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# Copy the configuration fiie
COPY conf/mariadb.cnf /etc/mysql/

# Set up the entrypoint script
COPY tools/entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set up the health check script
COPY tools/healthcheck.sh /
RUN chmod +x /healthcheck.sh

# Expose MariaDB port
EXPOSE 3306

# Run MariaDB
ENTRYPOINT [ "entrypoint.sh" ]