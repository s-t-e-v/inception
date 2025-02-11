FROM debian:bullseye

ENV CONF_DIR=/etc/nginx

RUN apt update && apt install -y nginx openssl gettext-base && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf.template ${CONF_DIR}/nginx.conf.template
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 443

ENTRYPOINT ["bash", "entrypoint.sh" ]
