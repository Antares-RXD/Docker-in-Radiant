# Stage 1: Build environment
FROM ubuntu:22.04 AS builder

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /build

# Build dependencies and Radiant Core
RUN apt-get update && apt-get install -y --no-install-recommends \
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
  libboost-thread-dev \
  libssl-dev \
  libzmq3-dev \
  libdb++-dev \
  ninja-build \
  python3 \
  cmake \
  ca-certificates \
  && git clone --depth 1 https://github.com/Antares-RXD/Radiant-Core.git src \
  && cd src \
  && cmake -GNinja -B build -DBUILD_RADIANT_QT=OFF -DENABLE_UPNP=OFF -DENABLE_MAN=OFF -DBUILD_RADIANT_SEEDER=OFF -DBUILD_BITCOIN_ZMQ=ON \
  && ninja -C build \
  && ninja -C build install \
  && cd .. \
  && rm -rf src \
  && rm -rf /var/lib/apt/lists/*

# Stage 2: Runtime environment
FROM ubuntu:22.04

LABEL maintainer="code@radiant4people.com"
LABEL version="1.0.0"
LABEL description="Docker image for Radiant Core node with wallet - Optimized"

ARG DEBIAN_FRONTEND=noninteractive

# Install runtime dependencies only
RUN apt-get update && apt-get install -y --no-install-recommends \
  libevent-2.1-7 \
  libevent-pthreads-2.1-7 \
  libboost-chrono1.74.0 \
  libboost-filesystem1.74.0 \
  libboost-thread1.74.0 \
  libssl3 \
  libzmq5 \
  libdb5.3++ \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /root

# Copy binaries from builder stage
COPY --from=builder /usr/local/bin/radiant* /usr/local/bin/

COPY radiantnode.sh /radiantnode.sh

RUN chmod 755 /radiantnode.sh

EXPOSE 7333

RUN mkdir -p /data

VOLUME /data

ENTRYPOINT ["/bin/sh", "-c" , "/radiantnode.sh"]
