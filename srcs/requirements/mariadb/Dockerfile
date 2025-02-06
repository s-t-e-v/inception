FROM debian:bullseye

# Install MariaDB
RUN apt update && apt install -y mariadb-server && rm -rf /var/lib/apt/lists/*

# Copy the secure install script
COPY tools/secure_install.sh /usr/local/bin/secure_install.sh
COPY conf/mariadb.cnf /etc/mysql/mariadb.cnf

# Run setup as root
# TODO: DRY: make an environment variable for /root/.my.cnf inside secure_install.sh
# TODO: DRY: make an environment variable for cat /run/secrets/db_root_password inside secure_install.sh
RUN --mount=type=secret,id=db_root_password \
    bash secure_install.sh

# Expose MariaDB port
EXPOSE 3306

# Run MariaDB as non-root `mysql` user
USER mysql
WORKDIR /app
CMD [ "mysqld" ]