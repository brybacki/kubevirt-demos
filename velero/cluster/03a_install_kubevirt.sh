#!/usr/bin/env bash

KUBEVIRT_DEPLOYMENT_TIMEOUT=${KUBEVIRT_DEPLOYMENT_TIMEOUT:-480}
KUBEVIRT_VERSION=${KUBEVIRT_VERSION:-v0.44.2}

# Deploy KubeVirt
kubectl apply -f https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-operator.yaml
kubectl apply -f https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-cr.yaml
kubectl wait -n kubevirt deployment/virt-operator   --for=condition=Available --timeout=${KUBEVIRT_DEPLOYMENT_TIMEOUT}s

