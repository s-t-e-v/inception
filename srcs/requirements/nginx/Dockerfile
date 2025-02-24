FROM debian:bullseye

ARG FQDN
ARG WP_ROOT
# Bonus
ARG ADMINER_ROOT

ENV FQDN=${FQDN}
ENV CONF_DIR=/etc/nginx
ENV CONF_TEMPLATE=nginx.template.conf

RUN apt update && \
    apt install -y --no-install-recommends \
        nginx \
        openssl \
        gettext-base && \
    rm -rf /var/lib/apt/lists/* && \
    # Create nginx (non-root) user
    adduser --system --no-create-home --group nginx && \
    # Set up directories and ownership for nginx user
    mkdir -p /run/nginx && \
    chown -R nginx:nginx /var/log/nginx /var/lib/nginx ${CONF_DIR} /run/nginx 

# Set up nginx.conf
COPY conf/${CONF_TEMPLATE} ${CONF_DIR}
RUN envsubst '$FQDN $WP_ROOT $ADMINER_ROOT' \
    < "$CONF_DIR"/"$CONF_TEMPLATE" \
    > "$CONF_DIR"/nginx.conf

# Set up entrypoint script
COPY tools/entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 443

# Run nginx as a non-root user
USER nginx
ENTRYPOINT [ "entrypoint.sh" ]
