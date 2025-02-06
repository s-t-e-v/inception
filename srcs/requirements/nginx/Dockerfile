FROM debian:bullseye

ARG DOMAIN_NAME

RUN apt update && apt install -y nginx && apt install -y openssl && rm -rf /var/lib/apt/lists/* &&\
    openssl req -newkey rsa:2048 -keyout /etc/nginx/${DOMAIN_NAME}.key -x509 -days 90 -out /etc/nginx/${DOMAIN_NAME}.crt -nodes -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42inception/CN=${DOMAIN_NAME}" && \
    chown root:root /etc/nginx/${DOMAIN_NAME}.key && \
    chmod 600 /etc/nginx/${DOMAIN_NAME}.key && \
    mkdir -p /var/${DOMAIN_NAME}

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY test.html /var/${DOMAIN_NAME}/index.html

EXPOSE 443

# TODO run nginx as a non-root user
CMD ["nginx", "-g", "daemon off;"]
