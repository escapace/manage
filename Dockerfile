FROM alpine:latest

RUN apk add --no-cache \
        coreutils bash sed bc gnupg git tini curl

ENV DOCKER=true
RUN mkdir -p /workdir
WORKDIR /workdir

COPY .manage.yml .manage.yml
COPY LICENSE LICENSE
COPY manage manage
COPY modules modules
COPY scripts scripts
COPY tests tests
COPY vendor vendor
COPY .manage_modules .manage_modules

RUN ./manage trust-escapace

ENTRYPOINT ["/sbin/tini", "--", "/workdir/manage"]
CMD ["help"]
LABEL version=v3.2.3
