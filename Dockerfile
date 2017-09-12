MAINTAINER Ryan Olson rolson@nvidia.com

RUN apt-get update && apt-get install -y --no-install-recommends \
        autogen autoconf automake libtool build-essential libpam0g-dev libmysqlclient-dev \
        libmunge-dev libmysqld-dev wget python-minimal python-pip fakeroot debhelper \
        dh-autoreconf dh-make vim-tiny git && \
    rm -rf /var/lib/apt/lists/*

ARG VERSION

WORKDIR /
RUN git clone https://github.com/ryanolson/singularity.git \
 && cd singularity \
 && ./autogen.sh \
 && ./configure --prefix=/usr \
 && make \
 && make install

ARG APT_VERSION

RUN cd /singularity \
 && fakeroot dpkg-buildpackage -b -us -uc  

FROM nvidia/cuda:8.0-devel
ARG VERSION
ARG APT_VERSION
COPY --from=0 /singularity-container_2.3-1_amd64.deb /tmp/singularity-container_${VERSION}-${APT_VERSION}_amd64.deb
RUN dpkg -i /tmp/singularity-container_${VERSION}-${APT_VERSION}_amd64.deb
