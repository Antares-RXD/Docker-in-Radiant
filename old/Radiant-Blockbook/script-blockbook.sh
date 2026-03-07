#!/usr/bin/env bash

if [[ ! -d /DATA/backend ]]; then
  mkdir -p /DATA/backend
fi

if [[ ! -d /DATA/blockbook ]]; then
  mkdir -p /DATA/blockbook
fi


/opt/coins/nodes/radiant/radiantd \
    -datadir=/DATA/backend \
    -conf=/opt/coins/nodes/radiant/radiant.conf

cd /opt/coins/blockbook/radiant/

/opt/coins/blockbook/radiant/bin/blockbook \
    -sync \
    -blockchaincfg=/opt/coins/blockbook/radiant/config/blockchaincfg.json \
    -certfile=/opt/coins/blockbook/radiant/cert/blockbook \
    -log_dir=/data/blockbook/logs \
    -datadir=/DATA/blockbook/db \
    -explorer= \
    -internal=:9200 \
    -public=:9201 \
    -resyncindexperiod=5000 \
    -resyncmempoolperiod=5000 \
    -workers=1 \
    -logtostderr

