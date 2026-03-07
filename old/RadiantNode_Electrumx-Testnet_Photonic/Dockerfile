# The Radiant Blockchain Developers
# The purpose of this image is to be able to host Radiant Node (RXD)
# Public images at: https://hub.docker.com/u/radiantcommunity
# Thanks to Bacto for detecting bugs in the code
# Build with: `docker build -t electrumx-node-testnet .`

FROM ubuntu:22.04

LABEL maintainer="code@radiant4people.com"
LABEL version="1.3.0"
LABEL description="Docker image for radiantd nodee with electrumx for photonic"

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
  libcurl4-openssl-dev \
  libboost-thread-dev \
  libevent-dev \
  libssl-dev \
  libzmq3-dev \ 
  ninja-build \
  python3 \
  python3-pip \
  libdb++-dev \
  cmake"

ENV REMOVE="\
  build-essential \
  pkg-config \
  libtool \
  git \
  autoconf \
  automake \
  ninja-build \
  cmake"

RUN apt update \ 
   && apt install --no-install-recommends -y $PACKAGES  \
   && rm -rf /var/lib/apt/lists/* \
   && git clone --depth 1 --branch v1.3.0 https://github.com/radiantblockchain/radiant-node.git \
   && cmake -GNinja radiant-node -DBUILD_RADIANT_QT=OFF -DENABLE_UPNP=OFF -DENABLE_MAN=OFF -DBUILD_RADIANT_SEEDER=OFF -DBUILD_BITCOIN_ZMQ=ON \
   && ninja \
   && ninja install \
   && rm -rf /root/* /tmp/* /var/tmp/* \
   && git clone --depth 1 --branch zerorefs https://github.com/1razoo/electrumx.git \
   && python3 -m pip install -r /root/electrumx/requirements.txt \
   && apt remove -y $REMOVE \
   && apt autoremove -y \
   && apt purge -y --auto-remove \
   && apt clean 

   ENV DAEMON_URL=http://RadiantDockerUser:RadiantDockerPassword@localhost:17332/
   ENV COIN=Radiant
   ENV NET=testnet
   ENV REQUEST_TIMEOUT=60
   ENV DB_DIRECTORY=/data/radiantnode_testnet_electrumx/electrumdb
   ENV DB_ENGINE=leveldb
   ENV SERVICES=tcp://0.0.0.0:51010,ssl://0.0.0.0:51012,wss://0.0.0.0:51002,rpc://0.0.0.0:8000
   ENV SSL_CERTFILE=/data/radiantnode_testnet_electrumx/electrumdb/server.crt
   ENV SSL_KEYFILE=/data/radiantnode_testnet_electrumx/electrumdb/server.key
   ENV HOST=""
   ENV ALLOW_ROOT=true
   ENV CACHE_MB=1500
   ENV MAX_SESSIONS=5000
   ENV MAX_SEND=10000000
   ENV MAX_RECV=10000000
   ENV COST_SOFT_LIMIT=0
   ENV COST_HARD_LIMIT=0
   
   EXPOSE 17333 51010 51012 51020
   
   COPY radiantnode_electrumx_testnet_photonic.sh /radiantnode_electrumx_testnet_photonic.sh
   
   RUN chmod 755 /radiantnode_electrumx_testnet_photonic.sh
   
   RUN mkdir -p /data
   
   VOLUME /data
   
   ENTRYPOINT ["/bin/sh", "-c" , "/radiantnode_electrumx_testnet_photonic.sh"]
