FROM alpine:latest

RUN apk add --no-cache coreutils bash sed bc gnupg git tini

ENV DOCKER=true
RUN mkdir -p /workdir
WORKDIR /workdir

COPY .manage.yml .manage.yml
COPY LICENSE LICENSE
COPY manage manage
COPY modules modules
COPY scripts scripts
COPY test test
COPY vendor vendor

RUN ./manage trust-escapace

ENTRYPOINT ["/sbin/tini", "--", "/workdir/manage"]
CMD ["help"]
