# DEMO - kubevirt-velero-plugin

Shows how to backup and restore VMs on Openshift CNV with kubevirt-velero-plugin. 

## Prerequisities
A kubernetes cluster (might be OpenShift) with the following:
- `kubevirt` + `cdi` (CNV) 
- a CSI storage with snapshot support (OCS)
- a storage for backup files - the demo uses `minio` with `AWS s3` API

You can use  [cluster/README.md](cluster/README.md) to prepare a dev cluster. 
