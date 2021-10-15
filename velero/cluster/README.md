# DEV Cluster

## 1. Install CRC
Download and install the latest -> https://console.redhat.com/openshift/create/local
This demo was tested on: https://developers.redhat.com/content-gateway/file/pub/openshift-v4/clients/crc/1.33.1/crc-linux-amd64.tar.xz

```bash
https://developers.redhat.com/content-gateway/file/pub/openshift-v4/clients/crc/1.33.1/crc-linux-amd64.tar.xz
tar -xvf crc-linux-amd64.tar.xz
cd crc-linux-1.33.1-amd64
sudo install crc /usr/local/bin
```

Run [01_install_crc](01_install_crc.sh) script:

`./01_install_crc.sh`

```bash
eval $(crc oc-env)
oc login -u kubeadmin -p <PASSWORD> https://api.crc.testing:6443
```

Coffee time!

## 2. Install storage, 
OCS available from operator hub (on CRC) has to big requirements so we just install ceph

Run [02_install_storage](02_install_storage.sh) script:

`./02_install_storage.sh`

## 3. Install kubevirt and cdi
CNV available from operator hub (on CRC) is to old. Need higher version.

Run [03a_install_kubevirt](03a_install_kubevirt.sh) and [03b_install_cdi](03b_install_cdi.sh) scripts:

```bash 
./03a_install_kubevirt.sh
./03b_install_cdi.sh
```

## 4. Backup location - Minio

Minio can be started inside the cluster or outside. 
I choose outside, so I can have a restore to new cluster, 
when the old cluster is destroyed and deleted.

 - start minio: [04_start_minio.sh](04_start_minio.sh)
 - add bucket
```bash
wget https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
./mc config host add velero http://localhost:9000 minio minio123 ; ./mc mb -p velero/velero
```

Now you have to get the ip of the machine where the minio is installed. It is needed for next step. 

## 5. Velero

Run [05_install_velero](05_install_velero.sh) script, substitute `<IP_OF_MINIO>` with correct ip address.

`export MINIO_URL=http://<IP_OF_MINIO>:9000 ./05_install_velero.sh`

