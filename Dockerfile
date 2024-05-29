ARG MAINTAINER
FROM debian:stable-slim
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
        python3-pip \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD $BRSCAN4KEY_DEB /tmp/
RUN echo "${SANED_HOST}" >> /etc/sane.d/net.conf
COPY init.sh /
RUN chmod +x /init.sh

CMD ["/init.sh"]