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
COPY tests tests
COPY vendor/sharness vendor/sharness
COPY .manage_modules .manage_modules
COPY images/alpine images/alpine
COPY images/centos images/centos
COPY images/shellcheck images/shellcheck
COPY images/master/Dockerfile Dockerfile
COPY .github .github

RUN rm scripts/release
