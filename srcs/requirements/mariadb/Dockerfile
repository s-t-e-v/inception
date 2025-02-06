FROM debian:bullseye

# Install MariaDB
RUN apt update && apt install -y mariadb-server && rm -rf /var/lib/apt/lists/*

# Ensure MariaDB directories have correct permissions
RUN mkdir -p /var/lib/mysql /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# Copy the secure install script
COPY tools/secure_install.sh /usr/local/bin/secure_install.sh
RUN chmod 700 /usr/local/bin/secure_install.sh

# Run setup as root
RUN --mount=type=secret,id=db_root_password \
    bash secure_install.sh

# Expose MariaDB port
EXPOSE 3306

# Run MariaDB as non-root `mysql` user
USER mysql
WORKDIR /app
CMD [ "mysqld_safe" ]