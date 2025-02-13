FROM debian:bullseye

ARG FQDN
ARG WEB_ROOT
ARG CSP_IMG_SRC # [optional] For getting website images from trusted sources

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
COPY conf/${CONF_TEMPLATE} ${CONF_DIR}/${CONF_TEMPLATE}
RUN envsubst '$FQDN $WEB_ROOT $CSP_IMG_SRC' \
    < "$CONF_DIR"/"$CONF_TEMPLATE" \
    > "$CONF_DIR"/nginx.conf

# Copy entrypoint script
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 443

# Run nginx as a non-root user
USER nginx
ENTRYPOINT ["bash", "entrypoint.sh" ]
