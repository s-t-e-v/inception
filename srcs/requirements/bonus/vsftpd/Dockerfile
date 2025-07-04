FROM debian:bullseye

ARG WP_ROOT

ENV CONF_DIR=/etc/vsftpd
ENV VSFTPD_CONF=${CONF_DIR}/vsftpd.conf
ENV LOG_DIR=/var/log/vsftpd

# vsftpd.conf buildtime variables
ARG PASV_MAX_PORT
ARG PASV_MIN_PORT
ENV USERLIST_FILE=${CONF_DIR}/user_list
ENV USER_CONFIG_DIR=${CONF_DIR}/vsftpd_user_conf
ENV XFERLOG_FILE=${LOG_DIR}/vsftpd.log
ENV SECURE_CHROOT_DIR=/var/run/vsftpd/empty

# Install dependencies
RUN apt update && \
    apt install -y --no-install-recommends \
        vsftpd \
        ftp \
        libpam-modules \
        db-util && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p \
        ${CONF_DIR} \
        ${USER_CONFIG_DIR} \
        ${LOG_DIR} \
        ${SECURE_CHROOT_DIR} 

# Set up vsftpd configuration file
COPY conf/vsftpd.conf ${VSFTPD_CONF}

RUN chmod 600 ${VSFTPD_CONF}

RUN echo "" >> ${VSFTPD_CONF} && \
    cat <<EOF >> ${VSFTPD_CONF}
pasv_min_port=${PASV_MIN_PORT}
pasv_max_port=${PASV_MAX_PORT}
user_config_dir=${USER_CONFIG_DIR}
xferlog_file=${XFERLOG_FILE}
userlist_file=${USERLIST_FILE}
secure_chroot_dir=${SECURE_CHROOT_DIR}
EOF

# Copy the pam configuration file
COPY conf/pam.d/vsftpd /etc/pam.d/

# Copy the user_list file
COPY /conf/user_list ${CONF_DIR}

# Set up the health check script
COPY tools/healthcheck.sh /
RUN chmod +x /healthcheck.sh

# Set up the entrypoint script
COPY tools/entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose vsftpd ports
EXPOSE 21 ${PASV_MIN_PORT}-${PASV_MAX_PORT}

ENTRYPOINT [ "entrypoint.sh" ]
