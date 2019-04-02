FROM alpine:latest

RUN apk add --no-cache \
        coreutils bash \
        sed bc gnupg git tini curl

ENV DOCKER=true
RUN mkdir -p /manage /data
WORKDIR /manage

COPY .manage.yml .manage.yml
COPY LICENSE LICENSE
COPY manage manage
COPY modules modules
COPY scripts scripts
COPY tests tests
COPY vendor vendor
COPY .manage_modules .manage_modules

RUN ln -s /manage/manage /usr/bin/manage && \
         ./manage trust-escapace

WORKDIR /data

RUN /usr/bin/manage init

ENTRYPOINT ["/sbin/tini", "--", "/manage/manage"]
CMD ["help"]
LABEL version=3.3.1
