# DEMO - kubevirt-velero-plugin

Shows how to backup and restore VMs on Openshift CNV with kubevirt-velero-plugin. 

## Prerequisities
A kubernetes cluster (might be OpenShift) with the following:
- `kubevirt` + `cdi` (CNV) 
- a CSI storage with snapshot support (OCS)
- a storage for backup files - the demo uses `minio` with `AWS s3` API

You can use  [cluster/README.md](cluster/README.md) to prepare a dev cluster.

TODO: try using *Ceph Object Gateway*

TODO: try using restic and csi

## DEMO time
0. Install the kubevirt-velero-plugin
```bash
./velero plugin add quay.io/brybacki/kubevirt-velero-plugin:0.46
sleep 15
./velero plugin get
```

1. Create some vms

```bash
oc create namespace demo
oc create -f vm/vm-velero-cirros.yaml -n demo
```

When read start and login:
```bash
virtctl start vm-demo-cirros -n demo
virtctl console vm-demo-cirros -n demo
```

After login add a file.
`echo "a change to test velero backups" >> test_file.txt`
 
TODO: describe what is that
2. Backup

`./velero backup create demobackup1 --include-namespaces demo --wait`

3. Destroy something

`k delete vm -n demo`

Try to login, to find a vm a dv or a pvc
`virtctl console vm-demo-cirros -n demo`

4. Restore
 
`./velero restore create --from-backup demobackup1 --wait`

5. Login and check the file

```bash 
virtctl console vm-demo-cirros -n demo
cat test_file.txt
```


Thanks for patience.