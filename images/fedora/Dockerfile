FROM fedora:rawhide

# RUN dnf -y update && dnf clean all
RUN dnf -y install coreutils findutils bc gnupg git

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

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-key 13F26F82E955B8B8CE469054F29CCEBC83FD4525
RUN mv /workdir/vendor/tini/tini /sbin/tini
RUN chown root:root /sbin/tini
RUN chmod 755 /sbin/tini

ENTRYPOINT ["/sbin/tini", "--", "/workdir/manage"]
CMD ["help"]
