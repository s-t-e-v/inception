FROM debian:latest

RUN apt update && \
    apt install -y nginx && \
    mkdir -p /var/www/sbandaog.42.fr

WORKDIR /app

COPY conf /etc/nginx/nginx.conf
COPY tools/launcher.sh .
COPY test.html /var/www/sbandaog.42.fr/index.html

EXPOSE 8042

CMD ["bash", "./launcher.sh"]
