# DEMO - kubevirt-velero-plugin on Red Hat OpenShift Container Platfor

Shows how to backup and restore VMs on Openshift CNV with kubevirt-velero-plugin. 

## Prerequisities
An Openshift cluster with the following Installed Operators:
- OpenShift Container Storage (with Rados Gateway and volumesnapshotclass configured)
- OpenShift Virtualization
- OADP Operator

### 1. Be sure to have a Bucket configured for backup storage. This demo assumes Ceph Rados Gateway. 

Find the route and storage class:
```oc get route -n openshift-storage
ocs-storagecluster-cephobjectstore   ocs-storagecluster-cephobjectstore-openshift-storage.apps.ostest.<DOMAIN>         rook-ceph-rgw-ocs-storagecluster-cephobjectstore   <all>                             None
```
Remember the objectstore/rgw route address, this will be **<S3_URL>**: `ocs-storagecluster-cephobjectstore-openshift-storage.apps.ostest.<DOMAIN>`

Get storage class:
```oc get sc | grep bucket
ocs-storagecluster-ceph-rgw   openshift-storage.ceph.rook.io/bucket   Delete          Immediate              false                  10d
```
Create a bucket using the storage class:
```
cat bucket.yaml

apiVersion: objectbucket.io/v1alpha1
kind: ObjectBucketClaim
metadata:
  name: backup
  namespace: default
spec:
  generateBucketName: backup
  storageClassName: ocs-storagecluster-ceph-rgw

oc create -f  bucket.yaml
```

When bucket claim is bound, a bucket and a secret are created (secret has the same name as bucket claim). 
Now get the real bucket name **<BUCKET_NAME>** and credentials. Save credentials in the file.
```
oc get obc backup -o yaml | grep bucketName

oc get secret backup -o yaml | grep -w AWS_ACCESS_KEY_ID: | head -n1 | awk '{print $2}' | base64 --decode`
oc get secret backup -o yaml | grep -w AWS_SECRET_ACCESS_KEY: | head -n1 | awk '{print $2}' | base64 --decode
```
Backup credentials file follows the aws credentials format:
```
cat ./backup-credentials
[default]
aws_access_key_id = 
aws_secret_access_key = 
```
```
oc create secret generic cloud-credentials --namespace openshift-adp --from-file cloud=./backup-credentials
```
You can check ObjectBucket (follow the name from objectBucketName in the ObjectBucketClaim) to see some details like bucketPort, region etc...

### 2. Configure Velero in Openshift ADP
```yaml
apiVersion: oadp.openshift.io/v1alpha1
kind: Velero
metadata:
  name: example-velero
  namespace: openshift-adp
spec:
  volumeSnapshotLocations:
    - config:
        profile: default
        region: us-east-1
      name: default
      provider: aws
  backupStorageLocations:
    - config:
        profile: default
        region: us-east-1 # check the actual ObjectBucket to see the region used
        s3_url: <S3_URL>  # the URL from route in step 1
        s3_force_path_style: "true"
        insecure_skip_tls_verify: "true"
      credential:
        key: cloud              # the key in the secret
        name: cloud-credentials # the name of the secret object
      objectStorage:
        bucket: <BUCKET_NAME>   # oc get obc backup -o yaml | grep bucketName
        prefix: velero
      name: default
      provider: aws
      default: true
  customVeleroPlugins:
    - image: 'quay.io/kubevirt/kubevirt-velero-plugin:latest' # this is the actual plugin that we DEMO
      name: kvp
  veleroFeatureFlags:
    - EnableCSI
  defaultVeleroPlugins:
    - aws
    - csi
    - openshift
  olmManaged: true
  enableRestic: true
```

### 3. Mark any volumesnapshotclass that you want to use for velero volume snapshots (for CSI plugin).

`oc label volumesnapshotclass ocs-storagecluster-rbdplugin-snapclass velero.io/csi-volumesnapshot-class=true --overwrite=true`

### 4. Get velero CLI 

## DEMO time

### 1. Create some vms