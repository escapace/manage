FROM alpine:latest

RUN apk add --no-cache coreutils bash sed bc gnupg git

VOLUME /data
ENV DOCKER=true
RUN mkdir -p /workdir
WORKDIR /workdir

COPY .manage.yml .manage.yml
COPY README.md README.md
COPY LICENSE LICENSE
COPY manage manage
COPY modules modules
COPY scripts scripts
COPY test test
COPY vendor/sharness vendor/sharness
COPY .travis-master.yml .travis.yml

RUN rm scripts/release

