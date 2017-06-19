FROM alpine:3.6
MAINTAINER Mark Milstein <mark@epiloque.com> (@epiloque)

RUN apk add --no-cache coreutils bash sed bc gnupg git

VOLUME /data
ENV DOCKER=true
RUN mkdir -p /workdir
WORKDIR /workdir

COPY .manage.yml .manage.yml
COPY LICENSE LICENSE
COPY bin bin
COPY modules modules
COPY scripts scripts
COPY test test
COPY vendor/sharness vendor/sharness
