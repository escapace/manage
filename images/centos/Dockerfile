FROM quay.io/centos/centos:stream9

RUN yum -y --allowerasing install coreutils findutils bc gnupg git

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

ENTRYPOINT ["/workdir/manage"]
CMD ["help"]
