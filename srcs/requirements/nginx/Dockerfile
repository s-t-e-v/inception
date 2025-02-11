FROM debian:bullseye

ENV CONF_DIR=/etc/nginx
ENV CONF_TEMPLATE=nginx.template.conf

RUN apt update && apt install -y nginx openssl gettext-base && rm -rf /var/lib/apt/lists/*

COPY conf/${CONF_TEMPLATE} ${CONF_DIR}/${CONF_TEMPLATE}
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 443

ENTRYPOINT ["bash", "entrypoint.sh" ]
