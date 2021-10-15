#!/usr/bin/env bash
#
# taken from /containerized-data-importer/cluster-sync/ephemeral_provider.sh
#

#Configure ceph storage.
kubectl apply -f ./cluster-sync/external-snapshotter
kubectl apply -f ./cluster-sync/rook-ceph/common.yaml
if kubectl get securitycontextconstraints; then
  kubectl apply -f ./cluster-sync/rook-ceph/scc.yaml
fi
kubectl apply -f ./cluster-sync/rook-ceph/operator.yaml
kubectl apply -f ./cluster-sync/rook-ceph/cluster.yaml
kubectl apply -f ./cluster-sync/rook-ceph/pool.yaml

# wait for ceph
until kubectl get cephblockpools -n rook-ceph replicapool -o jsonpath='{.status.phase}' | grep Ready; do
  ((count++)) && ((count == 120)) && echo "Ceph not ready in time" && exit 1
  if ! ((count % 6)); then
    kubectl get pods -n rook-ceph
  fi
  echo "Waiting for Ceph to be Ready, sleeping 5s and rechecking"
  sleep 5
done

kubectl patch storageclass rook-ceph-block -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

## VELERO SNAPHSOT
kubectl label volumesnapshotclass/csi-rbdplugin-snapclass velero.io/csi-volumesnapshot-class=true --overwrite=true

#kubectl get volumesnapshotclass/csi-rbdplugin-snapclass -o yaml
