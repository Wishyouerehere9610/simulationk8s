## k8s installation

### prepare

1. 6 nodes with centos stream 8
   + master: TH51-10.0.0.128
   + worker1: TH52-10.0.0.129
   + worker2: TH53-10.0.0.130
   + worker3: TH54-10.0.0.131
2. change hostname
    * ```shell
      for HOST in "TH51" \
          "TH52" \
          "TH53" \
          "TH54" 
      do
          ssh -o "UserKnownHostsFile /dev/null" root@$HOST "hostnamectl set-hostname $HOST"
      done
      ```
3. configure hosts for all nodes
    * ```shell
      cat >> /etc/hosts <<EOF
      10.0.0.128 k8s-01
      10.105.20.12 k8s-02
      10.105.20.13 k8s-03
      10.105.20.14 k8s-04
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
    * create `/dev/mapper/cs-docker`
        + ```shell
          echo "/dev/mapper/cs-docker /var/lib/docker xfs defaults 0 0" >> /etc/fstab
          lvcreate -L 300G -n docker cs
          mkfs.xfs /dev/mapper/cs-docker
          mkdir /var/lib/docker && chmod 755 /var/lib/docker && mount -a
          ```
    * create `/dev/mapper/cs-rookmonitor` and `/dev/mapper/cs-rookdata`
        + ```shell
          lvcreate -L 100G -n rookmonitor cs
          mkfs.xfs /dev/mapper/cs-rookmonitor
          lvcreate -L 1536G -n rookdata cs
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
9. prepare images for every node
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource.static.zjvis.net/docker-images"
      for IMAGE in "docker.io_calico_apiserver_v3.21.2.dim" \
          "docker.io_calico_pod2daemon-flexvol_v3.21.2.dim" \
          "docker.io_calico_cni_v3.21.2.dim" \
          "docker.io_calico_typha_v3.21.2.dim" \
          "docker.io_calico_kube-controllers_v3.21.2.dim" \
          "docker.io_calico_node_v3.21.2.dim" \
          "docker.io_k8s.gcr.io_kube-apiserver_v1.23.3.dim" \
          "docker.io_k8s.gcr.io_pause_3.6.dim" \
          "docker.io_k8s.gcr.io_kube-controller-manager_v1.23.3.dim" \
          "docker.io_k8s.gcr.io_coredns_coredns_v1.8.6.dim" \
          "docker.io_k8s.gcr.io_kube-proxy_v1.23.3.dim" \
          "docker.io_k8s.gcr.io_etcd_3.5.1-0.dim" \
          "docker.io_k8s.gcr.io_kube-scheduler_v1.23.3.dim" \
          "docker.io_registry_2.7.1.dim" \
          "quay.io_tigera_operator_v1.23.3.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE
      done
      ```

### install master

1. choose `k8s-01.lab.zjvis.net` as master node
2. initialize master
    * ```shell
      kubeadm init --pod-network-cidr=172.21.0.0/20 \
          && systemctl restart kubelet
      ```
3. copy k8s config
    * ```shell
      mkdir -p $HOME/.kube
      cp /etc/kubernetes/admin.conf $HOME/.kube/config
      chown $(id -u):$(id -g) $HOME/.kube/config
      ```
4. install `calico` to k8s cluster
    * prepare [calico.install.yaml](resources/calico.install.yaml) as `/tmp/calico.install.yaml`
    * ```shell
      kubectl apply -f https://resource.static.zjvis.net/calico/tigera-operator-20211224.yaml
      kubectl apply -f /tmp/calico.install.yaml
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

### install workers

* choose `k8s-02.lab.zjvis.net` ~ `k8s-08.lab.zjvis.net` as workers
* ```shell
  $(ssh k8s-01 "kubeadm token create --print-join-command")
  ```
* wait for all pods in kube-system to be ready
    + ```shell
      kubectl -n calico-system wait --for=condition=ready pod --all
      kubectl -n kube-system wait --for=condition=ready pod --all
      kubectl wait --for=condition=ready node --all
      ```

### install rook-ceph to provide storage class

1. what we have
    * `/dev/mapper/cs-rookmonitor` which have initialized as `xfs` in every node
    * `/dev/mapper/cs-rookdata` in every node
