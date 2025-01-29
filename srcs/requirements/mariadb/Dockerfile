FROM debian:bullseye

RUN apt update && apt install -y mariadb-server && rm -rf /var/lib/apt/lists/*
RUN --mount=type=secret,id=db_root_password \
    DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password) && \
    export DB_ROOT_PASSWORD  && \
    service mariadb start && \
    echo "UPDATE mysql.user SET Password=PASSWORD('$DB_ROOT_PASSWORD') WHERE User='root'; \
        DELETE FROM mysql.user WHERE User=''; \
        DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1'); \
        DROP DATABASE IF EXISTS test; \
        DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'; \
        FLUSH PRIVILEGES;" | mysql --user=root

EXPOSE 3306

CMD ["cat", "/run/secrets/db_root_password" ]