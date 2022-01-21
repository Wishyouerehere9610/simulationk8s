## k8s installation

### prepare

1. 6 nodes with centos stream 8
   TODO: 
2. change hostname
    * ```shell
      for HOST in "nebula-vis-01" \
              "nebula-vis-02" \
              "nebula-vis-03" \
              "nebula-vis-04" \
              "nebula-vis-05" \
              "nebula-vis-06"
      do
          ssh -o "UserKnownHostsFile /dev/null" root@$HOST "hostnamectl set-hostname $HOST"
      done
      ```
3. configure hosts for all nodes
    * ```shell
      cat >> /etc/hosts <<EOF
      10.101.16.60 nebula-vis-01
      10.101.16.61 nebula-vis-02
      10.101.16.62 nebula-vis-03
      10.101.16.63 nebula-vis-04
      10.101.16.64 nebula-vis-05
      10.101.16.65 nebula-vis-06
      EOF
      ```
4. configure repositories
    * remove all repo configuration
        + ```shell
          rm -rf /etc/yum.repos.d/*
          ```
    * copy [all.in.one.8.repo](resources/all.in.one.8.repo.md) as file `/etc/yum.repos.d/all.in.one.repo`
5. configure ntp
    * ```shell
      dnf install -y chrony && systemctl enable chronyd && systemctl start chronyd \
         && chronyc sources && chronyc tracking \
         && timedatectl set-timezone 'Asia/Shanghai'
      ```
6. prepare lvm
    * remove `/dev/mapper/data-00`
        + ```shell
          umount /dev/mapper/data-00 && lvremove /dev/mapper/data-00
          ```
    * edit `/etc/fstab` and remove the line which mount device into `/data`
    * re-create `/dev/mapper/data-00`
        + ```shell
          echo "/dev/mapper/data-00 /data xfs defaults 0 0" >> /etc/fstab
          lvcreate -L 200G -n 00 data
          mkfs.xfs /dev/mapper/data-00
          mount -a
          ```
    * create `/dev/mapper/data-rookmonitor` and `/dev/mapper/data-rookdata`
        + ```shell
          lvcreate -L 50G -n rookmonitor data
          mkfs.xfs /dev/mapper/data-rookmonitor
          lvcreate -L 773G -n rookdata data
          ```
7. stop and disable firewalld
    * ```shell
      systemctl stop firewalld && systemctl disable firewalld
      ```
8. install base environment
    * copy [setup.base.sh](resources/setup.base.sh.md) as file `/tmp/setup.base.sh`
    * ```shell
      bash /tmp/setup.base.sh
      ```

### install master

1. choose `k8s-test-01.lab.zjvis.net` as master node
2. initialize master
    * ```shell
      kubeadm init --pod-network-cidr=172.21.0.0/20 --image-repository registry.aliyuncs.com/google_containers
      systemctl restart kubelet
      ```
3. copy k8s config
    * ```shell
      mkdir -p $HOME/.kube
      cp /etc/kubernetes/admin.conf $HOME/.kube/config
      chown $(id -u):$(id -g) $HOME/.kube/config
      ```
4. install `calico` to k8s cluster
    * prepare [calico.install.yaml](resources/calico.install.yaml)
    * ```shell
      kubectl apply -f https://resource.static.zjvis.net/calico/tigera-operator-20211224.yaml
      kubectl apply -f calico.install.yaml
      ```
5. wait for all pods in kube-system to be ready
    * ```shell
      kubectl -n calico-system wait --for=condition=ready pod --all
      kubectl -n kube-system wait --for=condition=ready pod --all
      kubectl wait --for=condition=ready node --all
      ```
6. download specific helm binary
    * ```shell
      # mirror of https://get.helm.sh
      BASE_URL=https://resource.static.zjvis.net/binary/helm
      curl -LO ${BASE_URL}/helm-v3.6.2-linux-amd64.tar.gz
      tar zxvf helm-v3.6.2-linux-amd64.tar.gz linux-amd64/helm \
          && mkdir -p $HOME/bin \
          && mv linux-amd64/helm $HOME/bin/helm \
          && rm -rf linux-amd64/ helm-v3.6.2-linux-amd64.tar.gz
      ```

