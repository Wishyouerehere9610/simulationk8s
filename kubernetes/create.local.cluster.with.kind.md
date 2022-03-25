# create local cluster with kind

## main usage

* create a local k8s cluster for testing

## conceptions

* none

## purpose

* create a kubernetes cluster by kind
* setup docker registry

## pre-requirement

* [Install a host]()
* [download kubernetes binary tools](download.kubernetes.binary.tools.md)
   + kind
   + kubectl
   + helm
* be sure your machine have 2 cores and 4G memory at least

## Do it
1. install `docker`
    * ```shell
      dnf -y install tar yum-utils device-mapper-persistent-data lvm2 docker-ce \
          && systemctl enable docker \
          && systemctl start docker
      ```
2. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
      BASE_URL="https://resource.cnconti.cc/docker-images"
      for IMAGE in "docker.io/kindest/node:v1.22.1" \
          "docker.io/registry:2"
      do
          IMAGE_FILE=$(echo ${IMAGE} | sed "s/\//_/g" | sed "s/\:/_/g").dim
          LOCAL_IMAGE_FIEL=${DOCKER_IMAGE_PATH}/${IMAGE_FILE}
          if [ ! -f ${LOCAL_IMAGE_FIEL} ]; then
              curl -o ${IMAGE_FILE} -L ${BASE_URL}/${IMAGE_FILE} \
                  && mv ${IMAGE_FILE} ${LOCAL_IMAGE_FIEL} \
                  || rm -rf ${IMAGE_FILE}
          fi
          docker image load -i ${LOCAL_IMAGE_FIEL} && rm -rf ${LOCAL_IMAGE_FIEL} 
      done
      ```
3. install `kind-cluster`
    * prepare [kind.cluster.yaml](resources/kind.cluster.yaml.md) as `/root/bin`
    * prepare [kind.with.registry.sh](resources/kind.with.registry.sh) as `/root/bin`
    * ```shell
      bash /root/bin/kind.with.registry.sh /root/conf/kind.cluster.yaml  /root/bin/kind /root/bin/kubectl
      ```
4. test `kind-cluster`
    * ```shell
      kubectl -n kube-system wait --for=condition=ready pod --all \
          && kubectl get pod --all-namespaces
      ```
