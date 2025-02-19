FROM debian:bullseye

# Install dependencies
RUN apt update && \
    apt install -y --no-install-recommends \
        vsftpd \
        libdb-dev && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/vsftpd /etc/vsftpd/vsftd_user_conf

# Copy the configuration fiie
COPY conf/vsftpd.cnf /etc/vsftpd/
RUN chmod 600 /etc/vsftpd/vsftpd.cnf

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
