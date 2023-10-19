# k8s-1.25.6 installation 

## node 
* master: `8C16G` `虚拟机` `无GPU`
    + `192.168.31.70 calico-00`
* worker: `4C8G` `虚拟机` `无GPU`
    + `192.168.31.71 calico-01`
    + `192.168.31.72 calico-02`
    + `192.168.31.73 calico-03`

## install base environment
1. configure `/etc/hosts` for all nodes
    * ```shell
      cat >> /etc/hosts <<EOF
      192.168.31.70 calico-00
      192.168.31.71 calico-01
      192.168.31.72 calico-02
      192.168.31.73 calico-03
      EOF
      ```
2. configure repositories for all nodes
    * remove all repo configuration
        + ```shell
          rm -rf /etc/yum.repos.d/*
          ```
    * prepare [aliyun.centos.7.repo](resources/aliyun.centos.7.repo.md) as file `/etc/yum.repos.d/aliyun.centos.7.repo`
3. configure ntp for all nodes
    * ```shell
      yum install -y chrony && systemctl enable chronyd && systemctl start chronyd \
         && chronyc sources && chronyc tracking \
         && timedatectl set-timezone 'Asia/Shanghai'
      ```
4. stop and disable firewalld
    * ```shell
      systemctl stop firewalld && systemctl disable firewalld
      ```
5. install k8s base environment
    * prepare [setup.base.sh](resources/setup.base.sh.md) as file `/tmp/setup.base.sh`
    * ```shell
      bash /tmp/setup.base.sh
      ```
6. prepare images for all nodes
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource.cnconti.cc/docker-images"
      for IMAGE in "docker.io_calico_apiserver_v3.25.0.dim" \
          "docker.io_calico_cni_v3.25.0.dim" \
          "docker.io_calico_csi_v3.25.0.dim" \
          "docker.io_calico_ctl_v3.25.0.dim" \
          "docker.io_calico_kube-controllers_v3.25.0.dim" \
          "docker.io_calico_node-driver-registrar_v3.25.0.dim" \
          "docker.io_calico_node_v3.25.0.dim" \
          "docker.io_calico_pod2daemon-flexvol_v3.25.0.dim" \
          "docker.io_calico_typha_v3.25.0.dim" \
          "docker.io_registry.k8s.io_coredns_coredns_v1.9.3.dim" \
          "docker.io_registry.k8s.io_etcd_3.5.6-0.dim" \
          "docker.io_registry.k8s.io_kube-apiserver_v1.25.6.dim" \
          "docker.io_registry.k8s.io_kube-controller-manager_v1.25.6.dim" \
          "docker.io_registry.k8s.io_kube-proxy_v1.25.6.dim" \
          "docker.io_registry.k8s.io_kube-scheduler_v1.25.6.dim" \
          "docker.io_registry.k8s.io_pause_3.8.dim" \
          "quay.io_tigera_operator_v1.29.0.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          ctr -n k8s.io i import $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      ```

## install k8s-master
1. choose `calico-00` as master node
2. initialize k8s-master
    * ```shell
      kubeadm init --pod-network-cidr=172.21.0.0/20 --kubernetes-version v1.25.6 \
          && systemctl restart kubelet
      ```
3. configure `kube-config` for master
    * ```shell
      mkdir -p $HOME/.kube
      cp /etc/kubernetes/admin.conf $HOME/.kube/config
      chown $(id -u):$(id -g) $HOME/.kube/config
      ```
4. download specific helm binary
    * ```shell
      BASE_URL=https://resource.cncnoti.cc/binary/helm
      curl -LO ${BASE_URL}/helm-v3.9.4-linux-amd64.tar.gz
      tar zxvf helm-v3.9.4-linux-amd64.tar.gz linux-amd64/helm \
          && mkdir -p $HOME/bin \
          && mv linux-amd64/helm $HOME/bin/helm \
          && rm -rf linux-amd64/ helm-v3.9.4-linux-amd64.tar.gz
      ```
