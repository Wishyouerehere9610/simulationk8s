## kubernetes_230926

### prepare
1. prepare 6 nodes with `Fedora 38`
    * operator: 192.168.11.129
    * master: 192.168.11.130
    * worker1: 192.168.11.131
    * worker2: 192.168.11.132
    * worker3: 192.168.11.133

### installation
1. reference: [kubespray](https://github.com/kubernetes-sigs/kubespray)
2. stop and disable firewalld
    * ```shell
      systemctl stop firewalld && systemctl disable firewalld
      ```
3. configure repositories
    * remove all repo configuration
    * ```shell
      rm -rf /etc/yum.repos.d/*
      ```
    * copy [fedora.aliyun.repo](resources/fedora.aliyun.repo.md) as file `/etc/yum.repos.d/fedora.aliyun.repo`
4. configure ntp
    * ```shell
      dnf install -y chrony \
         && systemctl enable chronyd \
         && systemctl start chronyd \
         && chronyc sources && chronyc tracking \
         && timedatectl set-timezone 'Asia/Shanghai'
      ```
5. install basic tools
    * ```shell
      dnf install -y git vim curl wget python3.6 python3-pip net-tools
      ```
6. clone kubespray with specific version(v2.23.0)
    * ```shell
      KUBESPRAY_DIREACTORY=$HOME/kubespray
      git clone -b v2.23.0 https://github.com/kubernetes-sigs/kubespray $KUBESPRAY_DIREACTORY
      cd $KUBESPRAY_DIREACTORY && pip install -U -r requirements.txt
      ```
8. generate configurations for kubespray
    * ```shell
      cp -rfp inventory/sample inventory/mycluster
      declare -a IPS=(192.168.112.130 192.168.112.131 192.168.112.132)
      CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
      # Review and change parameters under ``inventory/mycluster/group_vars``
      #less inventory/mycluster/group_vars/all/all.yml
      #less inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml
      # modify `upstream_dns_servers in `inventory/mycluster/group_vars/all/all.yml`
      # uncomment `upstream_dns_servers` and add `223.5.5.5`, `223.6.6.6` to dns servers
      # https://github.com/kubernetes-sigs/kubespray/issues/9948
      vim inventory/mycluster/group_vars/all/all.yml
      ```
7. install kubernetes cluster with ansible
    * ```shell
      ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root reset.yml
      # you may have to retry several times to install kubernetes cluster successfully for the bad network
      ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml
      ```
8. copy configurations for kubectl
   * ```shell
      mkdir ~/.kube \
          && sudo cp /etc/kubernetes/admin.conf ~/.kube/config \
          && sudo chown ben.wangz:ben.wangz ~/.kube/config
      ```



### pass


2. prepare nodes for kubernetes cluster
   * for example we have 3 nodes: node1(192.168.123.47), node2(192.168.123.151), node3(192.168.123.46)
   * ssh no password login for each node
   * configure sudo for each node
      + ```shell
          sudo bash -c "echo 'ben.wangz ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/extra"
          ```
   * turn off firewalld for each node
      + ```shell
          sudo systemctl stop firewalld && sudo systemctl disable firewalld
          ```
3. install git
   * ```shell
      sudo dnf -y install git
      ```






#### install `operator`


4. install base environment
    * copy [setup.base.sh](resources/setup.base.sh.md) as file `/tmp/setup.base.sh`
    * ```shell
      bash /tmp/setup.base.sh
      ```
5. prepare images
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