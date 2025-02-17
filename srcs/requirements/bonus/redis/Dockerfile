FROM debian:bullseye

RUN apt update && \
    apt install -y redis-server && \
    rm -rf /var/lib/apt/lists/*

# Set up ownership for redis user
RUN mkdir -p /var/lib/redis && \
    chown -R redis:redis /var/lib/redis

# Set up entrypoint script
COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set up the health check script
COPY tools/healthcheck.sh /
RUN chmod +x /healthcheck.sh

EXPOSE 6379

USER redis

ENTRYPOINT [ "entrypoint.sh" ]