### install worker

* choose `k8s-test-02.lab.zjvis.net` and `k8s-test-03.lab.zjvis.net` as worker
* ```shell
  $(ssh nebula-vis-01 "kubeadm token create --print-join-command")
  ```
* NOTE: no need to configure password less ssh login, just type your password once
* wait for all pods in kube-system to be ready
    + ```shell
      kubectl -n calico-system wait --for=condition=ready pod --all
      kubectl -n kube-system wait --for=condition=ready pod --all
      kubectl wait --for=condition=ready node --all
      ```

### remove taint of master

1. remove `node-role.kubernetes.io/master:NoSchedule`
    * ```shell
      kubectl taint nodes ops-test-01.lab.zjvis.net node-role.kubernetes.io/master:NoSchedule-
      ```

### install rook-ceph to provide storage class

1. what we have
    * `/dev/mapper/data-rookmonitor` which have initialized as `xfs` in every node
    * `/dev/mapper/data-rookdata` in every node
2. clone `sig-storage-local-static-provisioner` from github
    * ```shell
      git clone --single-branch --branch v2.4.0 https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner.git
     ```
    * NOTE: clone locally and copy to the master node with `scp`
3. load docker images at every node
    + ```shell
      mkdir docker-images && cd docker-images
      BASE_URL="https://resource.static.zjvis.net/docker-images"
      for IMAGE in "k8s.gcr.io_sig-storage_csi-attacher_v3.2.1.dim" \
          "k8s.gcr.io_sig-storage_csi-node-driver-registrar_v2.2.0.dim" \
          "k8s.gcr.io_sig-storage_csi-provisioner_v2.2.2.dim" \
          "k8s.gcr.io_sig-storage_csi-resizer_v1.2.0.dim" \
          "k8s.gcr.io_sig-storage_csi-snapshotter_v4.1.1.dim" \
          "k8s.gcr.io_sig-storage_local-volume-provisioner_v2.4.0.dim" \
          "quay.io_ceph_ceph_v16.2.5.dim" \
          "quay.io_cephcsi_cephcsi_v3.4.0.dim" \
          "rook_ceph_v1.7.3.dim"
      do
          curl -LO $BASE_URL/$IMAGE
          docker image load -i $IMAGE
      done
      ```
4. prepare storage class named `rook-monitor` by `local-static-provisioner`
    * prepare resources at every node
        + ```shell
          HOSTNAME=$(hostname)
          PREFIX=${HOSTNAME:0:11}
          mkdir -p /local-static-provisioner/rook-ceph/monitor/rook-$PREFIX-01
          echo "/dev/mapper/data-rookmonitor /local-static-provisioner/rook-ceph/monitor/rook-$PREFIX-01 xfs defaults 0 0" >> /etc/fstab
          mount -a
          ```
    * copy [local.rook.monitor.values.yaml](resources/local.rook.monitor.values.yaml.md)
      as `/tmp/local.rook.monitor.values.yaml`
    * setup
        + ```shell
          helm install \
             --create-namespace --namespace local-disk \
             disk-rook-monitor \
             sig-storage-local-static-provisioner/helm/provisioner/ \
             --values /tmp/local.rook.monitor.values.yaml \
             --atomic
          ```
5. prepare storage class named `rook-data` by `local-static-provisioner`
    * prepare resources at every node
        + ```shell
          HOSTNAME=$(hostname)
          PREFIX=${HOSTNAME:0:11}
          mkdir -p /local-static-provisioner/rook-ceph/data
          ln -s /dev/mapper/data-rookdata /local-static-provisioner/rook-ceph/data/rook-$PREFIX-01
          ```
    * copy [local.rook.data.values.yaml](resources/local.rook.data.values.yaml.md) as `/tmp/local.rook.data.values.yaml`
    * setup
        + ```shell
          helm install \
             --create-namespace --namespace local-disk \
             disk-rook-data \
             sig-storage-local-static-provisioner/helm/provisioner/ \
             --values /tmp/local.rook.data.values.yaml \
             --atomic
          ```
    * check pod healthy and pvs created
        + ```shell
          kubectl -n local-disk get pod
          kubectl -n local-disk wait --for=condition=ready pod --all
          kubectl get pv
          ```
