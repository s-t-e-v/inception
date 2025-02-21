FROM debian:bullseye

ARG FQDN
ARG PASV_MIN_PORT
ARG PASV_MAX_PORT

ENV FQDN=${FQDN}

# Install dependencies
RUN apt update && \
    apt install -y --no-install-recommends \
        vsftpd \
        libpam-modules \
        openssl \
        db-util && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/vsftpd /etc/vsftpd/vsftpd_user_conf /var/run/vsftpd/empty
RUN usermod -aG www-data ftp
RUN mkdir -p /etc/ssl/private

# Copy the configuration file
COPY conf/vsftpd.conf /etc/vsftpd/
RUN chmod 600 /etc/vsftpd/vsftpd.conf
RUN sed -i "s/^pasv_min_port=.*/pasv_min_port=$PASV_MIN_PORT/" /etc/vsftpd/vsftpd.conf && \
    sed -i "s/^pasv_max_port=.*/pasv_max_port=$PASV_MAX_PORT/" /etc/vsftpd/vsftpd.conf
# Copy the pam configuration file
COPY conf/pam.d/vsftpd /etc/pam.d/

# Copy the user_list file
COPY /conf/user_list /etc/vsftpd/

# Copy txt2db script
COPY tools/txt2db.sh /usr/local/bin
RUN chmod +x /usr/local/bin/txt2db.sh

# Copy cleanconf script
COPY tools/cleanconf.sh /usr/local/bin
RUN chmod +x /usr/local/bin/cleanconf.sh

# Set up the entrypoint script
COPY tools/entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set up the health check script
# COPY tools/healthcheck.sh /
# RUN chmod +x /healthcheck.sh

# Expose vsftpd ports
EXPOSE 20 21 ${PASV_MIN_PORT}-${PASV_MAX_PORT}

# Run vsftpd as a non-root user
# USER vsftpd
ENTRYPOINT [ "entrypoint.sh" ]
