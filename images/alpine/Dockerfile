FROM alpine:3.6
MAINTAINER Mark Milstein <mark@epiloque.com> (@epiloque)

RUN apk add --no-cache coreutils bash sed bc gnupg git

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

RUN gpg --keyserver pgp.mit.edu --recv-key 0xF29CCEBC83FD4525
RUN mv /workdir/vendor/dumb-init/dumb-init /usr/bin/dumb-init
RUN chown root:root /usr/bin/dumb-init
RUN chmod 755 /usr/bin/dumb-init

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/workdir/bin/manage"]
CMD ["help"]
