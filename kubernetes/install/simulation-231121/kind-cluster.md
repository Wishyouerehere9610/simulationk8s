## Installation
1. configure repositories
    * ```shell
      rm -f /etc/yum.repos.d/*
      ```
    * prepare [all.in.one.7.repo](resources/all.in.one.7.repo.md) as `/etc/yum.repos.d/all.in.one.7.repo`
2. configure ntp
    * ```shell
     yum install -y chrony && systemctl enable chronyd && systemctl start chronyd \
         && chronyc sources && chronyc tracking \
         && timedatectl set-timezone 'Asia/Shanghai'
     ```
3. install `docker`
    * ```shell
      yum -y install tar yum-utils device-mapper-persistent-data lvm2 docker-ce \
          && systemctl enable docker \
          && systemctl start docker
      ```
4. download kubernetes binary tools
    * ```shell
      mkdir -p /root/bin
      BASE_URL="https://resource-ops.lab.zjvis.net:32443/binary"
      curl -LO ${BASE_URL}/kind/v0.11.1/kind-linux-amd64 \
          && curl -LO ${BASE_URL}/kubectl/v1.21.2/bin/linux/amd64/kubectl \
          && curl -LO ${BASE_URL}/helm/helm-v3.6.2-linux-amd64.tar.gz \
          && tar -zxvf helm-v3.6.2-linux-amd64.tar.gz \
          && mv linux-amd64/helm /root/bin/helm \
          && mv kind-linux-amd64 /root/bin/kind \
          && mv kubectl /root/bin/kubectl \
          && chmod 744 /root/bin/helm /root/bin/kind /root/bin/kubectl \
          && rm -rf linux-amd64 helm-v3.6.2-linux-amd64.tar.gz
      ```
5. prepare kind images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
      for IMAGE in "docker.io_kindest_node_v1.23.3.dim" \
          "docker.io_registry_2.7.1.dim"
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
6. install `kind-cluster` kind
    * prepare [kind.cluster.yaml](resources/kind.cluster.yaml.md) as file `/tmp/kind.cluster.yaml`
    * prepare [kind.with.registry.sh](resources/kind.with.registry.sh.md) as file `/tmp/kind.with.registry.sh`
    * ```shell
      bash /tmp/kind.with.registry.sh /tmp/kind.cluster.yaml \
          /root/bin/kind /root/bin/kubectl
      ```
7. Remove the stain configuration from the master
    * ```shell
      kubectl -n kube-system wait --for=condition=ready pod --all \
          && kubectl get pod --all-namespaces
      ```

## Uninstallation
1. uninstall `kind-cluster`
    * ```shell
      kind delete cluster --name kind
      ```
