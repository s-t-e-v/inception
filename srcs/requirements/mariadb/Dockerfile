FROM debian:bullseye

ENV PASSWORD changeme

RUN apt update && apt install -y apt install -y mariadb-server && rm -rf /var/lib/apt/lists/* && \
    mysql -e "UPDATE mysql.user SET Password = PASSWORD('${PASSWORD}') WHERE User = 'root'" && \
    mysql -e "DROP USER ''@'localhost'" && \
    mysql -e "DROP USER ''@'$(hostname)'" && \
    mysql -e "DROP DATABASE test" && \
    mysql -e "FLUSH PRIVILEGES"

EXPOSE 9000

CMD ["service", "start", "mariadb"]
