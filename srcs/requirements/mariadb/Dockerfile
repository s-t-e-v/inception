FROM debian:bullseye

RUN apt update && apt install -y mariadb-server && rm -rf /var/lib/apt/lists/*

COPY tools/secure_install.sh /usr/local/bin/secure_install.sh

RUN --mount=type=secret,id=db_root_password \
    DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password) && \
    export DB_ROOT_PASSWORD && \
    service mariadb start && \
    (bash /usr/local/bin/secure_install.sh > out 2>error) || echo

EXPOSE 3306

CMD [ "mysqld" ]