#!/usr/bin/env bash

if [[ ! -f /data/radiantnode/radiant.conf ]]; then
echo -e "Creating config file..."
mkdir /data/radiantnode > /dev/null 2>&1
touch /data/radiantnode/radiant.conf
cat <<- EOF > /data/radiantnode/radiant.conf
rpcuser=${RPC_USER:-RadiantDockerUser}
rpcpassword=${RPC_PASS:-RadiantDockerPassword}
listen=1
daemon=0
server=1
rest=1
dbcache=10
txindex=1
rpcworkqueue=1024
rpcthreads=64
rpcallowip=0.0.0.0/0
EOF
fi

bash -c "radiantd -datadir=/data/radiantnode"