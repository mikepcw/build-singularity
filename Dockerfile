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
