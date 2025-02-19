FROM debian:bullseye

ARG LOGIN
ENV LOGIN=${LOGIN}

# Install dependencies
RUN apt update && \
    apt install -y --no-install-recommends \
        vsftpd \
        libpam-modules \
        db-util && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/vsftpd /etc/vsftpd/vsftpd_user_conf /var/run/vsftpd/empty
RUN usermod -aG www-data ftp

# Copy the configuration file
COPY conf/vsftpd.conf /etc/vsftpd/
RUN chmod 600 /etc/vsftpd/vsftpd.conf

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
EXPOSE 20 21

# Run vsftpd as a non-root user
# USER vsftpd
ENTRYPOINT [ "entrypoint.sh" ]
