FROM debian:bullseye

RUN apt update && \
    apt install -y redis-server && \
    rm -rf /var/lib/apt/lists/*

# Setup entrypoit script
COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 6379

ENTRYPOINT [ "entrypoint.sh" ]