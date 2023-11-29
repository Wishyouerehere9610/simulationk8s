## k8s installation

### install basic
1. 3 nodes with centos7
    * master: `simulation-01`
    * worker1: `simulation-02`
    * worker2: `simulation-03`
2. configure hosts for all nodes
    * ```shell
      cat >> /etc/hosts <<EOF
      10.101.16.62 simulation-01
      10.101.16.63 simulation-02
      10.101.16.64 simulation-03
      EOF
      ```
3. remove all repo configuration
    * ```shell
      rm -rf /etc/yum.repos.d/*
      ```
    * copy [all.in.one.8.repo](resources/all.in.one.8.repo.md) as file `/etc/yum.repos.d/all.in.one.8.repo`
4. configure ntp
    * ```shell
      yum install -y chrony && systemctl enable chronyd && systemctl start chronyd \
         && chronyc sources && chronyc tracking \
         && timedatectl set-timezone 'Asia/Shanghai'
      ```
5. stop and disable firewalld
    * ```shell
      systemctl stop firewalld && systemctl disable firewalld
      ```
6. install base environment
    * copy [setup.base.sh](resources/setup.base.sh.md) as file `/tmp/setup.base.sh`
    * ```shell
      bash /tmp/setup.base.sh
      ```
7. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
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
          "quay.io_tigera_operator_v1.29.0.dim" \
          "docker.io_registry_2.7.1.dim" \
          "quay.io_tigera_operator_v1.23.3.dim" \
          "docker.io_bitnami_mariadb_10.5.12-debian-10-r0.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      ```

### install master
1. choose `simulation-01` as master node
2. initialize master
    * ```shell
      kubeadm init --pod-network-cidr=172.21.0.0/20 --kubernetes-version v1.23.3 \
          && systemctl restart kubelet
      ```
3. copy `k8s_config`
    * ```shell
      mkdir -p $HOME/.kube
      cp /etc/kubernetes/admin.conf $HOME/.kube/config
      chown $(id -u):$(id -g) $HOME/.kube/config
      ```
4. download specific `helm binary`
    * ```shell
      # mirror of https://get.helm.sh
      BASE_URL=https://resource-ops.lab.zjvis.net:32443/binary/helm
      curl -LO ${BASE_URL}/helm-v3.6.2-linux-amd64.tar.gz
      tar zxvf helm-v3.6.2-linux-amd64.tar.gz linux-amd64/helm \
          && mkdir -p $HOME/bin \
          && mv linux-amd64/helm $HOME/bin/helm \
          && rm -rf linux-amd64/ helm-v3.6.2-linux-amd64.tar.gz
      ```
5. install `tigera-operator` for k8s-cluster
    * prepare [tigera-operator.values.yaml](resources/tigera-operator.values.yaml.md) as file `/tmp/tigera-operator.values.yaml`
    * ```shell
      helm install \
         --create-namespace --namespace calico-system \
         tigera-operator \
         https://resource-ops-dev.lab.zjvis.net/charts/projectcalico.docs.tigera.io/charts/tigera-operator/tigera-operator-v3.25.0.tgz \
         --values /tmp/tigera-operator.values.yaml \
         --atomic
      ```
6. wait for all pods in kube-system to be ready
    * ```shell
      kubectl -n calico-system wait --for=condition=ready pod --all
      kubectl -n kube-system wait --for=condition=ready pod --all
      kubectl wait --for=condition=ready node --all
      ```

### install workers
1. choose `simulation-02` ~ `simulation-03` as workers
    * ```shell
      $(ssh simulation-01 "kubeadm token create --print-join-command")
      ```
2. wait for all pods in kube-system to be ready
    * ```shell
      kubectl -n calico-system wait --for=condition=ready pod --all
      kubectl -n kube-system wait --for=condition=ready pod --all
      kubectl wait --for=condition=ready node --all
      ```

### install k8s-storage(NFS)
1. create `nfs-server`
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops.lab.zjvis.net/docker-images"
      IMAGE_FILE=$DOCKER_IMAGE_PATH/docker.io_erichough_nfs-server_2.2.1.dim
      if [ ! -f $IMAGE_FILE ]; then
          TMP_FILE=$IMAGE_FILE.tmp \
              && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
              && mv $TMP_FILE $IMAGE_FILE
      fi
      docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
      ```
    * ```shell
      mkdir -p /data/nfs/data \
      && echo '/data *(rw,fsid=0,no_subtree_check,insecure,no_root_squash)' > /data/nfs/exports \
      && modprobe nfs && modprobe nfsd \
      && docker run \
             --name nfs4 \
             --restart always \
             --privileged \
             -p 2049:2049 \
             -v /data/nfs/data:/data \
             -v /data/nfs/exports:/etc/exports:ro \
             -d docker.io/erichough/nfs-server:2.2.1
      ```
2. prepare images for all nodes
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
      for IMAGE in "k8s.gcr.io_sig-storage_nfs-subdir-external-provisioner_v4.0.2.dim" \
          "docker.io_bitnami_mariadb_10.5.12-debian-10-r0.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      ```
3. prepare [nfs.provisioner.values.yaml](resources/nfs.provisioner.values.yaml.md) as file `/tmp/nfs.provisioner.values.yaml`
4. install `nfs-provisioner` by helm
    * ```shell
      helm install \
          --create-namespace --namespace nfs-provisioner \
          my-nfs-subdir-external-provisioner \
          https://resource-ops.lab.zjvis.net/charts/kubernetes-sigs.github.io/nfs-subdir-external-provisioner/nfs-subdir-external-provisioner-4.0.14.tgz \
          --values /tmp/nfs.provisioner.values.yaml \
          --atomic
      ```

### test k8s-cluster
1. install `mariadb-test`
    * prepare [mariadb-test.values.yaml](resources/mariadb-test.values.yaml.md) as file `/tmp/mariadb-test.values.yaml`
    * ```shell
      helm install \
          --create-namespace --namespace test \
          mariadb-test \
          https://resource-ops.lab.zjvis.net/charts/charts.bitnami.com/bitnami/mariadb-9.4.2.tgz \
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
