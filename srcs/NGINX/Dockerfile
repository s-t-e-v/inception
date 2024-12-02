FROM debian:latest

RUN apt update && \
    apt install -y nginx

CMD ["systemctl", "start", "nginx"]