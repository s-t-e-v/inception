FROM debian:bullseye

RUN apt update && apt install -y apt install -y mariadb-server && rm -rf /var/lib/apt/lists/* && \
    mysql_secure_installation

EXPOSE 9000

CMD ["nginx", "-g", "daemon off;"]
