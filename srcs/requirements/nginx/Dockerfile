FROM debian:bullseye

ENV DOMAIN=sbandaog.42.fr

RUN apt update && apt install -y nginx && apt install -y openssl && rm -rf /var/lib/apt/lists/* &&\
    openssl req -newkey rsa:2048 -keyout /etc/nginx/${DOMAIN}.key -x509 -days 90 -out /etc/nginx/${DOMAIN}.crt -nodes -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42inception/CN=${DOMAIN}" && \
    chown root:root /etc/nginx/${DOMAIN}.key && \
    chmod 600 /etc/nginx/${DOMAIN}.key && \
    mkdir -p /var/${DOMAIN}

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY test.html /var/${DOMAIN}/index.html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
