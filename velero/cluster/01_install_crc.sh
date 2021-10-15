#!/usr/bin/env bash

# wget https://developers.redhat.com/content-gateway/file/pub/openshift-v4/clients/crc/1.33.1/crc-linux-amd64.tar.xz
# tar -xvf crc-linux-amd64.tar.xz
# cd crc-linux-1.33.1-amd64
# sudo install crc /usr/local/bin

crc config set memory 24576
crc config set cpus 8
crc config set enable-cluster-monitoring true
crc setup
crc start --disk-size 60
