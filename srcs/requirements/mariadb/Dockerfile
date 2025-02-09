FROM debian:bullseye

# Install MariaDB
RUN apt update && apt install -y mariadb-server && rm -rf /var/lib/apt/lists/* && \
    mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

# Copy the configuration fiie
COPY conf/mariadb.cnf /etc/mysql/mariadb.cnf

# Copy the initialization script
COPY tools/db_ini.sh /usr/local/bin/db_ini.sh

# Copy the health check script
COPY tools/healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh


# Expose MariaDB port
EXPOSE 3306

# Run MariaDB
ENTRYPOINT [ "bash", "db_ini.sh" ]