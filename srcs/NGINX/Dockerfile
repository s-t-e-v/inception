FROM debian:latest

RUN apt update && \
    apt install -y nginx

WORKDIR /app

COPY launcher.sh .

EXPOSE 80

CMD ["bash", "./launcher.sh"]