6. create rook operator by helm
    * copy [rook.ceph.operator.values.yaml](resources/rook.ceph.operator.values.yaml.md)
      as `/tmp/rook.ceph.operator.values.yaml`
    * setup
        + ```shell
          helm install \
              --create-namespace --namespace rook-ceph \
              my-rook-ceph-operator \
              rook-ceph \
              --repo https://charts.rook.io/release \
              --version 1.7.3 \
              --values /tmp/rook.ceph.operator.values.yaml \
              --atomic
          ```
    * check pod healthy
        + ```shell
          kubectl -n rook-ceph get pod
          kubectl -n rook-ceph wait --for=condition=ready pod --all
          ```
7. create `CephCluster`
    * copy [cluster-on-pvc.yaml](resources/cluster-on-pvc.yaml.md) as `/tmp/cluster-on-pvc.yaml`
    * setup
        + ```shell
          kubectl -n rook-ceph apply -f /tmp/cluster-on-pvc.yaml
          ```
    * check healthy
        + ```shell
          # waiting for osd(s) to be ready, 3 pod named rook-ceph-osd-$index-... are expected to be Running
          kubectl -n rook-ceph get pod -w
          ```
8. install `toolbox`
    * copy [toolbox.yaml](resources/toolbox.yaml.md) as `/tmp/toolbox.yaml`
    * setup
        + ```shell
          kubectl -n rook-ceph apply -f /tmp/toolbox.yaml
          ```
    * check ceph status
        + ```shell
          # 3 osd(s), 3 mon(s) and 1 pool are expected
          # pgs(if exists any) should be active and clean
          kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- ceph status
          ```
9. create ceph filesystem and storage class
    * copy [ceph.filesystem.yaml](resources/ceph.filesystem.yaml.md) as `/tmp/ceph.filesystem.yaml`
    * copy [ceph.storage.class.yaml](resources/ceph.storage.class.yaml.md) as `/tmp/ceph.storage.class.yaml`
    * setup
        + ```shell
          kubectl -n rook-ceph apply -f /tmp/ceph.filesystem.yaml
          kubectl -n rook-ceph apply -f /tmp/ceph.storage.class.yaml
          ```
    * check ceph status
        + ```shell
          # pgs(if exists any) should be active and clean
          kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- ceph status
          # one file system, which is active, is expected
          # in addition, check available storage size
          kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- ceph fs status
          ```
10. install mariadb to test
    * copy [maria.db.values.yaml](resources/maria.db.values.yaml.md) as `/tmp/maria.db.values.yaml`
    * setup
        + ```shell
          helm install \
              --create-namespace --namespace database \
              maria-db-test \
              https://resource.static.zjvis.net/charts/charts.bitnami.com/bitnami/mariadb-9.4.2.tgz
              --values /tmp/maria.db.values.yaml \
              --atomic \
              --timeout 600s
          ```
    * connect to maria-db
        + ```shell
          MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace database maria-db-test-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
          kubectl run maria-db-test-mariadb-client \
              --rm --tty -i \
              --restart='Never' \
              --image docker.io/bitnami/mariadb:10.5.12-debian-10-r32 \
              --namespace database \
              --env MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
              --command -- bash
          ```
    * connect to maria-db with in the pod
        + ```shell
          echo "show databases;" | mysql -h maria-db-test-mariadb.database.svc.cluster.local -uroot -p$MYSQL_ROOT_PASSWORD my_database
          ```
    * checking pvc and pv
        + ```shell
          kubectl -n database get pvc
          kubectl get pv
          ```
