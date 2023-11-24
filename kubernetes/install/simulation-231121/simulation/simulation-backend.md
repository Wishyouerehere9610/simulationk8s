## simualtion-backend

### precondition
* [nacos](../application/nacos.md)
* [mariadb](../middleware/mariadb.md)
* [minio](../middleware/minio.md)
* [redis-cluster](../middleware/redis-cluster.md)

### installation
1. prepare images
    * ```yaml
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops-dev.lab.zjvis.net:32443/docker-images"
      for IMAGE in "docker.io_python_3.8.16-bullseye.dim" \
          "docker.io_centos_centos8.4.2105.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      kind load docker-image docker.io/centos:centos8.4.2105
      ```
2. prepare basic image
    * `docker.io/cnconti/oraclejdk:simulation-r1` # [Dockerfile](resources/simulation.basic.md)
3. prepare business image
    * `docker.io/cnconti/simulation-backend:5fd3ba7d9f` # [Dockerfile](resources/simulation-backend.business.md)
    * ```shell
      kind load docker-image docker.io/cnconti/simulation-backend:5fd3ba7d9f
      ```
4. prepare helm values 
    * prepare [simulation-backend.values.yaml](resources/simulation-backend.values.yaml.md)
    * change `image.tag`
6. install `simulation-backend` by helm
    * ```shell
      helm install \
          --create-namespace --namespace simulation \
          simulation-backend \
          java \
          --repo https://chartmuseum-ops-dev.lab.zjvis.net:32443 \
          --version 1.0.0-C4f979aa \
          --values simulation-backend.values.yaml \
          --atomic
      ```
7. upgrade `simulation-backend` by helm
    * change [simulation.backend.values.yaml](resources/simulation-backend.values.yaml.md)
    * ```shell
      helm upgrade --namespace simulation \
          simulation-backend \
          java \
          --repo https://chartmuseum-ops-dev.lab.zjvis.net:32443 \
          --version 1.0.0-Cef75117 \
          --values simulation-backend.values.yaml \
          --atomic
      ```

### uninstall
1. uninstall `simulation-backend`
    * ```shell
      helm -n simulation uninstall simulation-backend
      ```
