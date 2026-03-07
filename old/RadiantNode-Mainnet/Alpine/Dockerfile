# Alpine 3.13.0
#
# The Radiant Blockchain Developers
# The purpose of this image is to be able to host Radiant Node (RXD)
# Build with: `docker build .`
# Public images at: https://hub.docker.com/u/radiantcommunity
# Thanks to Bacto for detecting bugs in the code

FROM alpine:3.13.0

LABEL maintainer="code@radiant4people.com"
LABEL version="1.3.0"
LABEL description="Docker image for radiantd node"

WORKDIR /root

RUN  apk add git boost-dev cmake libevent-dev openssl-dev build-base py-pip db-dev zeromq-dev help2man bash \
  && pip install ninja \
  && git clone --depth 1 --branch v1.3.0 https://github.com/radiantblockchain/radiant-node.git \
  && cmake -GNinja radiant-node -DBUILD_RADIANT_QT=OFF -DENABLE_UPNP=OFF -DENABLE_MAN=OFF -DBUILD_RADIANT_SEEDER=OFF -DBUILD_BITCOIN_ZMQ=ON \
  && ninja \
  && ninja install \
  && pip uninstall ninja -y \
  && apk del git cmake build-base py-pip \
  && rm -rf /root/* /tmp/* /var/tmp/*


COPY radiantnode.sh /radiantnode.sh

RUN chmod 755 /radiantnode.sh

EXPOSE 7333
 
RUN mkdir -p /data

VOLUME /data

ENTRYPOINT ["/bin/sh", "-c" , "/radiantnode.sh"]
