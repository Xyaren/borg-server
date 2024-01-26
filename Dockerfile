FROM alpine:3.19
LABEL maintainer="xyaren"

#Install Borg & SSH
RUN apk add --no-cache openssh sshfs borgbackup supervisor

RUN adduser -D -u 1000 borg && \
    passwd -u borg && \
    mkdir -m 0700 /backups && \
    chown borg.borg /backups && \
    sed -i \
        -e 's/^#PasswordAuthentication yes$/PasswordAuthentication no/g' \
        -e 's/^PermitRootLogin without-password$/PermitRootLogin no/g' \
        /etc/ssh/sshd_config

COPY supervisord.conf /etc/supervisord.conf
COPY service.sh /usr/local/bin/service.sh

EXPOSE 22
VOLUME /etc/ssh

CMD ["/usr/bin/supervisord"]
