FROM alpine:3.7

RUN apk add --no-cache coreutils bash sed bc gnupg git tini

ENV DOCKER=true
RUN mkdir -p /workdir
WORKDIR /workdir

COPY .manage.yml .manage.yml
COPY LICENSE LICENSE
COPY bin bin
COPY modules modules
COPY scripts scripts
COPY test test
COPY vendor vendor

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-key 13F26F82E955B8B8CE469054F29CCEBC83FD4525

ENTRYPOINT ["/sbin/tini", "--", "/workdir/bin/manage"]
CMD ["help"]
