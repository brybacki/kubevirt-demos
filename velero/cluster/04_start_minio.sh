#!/usr/bin/env bash

# alternative way
# https://infohub.delltechnologies.com/l/deployment-guide-dell-emc-ready-stack-for-red-hat-openshift-container-platform-4-6/installing-the-velero-server-1

docker run --privileged \
  -e MINIO_ROOT_USER=minio -e MINIO_ROOT_PASSWORD=minio123 \
  -p 9000:9000 -p 9001:9001 \
  -v $PWD/minio-data:/data:z \
   quay.io/minio/minio server /data --console-address ":9001" &







