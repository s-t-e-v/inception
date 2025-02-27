FROM debian:bullseye

RUN apt update && \
    apt install -y --no-install-recommends \
        openssh-server && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/sshd

# Set up healthcheck and entrypoint 
# COPY tools/healthcheck.sh /
COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 22

ENTRYPOINT [ "entrypoint.sh" ]