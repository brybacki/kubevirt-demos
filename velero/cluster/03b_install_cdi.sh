#!/usr/bin/env bash

KUBEVIRT_DEPLOYMENT_TIMEOUT=${KUBEVIRT_DEPLOYMENT_TIMEOUT:-480}
CDI_VERSION=${CDI_VERSION:-v1.38.0}

# Deploy CDI
kubectl apply -f https://github.com/kubevirt/containerized-data-importer/releases/download/${CDI_VERSION}/cdi-operator.yaml
kubectl apply -f https://github.com/kubevirt/containerized-data-importer/releases/download/${CDI_VERSION}/cdi-cr.yaml
kubectl wait -n cdi deployment/cdi-operator   --for=condition=Available --timeout=${KUBEVIRT_DEPLOYMENT_TIMEOUT}s