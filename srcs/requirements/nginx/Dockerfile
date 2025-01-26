FROM debian:latest

RUN apt update && \
    apt install -y nginx && \
    mkdir -p /var/sbandaog.42.fr

WORKDIR /app

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY test.html /var/sbandaog.42.fr/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
