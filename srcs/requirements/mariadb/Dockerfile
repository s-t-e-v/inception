FROM debian:bullseye

# Install MariaDB
RUN apt update && apt install -y mariadb-server && rm -rf /var/lib/apt/lists/*

# Copy the initialization script
COPY tools/db_ini.sh /usr/local/bin/db_ini.sh

# Copy the configuration fiie
COPY conf/mariadb.cnf /etc/mysql/mariadb.cnf

# Expose MariaDB port
EXPOSE 3306

# Run MariaDB
ENTRYPOINT [ "bash", "db_ini.sh" ]