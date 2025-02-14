FROM debian:bullseye

RUN apt update && \
    apt install -y redis-server && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 6379

ENTRYPOINT [ "redis-server" ]