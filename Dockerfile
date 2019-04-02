FROM alpine:latest

RUN mkdir -p /opt/manage /var/manage && \
    apk add --no-cache \
        coreutils bash \
        sed bc gnupg git tini curl

COPY .manage_modules vendor tests scripts modules manage .manage.yml LICENSE /opt/manage/

RUN ln -s /opt/manage/manage /usr/bin/manage && \
    cd /opt/manage && ./manage trust-escapace && \
    cd /var/manage && /usr/bin/manage init

WORKDIR /var/manage

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/manage"]
CMD ["help"]
