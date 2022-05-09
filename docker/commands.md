### docker commands

1. remove all `<none>` images
    + ```shell
      docker rmi `docker images | grep  '<none>' | awk '{print $3}'`
      ```
2. docker container with `host.docker.internal` point to host machine
    + ```shell
      docker run \
          ... \
          --add-host host.docker.internal:host-gateway \
          ...
      ```
3. remove all stopped containers
    + ```shell
      docker container prune
      ```
### docker IPAddress 
* ```shell
  docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq)
  ``` 

### Add images
* 
* ```shell
  for IMAGE in "docker.io/jupyterhub/k8s-hub:1.2.0" \
      "docker.io/jupyterhub/configurable-http-proxy:4.5.0"
  do
      LOCAL_IMAGE="localhost:5000/$IMAGE"
      docker image inspect $IMAGE || docker pull $IMAGE
      docker image tag $IMAGE $LOCAL_IMAGE
      docker push $LOCAL_IMAGE
  done
  ```
* ```shell
  for IMAGE in "docker.io/busybox:1.33.1-uclibc" \
      "docker.io/bitnami/bitnami-shell:10-debian-10-r198"
  do
      IMAGE_FILE=$(echo ${IMAGE} | sed "s/\//_/g" | sed "s/\:/_/g").dim
      LOCAL_IMAGE=/data/docker-images/${IMAGE_FILE}
      docker inspect ${IMAGE} 2>&1 > /dev/null \
          && (docker save -o ${IMAGE_FILE} ${IMAGE}) \
          || (docker pull ${IMAGE} && docker save -o ${IMAGE_FILE} ${IMAGE})
      mv ${IMAGE_FILE} ${LOCAL_IMAGE}
  done 
  ```
* ```shell
  DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
  BASE_URL="https://resource.static.zjvis.net/docker-images"
  for IMAGE in "docker.io/calico/apiserver:v3.21.2" \
      "docker.io/calico/pod2daemon-flexvol:v3.21.2"
  do
      IMAGE_FILE=$(echo ${IMAGE} | sed "s/\//_/g" | sed "s/\:/_/g").dim
      LOCAL_IMAGE=${DOCKER_IMAGE_PATH}/${IMAGE_FILE}
      if [ ! -f ${LOCAL_IMAGE} ];then
          TMP_FILE=${IMAGE_FILE}.TMP \
              && curl -o ${TMP_FILE} -L "${BASE_URL}/${IMAGE_FILE}" \
              && mv ${TMP_FILE} ${LOCAL_IMAGE}
      fi
      docker image load -i ${LOCAL_IMAGE}
  done
  DOCKER_REGISTRY="localhost:5000"
  for IMAGE in "docker.io/calico/apiserver:v3.21.2" \
      "docker.io/calico/pod2daemon-flexvol:v3.21.2"
  do
      DOCKER_TARGET_IMAGE=${DOCKER_REGISTRY}/${IMAGE}
      docker tag ${IMAGE} ${DOCKER_TARGET_IMAGE} \
          && docker push ${DOCKER_TARGET_IMAGE} \
          && dokcer rm ${DOCKER_TARGET_IMAGE}
  done
  ```
  
## docker-registry
* ```shell
  REGISTRY_NAME="docker-registry"
  running="$(docker inspect -f '{{.State.Running}}' ${REGISTRY_NAME} 2>/dev/null || true)"
  if [ "${running}" != 'true' ]; then
      DOCKER_REGISTRY_IMAGE=registry:2.7.1
      docker inspect $DOCKER_REGISTRY_IMAGE > /dev/null 2>&1 || docker pull $DOCKER_REGISTRY_IMAGE
      docker run --restart=always \
          -p "127.0.0.1:5000:5000" \
          --name "${REGISTRY_NAME}" \
          -d $DOCKER_REGISTRY_IMAGE
  fi
  ```
* docker-registry API
  * ```shell
    GET /v2/_catalog # 列出所有存储库
    GET /V2/image/tags/list  # 列出所有image所有tag
    ?n=<inter> # 指定个数
    ```