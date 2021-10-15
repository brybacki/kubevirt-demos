#!/usr/bin/env bash

PLUGINS=velero/velero-plugin-for-aws:v1.0.0
PLUGINS="${PLUGINS},${CSI_PLUGIN}"
MINIO_URL=${MINIO_URL:-http://192.168.8.3:9000}

#./velero install \
#    --provider aws \
#    --plugins velero/velero-plugin-for-aws:v1.0.0,velero/velero-plugin-for-csi:main \
#    --bucket velero \
#    --secret-file /home/brybacki/ws/kubevirt-velero-plugin/hack/velero/credentials-velero \
#    --use-volume-snapshots=true \
#    --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://minio.velero.svc:9000 \
#    --snapshot-location-config region="default"
#    --features=EnableCSI
wget https://github.com/vmware-tanzu/velero/releases/download/v1.6.3/velero-v1.6.3-linux-amd64.tar.gz
tar zxf velero-v1.6.3-linux-amd64.tar.gz
chmod +x velero-v1.6.3-linux-amd64/velero

./velero-v1.6.3-linux-amd64/velero install \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.0.0,velero/velero-plugin-for-csi:main \
    --bucket velero \
    --secret-file /home/brybacki/ws/kubevirt-velero-plugin/hack/velero/credentials-velero \
    --use-volume-snapshots=true \
    --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=${MINIO_URL} \
    --snapshot-location-config region="default" \
    --features=EnableCSI

kubectl wait -n velero deployment/velero --for=condition=Available --timeout=30s

