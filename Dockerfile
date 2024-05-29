ARG MAINTAINER
FROM debian:stable-slim
# FROM python:slim
MAINTAINER $MAINTAINER

ARG SANED_HOST

ENV DEBIAN_FRONTEND noninteractive

ARG BRSCAN4KEY_DEB=https://download.brother.com/pub/com/linux/linux/packages/brscan-skey-0.3.2-0.amd64.deb

# Install Packages 
RUN apt-get update \
    && apt-get install -y --no-install-recommends locales \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && locale-gen en_US en_US.UTF-8 \
    && dpkg-reconfigure locales

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        # sudo \
        # whois \
        # poppler-utils \
        procps \
        sane-utils \
        # For brscan
        # curl \
        python3 \
        python3-ply \
        python3-pyasn1 \
        python3-pycryptodomex \
        python3-pysmi \
        python3-pysnmp \
        python3-PyYAML \
        python3-Wand \
        python3-setuptools \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install required python modules
# COPY requirements.txt /tmp/
# RUN pip install -r /tmp/requirements.txt

# This must be mapped to ${ADVERTISE_IP}:54925
EXPOSE 54925/udp

COPY pypkg/ /tmp/pypkg
# ADD $BRSCAN4KEY_DEB /tmp/

RUN echo "${SANED_HOST}" >> /etc/sane.d/net.conf

COPY init.sh /
RUN chmod +x /init.sh

CMD ["/init.sh"]