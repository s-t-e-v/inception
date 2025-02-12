# WARN: In production, Nginx should run as a non-root user, 
#       but this is omitted for simplicity in this project

FROM debian:bullseye

ARG FQDN
ARG WEB_ROOT

ENV FQDN=${FQDN}
ENV CONF_DIR=/etc/nginx
ENV CONF_TEMPLATE=nginx.template.conf

RUN apt update && \
    apt install -y --no-install-recommends \
        nginx \
        openssl \
        gettext-base && \
    rm -rf /var/lib/apt/lists/*

# Set up nginx.conf
COPY conf/${CONF_TEMPLATE} ${CONF_DIR}/${CONF_TEMPLATE}
RUN envsubst '$FQDN $WEB_ROOT' \
    < "$CONF_DIR"/"$CONF_TEMPLATE" \
    > "$CONF_DIR"/nginx.conf

# Copy entrypoint script
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 443

ENTRYPOINT ["bash", "entrypoint.sh" ]
