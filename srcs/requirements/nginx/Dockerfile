FROM debian:bullseye

ARG FQDN

ENV FQDN=${FQDN}
ENV CONF_DIR=/etc/nginx
ENV CONF_TEMPLATE=nginx.template.conf

RUN apt update && \
    apt install -y --no-install-recommends \
        nginx \
        openssl \
        gettext-base && \
    rm -rf /var/lib/apt/lists/* && \
    # Generate SSL certificate
    openssl req -newkey rsa:2048 -keyout ${CONF_DIR}/${FQDN}.key -x509 -days 90 -out ${CONF_DIR}/${FQDN}.crt -nodes -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42inception/CN=${FQDN}" && \
    chown root:root ${CONF_DIR}/${FQDN}.key && \
    chmod 600 ${CONF_DIR}/${FQDN}.key && \
    chmod 644 ${CONF_DIR}/${FQDN}.crt


COPY conf/${CONF_TEMPLATE} ${CONF_DIR}/${CONF_TEMPLATE}
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 443

ENTRYPOINT ["bash", "entrypoint.sh" ]
