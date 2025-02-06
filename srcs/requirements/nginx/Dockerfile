FROM debian:bullseye

ARG FQDN

# TODO: DRY: create an environment variable called CONF_DIR=/etc/nginx & use it

RUN apt update && apt install -y nginx && apt install -y openssl && rm -rf /var/lib/apt/lists/* &&\
    openssl req -newkey rsa:2048 -keyout /etc/nginx/${FQDN}.key -x509 -days 90 -out /etc/nginx/${FQDN}.crt -nodes -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42inception/CN=${FQDN}" && \
    chown root:root /etc/nginx/${FQDN}.key && \
    chmod 600 /etc/nginx/${FQDN}.key && \
    mkdir -p /var/${FQDN}

COPY conf/nginx.conf /etc/nginx/nginx.conf
# TODO: DRY: modify conf/nginx.conf so you cam sed FQDN in it
COPY test.html /var/${FQDN}/index.html

EXPOSE 443

# FIXME - run nginx as a non-root user
CMD ["nginx", "-g", "daemon off;"]
