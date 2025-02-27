FROM debian:bullseye

RUN apt update && \
    apt install -y \
        apt install openssh-server \
    apt install -y --no-install-recommends

RUN mkdir -p minio policy

# COPY policy/wp-policy.json policy/

# Set up healthcheck and entrypoint 
# COPY tools/healthcheck.sh /
COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000 9001

ENTRYPOINT [ "entrypoint.sh" ]