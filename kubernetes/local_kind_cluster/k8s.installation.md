# local kind cluster

## main usage

* create a local k8s cluster for testing

## conceptions

* none

## purpose

* create a kubernetes cluster by kind
* setup docker registry

## pre-requirement

* be sure your machine have 2 cores and 4G memory at least
* [Install a host](/linux/install.centos.8.by.boot.image.md)
* [download kubernetes binary tools](/kubernetes/download.kubernetes.binary.tools.md)
    + kind
    + kubectl
    + helm

## install
1. configure repositories
    * remove all repo configuration
      * ```shell
        rm -rf /etc/yum.repos.d/*
        ```
    * copy [all.in.one.8.repo](resources/all.in.one.8.repo.md) as file `/etc/yum.repos.d/all.in.one.8.repo`
2. configure ntp
    * ```shell
      dnf install -y chrony && systemctl enable chronyd && systemctl start chronyd \
         && chronyc sources && chronyc tracking \
         && timedatectl set-timezone 'Asia/Shanghai'
      ```
3. install `docker`
    * ```shell
      dnf -y install tar yum-utils device-mapper-persistent-data lvm2 docker-ce \
          && systemctl enable docker \
          && systemctl start docker
      ```
4. configure `daemon.json`
    * ```shell
      mkdir -p /etc/docker
      tee /etc/docker/daemon.json <<-'EOF'
      {
        "insecure-registries": ["insecure.docker.registry.local:80"],
        "registry-mirrors": ["https://sp6dejha.mirror.aliyuncs.com"]
      }
      EOF
      systemctl daemon-reload
      systemctl restart docker
      ```
5. prepare kind images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
      BASE_URL="https://resource.cnconti.cc/docker-images"
      # BASE_URL="https://resource-ops-test.lab.zjvis.net:32443/docker-images"
      for IMAGE in "docker.io/kindest/node:v1.22.1" \
          "docker.io/registry:2"
      do
          IMAGE_FILE=$(echo ${IMAGE} | sed "s/\//_/g" | sed "s/\:/_/g").dim
          LOCAL_IMAGE_FIEL=${DOCKER_IMAGE_PATH}/${IMAGE_FILE}
          if [ ! -f ${LOCAL_IMAGE_FIEL} ]; then
              curl -o ${IMAGE_FILE} -L ${BASE_URL}/${IMAGE_FILE} \
                  && (mv ${IMAGE_FILE} ${LOCAL_IMAGE_FIEL}) 
          fi
          docker image load -i ${LOCAL_IMAGE_FIEL} \
              && ( echo "Successfully loaded ${IMAGE}" && rm -f ${LOCAL_IMAGE_FIEL} ) \
              || ( echo "Failed Load ${IMAGE} , Please check the URL }" && rm -f ${LOCAL_IMAGE_FIEL} ) 
      done
      ```
6. install `kind-cluster`
    * prepare [kind.cluster.yaml](resources/kind.cluster.yaml.md) as file `/tmp/kind.cluster.yaml`
    * prepare [kind.with.registry.sh](resources/kind.with.registry.sh.md) as file `/tmp/kind.with.registry.sh`
    * ```shell
      bash /tmp/kind.with.registry.sh /tmp/kind.cluster.yaml \
          /root/bin/kind /root/bin/kubectl
      ```
7. test `kind-cluster`
    * ```shell
      kubectl -n kube-system wait --for=condition=ready pod --all \
          && kubectl get pod --all-namespaces
      ```

## unisntall 
* ```shell
  kind delete clusters kind
  ```