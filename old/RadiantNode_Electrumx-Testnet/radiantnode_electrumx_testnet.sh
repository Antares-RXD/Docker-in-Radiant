#!/usr/bin/env bash

if [[ ! -f /data/radiantnode_testnet_electrumx/radiant.conf ]]; then
echo -e "Creating config file..."
mkdir /data/radiantnode_testnet_electrumx > /dev/null 2>&1
touch /data/radiantnode_testnet_electrumx/radiant.conf
cat <<- EOF > /data/radiantnode_testnet_electrumx/radiant.conf
rpcuser=RadiantDockerUser
rpcpassword=RadiantDockerPassword
listen=1
daemon=1
server=1
testnet=1
dbcache=2
txindex=1
rest=1
daemon=1
[test]
port=17333
rpcport=17332
rpcworkqueue=1024
rpcthreads=128
addnode=194.163.159.47
addnode=217.182.174.119
rpcallowip=0.0.0.0/0
EOF
fi


if [[ ! -f /data/radiantnode_testnet_electrumx/electrumdb/server.key ]]; then
  mkdir -p /data/radiantnode_testnet_electrumx/electrumdb 2>&1
  cd /data/radiantnode_testnet_electrumx/electrumdb
  openssl genrsa -out server.key 2048 > /dev/null 2>&1
  openssl req -new -key server.key -out server.csr -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=radiant4people.com" > /dev/null 2>&1
  openssl x509 -req -days 1825 -in server.csr -signkey server.key -out server.crt > /dev/null 2>&1
fi

bash -c "radiantd -datadir=/data/radiantnode_testnet_electrumx && python3 /root/electrumx/electrumx_server"