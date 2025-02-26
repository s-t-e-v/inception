FROM debian:bullseye

RUN apt update && \
    apt install -y \
        curl && \
    apt install -y --no-install-recommends && \
    curl -OL https://dl.min.io/server/minio/release/linux-amd64/minio && \
    chmod +x minio && mv minio /usr/local/bin

RUN mkdir -p minio

# Set up healthcheck and entrypoint 
# COPY tools/healthcheck.sh /
COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000 9001

ENTRYPOINT [ "entrypoint.sh" ]