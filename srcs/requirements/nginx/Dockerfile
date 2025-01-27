FROM debian:bullseye

RUN apt update && \
    apt install -y nginx && \
    apt install -y openssl && \
    openssl req -newkey rsa:2048 -keyout /etc/nginx/sbandaog.42.fr.key -x509 -days 90 -out /etc/nginx/sbandaog.42.fr.crt -nodes -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42inception/CN=sbandaog.42.fr" && \
    chown root:root /etc/nginx/sbandaog.42.fr.key && \
    chmod 600 /etc/nginx/sbandaog.42.fr.key && \
    mkdir -p /var/sbandaog.42.fr

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY test.html /var/sbandaog.42.fr/index.html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
