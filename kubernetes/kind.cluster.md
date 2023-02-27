# create local cluster with kind

## main usage
* create a local k8s cluster 

## conceptions
* none

## precondition
* prepare the machine
    + It is recommended that the machine system be `CentOS-Stream-8`
    + be sure your machine have `2 cores` and `4G memory` at least
* [kubernetes binary tools](binary_tools.md)
    + kind
    + helm
    + kubectl
* [installed docker-ce](/docker/installation.md)

## operation
1. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource.cnconti.cc/docker-images"
      # BASE_URL="https://resource.static.zjvis.net/docker-images"
      for IMAGE in "docker.io_kindest_node_v1.25.3.dim" \
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
2. prepare [kind.cluster.yaml](resources/kind.cluster.yaml.md) as file `/tmp/kind.cluster.yaml`
    * modify `networking.apiServerAddress`
3. prepare [kind.with.registry.sh](resources/kind.with.registry.sh.md) as file `/tmp/kind.with.registry.sh`
4. install `kind-cluster`
    * ```shell
      bash /tmp/kind.with.registry.sh /tmp/kind.cluster.yaml \
          /root/bin/kind /root/bin/kubectl
      ```
5. check `kind-cluster`
    * ```shell
      kubectl -n kube-system wait --for=condition=ready pod --all \
          && kubectl get pod --all-namespaces
      ```

## uninstall
1. uninstall `kind`
    * ```shell
      kind delete clusters kind
      ```