2. load docker images at every node
    + ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
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
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE
      done
      ```
3. prepare storage class named `rook-monitor` by `local-static-provisioner`
    * prepare resources at every node except master node
        + ```shell
          HOSTNAME=$(hostname)
          PREFIX=${HOSTNAME:0:11}
          mkdir -p /local-static-provisioner/rook-ceph/monitor/rook-$PREFIX-01
          echo "/dev/mapper/cs-rookmonitor /local-static-provisioner/rook-ceph/monitor/rook-$PREFIX-01 xfs defaults 0 0" >> /etc/fstab
          mount -a
          ```
    * copy [local.rook.monitor.values.yaml](resources/local.rook.monitor.values.yaml.md)
      as `/tmp/local.rook.monitor.values.yaml`
    * setup
        + ```shell
          helm install \
             --create-namespace --namespace local-disk \
             disk-rook-monitor \
             https://resource.static.zjvis.net/charts/others/sig-storage-local-static-provisioner.v2.4.0.tar.gz \
             --values /tmp/local.rook.monitor.values.yaml \
             --atomic
          ```
4. prepare storage class named `rook-data` by `local-static-provisioner`
    * prepare resources at every node except master
        + ```shell
          HOSTNAME=$(hostname)
          PREFIX=${HOSTNAME:0:11}
          mkdir -p /local-static-provisioner/rook-ceph/data
          ln -s /dev/mapper/cs-rookdata /local-static-provisioner/rook-ceph/data/rook-$PREFIX-01
          ```
    * copy [local.rook.data.values.yaml](resources/local.rook.data.values.yaml.md) as `/tmp/local.rook.data.values.yaml`
    * setup
        + ```shell
          helm install \
             --create-namespace --namespace local-disk \
             disk-rook-data \
             https://resource.static.zjvis.net/charts/others/sig-storage-local-static-provisioner.v2.4.0.tar.gz \
             --values /tmp/local.rook.data.values.yaml \
             --atomic
          ```
    * check pod healthy and pvs created
        + ```shell
          kubectl -n local-disk get pod
          kubectl -n local-disk wait --for=condition=ready pod --all
          kubectl get pv
          ```
5. create rook operator by helm
    * copy [rook.ceph.operator.values.yaml](resources/rook.ceph.operator.values.yaml.md)
      as `/tmp/rook.ceph.operator.values.yaml`
    * setup
        + ```shell
          helm install \
              --create-namespace --namespace rook-ceph \
              my-rook-ceph-operator \
              https://resource.static.zjvis.net/charts/charts.rook.io/release/rook-ceph-v1.7.3.tgz \
              --values /tmp/rook.ceph.operator.values.yaml \
              --atomic
          ```
    * check pod healthy
        + ```shell
          kubectl -n rook-ceph get pod
          kubectl -n rook-ceph wait --for=condition=ready pod --all
          ```
6. create `CephCluster`
    * copy [cluster-on-pvc.yaml](resources/cluster-on-pvc.yaml.md) as `/tmp/cluster-on-pvc.yaml`
    * setup
        + ```shell
          kubectl -n rook-ceph apply -f /tmp/cluster-on-pvc.yaml
          ```
    * check healthy
        + ```shell
          # waiting for osd(s) to be ready, 7 pod named rook-ceph-osd-$index-... are expected to be Running
          kubectl -n rook-ceph get pod -w
          ```
7. install `toolbox`
    * copy [toolbox.yaml](resources/toolbox.yaml.md) as `/tmp/toolbox.yaml`
    * setup
        + ```shell
          kubectl -n rook-ceph apply -f /tmp/toolbox.yaml
          ```
    * check ceph status
        + ```shell
          # 7 osd(s) and 3 mon(s)
          # pgs(if exists any) should be active and clean
          kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- ceph status
          ```
8. create ceph filesystem and storage class
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
          # 1 pool are expected
          kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- ceph fs status
          ```
9. install mariadb to test
    * copy [maria.db.values.yaml](resources/maria.db.values.yaml.md) as `/tmp/maria.db.values.yaml`
    * load docker images at every node
        + ```shell
          DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
          BASE_URL="https://resource.static.zjvis.net/docker-images"
          for IMAGE in "docker.io_bitnami_mariadb_10.5.12-debian-10-r0.dim"
          do
              IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
              if [ ! -f $IMAGE_FILE ]; then
                  TMP_FILE=$IMAGE_FILE.tmp \
                      && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                      && mv $TMP_FILE $IMAGE_FILE
              fi
              docker image load -i $IMAGE_FILE
          done
          ```
    * setup
        + ```shell
          helm install \
              --create-namespace --namespace database \
              maria-db-test \
              https://resource.static.zjvis.net/charts/charts.bitnami.com/bitnami/mariadb-9.4.2.tgz \
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
              --image docker.io/bitnami/mariadb:10.5.12-debian-10-r0 \
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
10. uninstall mariadb to test
    * ```shell
      helm -n database uninstall maria-db-test \
          && kubectl -n database delete pvc maria-db-test-mariadb-0
      kubectl delete namespace database
      ```
    * checking pv
        + ```shell
          kubectl get pv
          ```
