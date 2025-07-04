FROM debian:bullseye

ARG FQDN
ARG WP_ROOT
# Bonus
ARG ADMINER_ROOT
ARG STATIC_WEBSITE_FQDN

ENV FQDN=${FQDN}
ENV CONF_DIR=/etc/nginx
ENV CONF_TEMPLATE=nginx.template.conf
ENV SSL_DIR=/etc/ssl
ENV CERTS_DIR=${SSL_DIR}/certs
ENV KEYS_DIR=${SSL_DIR}/private


RUN apt update && \
    apt install -y --no-install-recommends \
        nginx \
        openssl \
        gettext-base && \
    rm -rf /var/lib/apt/lists/* && \
    # Create nginx (non-root) user
    adduser --system --no-create-home --group nginx && \
    # Set up directories and ownership for nginx user
    mkdir -p /run/nginx ${CERTS_DIR} ${KEYS_DIR} && \
    chown -R nginx:nginx /var/log/nginx /var/lib/nginx ${CONF_DIR} ${SSL_DIR} /run/nginx 

# Set up nginx.conf
COPY conf/${CONF_TEMPLATE} ${CONF_DIR}
RUN envsubst '$KEYS_DIR $CERTS_DIR $STATIC_WEBSITE_FQDN $FQDN $WP_ROOT $ADMINER_ROOT' \
    < "$CONF_DIR"/"$CONF_TEMPLATE" \
    > "$CONF_DIR"/nginx.conf

# Set up entrypoint script
COPY tools/entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 443

# Run nginx as a non-root user
USER nginx
ENTRYPOINT [ "entrypoint.sh" ]
