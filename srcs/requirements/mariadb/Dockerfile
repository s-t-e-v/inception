FROM debian:bullseye

COPY tools/secure_install.sh secure_install.sh
COPY debug.sh debug.sh

RUN apt update && apt install -y mariadb-server && rm -rf /var/lib/apt/lists/*
RUN --mount=type=secret,id=db_root_password \
    DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password) && \
    export DB_ROOT_PASSWORD  && \
    service mariadb start && \
    chmod +x secure_install.sh && ./secure_install.sh

EXPOSE 3306

CMD ["bash", "debug.sh"]