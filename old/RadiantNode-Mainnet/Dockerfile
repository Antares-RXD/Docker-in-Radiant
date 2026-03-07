# The Radiant Blockchain Developers
# The purpose of this image is to be able to host Radiant Node (RXD)
# Build with: `docker build .`
# Public images at: https://hub.docker.com/u/radiantcommunity
# Thanks to Bacto for detecting bugs in the code
# CMD tail -f /dev/null

FROM ubuntu:22.04

LABEL maintainer="code@radiant4people.com"
LABEL version="1.3.0"
LABEL description="Docker image for radiantd node with wallet"

ARG DEBIAN_FRONTEND=nointeractive

WORKDIR /root

ENV PACKAGES="\
  build-essential \
  pkg-config \
  libtool \
  git \
  autoconf \
  automake \
  libevent-dev \
  libboost-chrono-dev \
  libboost-filesystem-dev \
  libboost-test-dev \
  ca-certificates \
  libboost-thread-dev \
  libevent-dev \
  libssl-dev \
  libzmq3-dev \ 
  ninja-build \
  python3 \
  libdb++-dev \
  cmake"

ENV REMOVE="\
  build-essential \
  pkg-config \
  libtool \
  git \
  autoconf \
  automake \
  ca-certificates \
  ninja-build \
  python3 \
  cmake"

RUN apt update \ 
   && apt install --no-install-recommends -y $PACKAGES  \
   && rm -rf /var/lib/apt/lists/* \
   && git clone --depth 1 --branch v1.3.0 https://github.com/radiantblockchain/radiant-node.git \
   && cmake -GNinja radiant-node -DBUILD_RADIANT_QT=OFF -DENABLE_UPNP=OFF -DENABLE_MAN=OFF -DBUILD_RADIANT_SEEDER=OFF -DBUILD_BITCOIN_ZMQ=ON \
   && ninja \
   && ninja install \
   && apt remove -y $REMOVE \
   && apt autoremove -y \
   && apt purge -y --auto-remove \
   && apt clean \
   && rm -rf /root/* /tmp/* /var/tmp/*
  
COPY radiantnode.sh /radiantnode.sh

RUN chmod 755 /radiantnode.sh

EXPOSE 7333

RUN mkdir -p /data

VOLUME /data

ENTRYPOINT ["/bin/sh", "-c" , "/radiantnode.sh"]