5. install `tigera-operator` for k8s-cluster
    * prepare [tigera-operator.values.yaml](resources/tigera-operator.values.yaml.md) as file `/tmp/tigera-operator.values.yaml`
    * ```shell
      helm install \
         --create-namespace --namespace calico-system \
         tigera-operator \
         https://resource.cnconti.cc/charts/projectcalico.docs.tigera.io/charts/tigera-operator/tigera-operator-v3.25.0.tgz \
         --values /tmp/tigera-operator.values.yaml \
         --atomic
      ```
6. wait for all pods in kube-system to be ready
    * ```shell
      kubectl -n calico-system wait --for=condition=ready pod --all
      kubectl -n kube-system wait --for=condition=ready pod --all
      kubectl wait --for=condition=ready node --all
      ```

## install k8s-worker
1. choose `calico-01` ~ `calico-03` as k8s-worker
    * ```shell
      $(ssh calico-00 "kubeadm token create --print-join-command")
      ```
2. check all nodes to be ready
    * ```shell
      kubectl get node
      ```
3. wait for all pods in kube-system to be ready
    * ```shell
       kubectl -n calico-system wait --for=condition=ready pod --all
       kubectl -n kube-system wait --for=condition=ready pod --all
       kubectl wait --for=condition=ready node --all
       ```

## install k8s-storage

### rook-ceph
* [rook-ceph-installation](rook-ceph-installation.md) `optional`

### nfs-external-nas
1. prepare images for all nodes
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource.cnconti.cc/docker-images"
      for IMAGE in "k8s.gcr.io_sig-storage_nfs-subdir-external-provisioner_v4.0.2.dim" \
          "docker.io_bitnami_mariadb_10.5.12-debian-10-r0.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          ctr -n k8s.io i import $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      ```
2. prepare [nfs.provisioner.values.yaml](resources/nfs.provisioner.values.yaml.md) as file `/tmp/nfs.provisioner.values.yaml`
3. install `nfs-provisioner` by helm
    * ```shell
      helm install \
          --create-namespace --namespace nfs-provisioner \
          my-nfs-subdir-external-provisioner \
          https://resource.cnconti.cc/charts/kubernetes-sigs.github.io/nfs-subdir-external-provisioner/nfs-subdir-external-provisioner-4.0.14.tgz \
          --values /tmp/nfs.provisioner.values.yaml \
          --atomic
      ```

## test k8s-cluster and k8s-storage(nfs)
1. install `mariadb-test`
    * prepare [mariadb-test.values.yaml](resources/mariadb-test.values.yaml.md) as file `/tmp/mariadb-test.values.yaml`
    * ```shell
      helm install \
          --create-namespace --namespace test \
          mariadb-test \
          https://resource.cnconti.cc/charts/charts.bitnami.com/bitnami/mariadb-9.4.2.tgz \
          --values /tmp/mariadb-test.values.yaml \
          --timeout 600s \
          --atomic
      ```
2. prepare [mariadb-test.tool.yaml](resources/mariadb-test.tool.yaml.md) as file `/tmp/mariadb-test.tool.yaml`
    * ```shell
      kubectl -n test apply -f /tmp/mariadb-test.tool.yaml
      ```
3. connect to `mariadb-test`
    * ```shell
      kubectl -n test exec -it deployment/mariadb-tool -- bash -c \
          'echo "show databases" | mysql -h mariadb-test.test -uroot -p$MARIADB_ROOT_PASSWORD'
      ```
4. checking pvc and pv
    * ```shell
      kubectl -n test get pvc
      kubectl get sc && kubectl get pv
      ```
5. uninstall `mariadb-test`
    * ```shell
      helm -n test uninstall mariadb-test \
          && kubectl -n test delete pvc data-mariadb-test-0 \
          && kubectl delete namespace test
      ```
6. checking pv
    * ```shell
      kubectl get sc && kubectl get pv
      ```
