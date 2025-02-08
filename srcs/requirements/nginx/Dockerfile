FROM debian:bullseye

ARG FQDN
ENV CONF_DIR=/etc/nginx

RUN apt update && apt install -y nginx && apt install -y openssl && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/* &&\
    openssl req -newkey rsa:2048 -keyout ${CONF_DIR}/${FQDN}.key -x509 -days 90 -out ${CONF_DIR}/${FQDN}.crt -nodes -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42inception/CN=${FQDN}" && \
    chown root:root ${CONF_DIR}/${FQDN}.key && \
    chmod 600 ${CONF_DIR}/${FQDN}.key && \
    mkdir -p /var/${FQDN}

COPY conf/nginx.conf /tmp/nginx.conf
RUN envsubst '$FQDN' < /tmp/nginx.conf > ${CONF_DIR}/nginx.conf && rm /tmp/nginx.conf


COPY test.html /var/${FQDN}/index.html

EXPOSE 443

ENTRYPOINT [ "nginx", "-g", "daemon off;"]
