FROM debian:bullseye

ARG STATIC_WEBSITE_FQDN
ARG STATIC_WEBSITE_ROOT

ENV CONF_DIR=/etc/nginx
ENV CONF_TEMPLATE=nginx.template.conf

RUN apt update && \
    apt install -y --no-install-recommends \
        nginx \
        gettext-base && \
    rm -rf /var/lib/apt/lists/* && \
    # Create nginx (non-root) user
    adduser --system --no-create-home --group nginx && \
    # Set up directories and ownership for nginx user
    mkdir -p /run/nginx && \
    chown -R nginx:nginx /var/log/nginx /var/lib/nginx ${CONF_DIR} /run/nginx 

# Set up nginx.conf
COPY conf/${CONF_TEMPLATE} ${CONF_DIR}
RUN envsubst '$STATIC_WEBSITE_FQDN $STATIC_WEBSITE_ROOT' \
    < "$CONF_DIR"/"$CONF_TEMPLATE" \
    > "$CONF_DIR"/nginx.conf

# Set up entrypoint script
COPY tools/entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh


WORKDIR ${STATIC_WEBSITE_ROOT}

COPY index.html .

# Update permission for the Web root folder and wp-cli
RUN chown -R www-data:www-data ${STATIC_WEBSITE_ROOT}

EXPOSE 80

# Run nginx as a non-root user
USER nginx
ENTRYPOINT [ "entrypoint.sh" ]
