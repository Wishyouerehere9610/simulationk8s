## redis

### installation
1. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
      for IMAGE in "docker.io_bitnami_redis_7.0.4-debian-11-r2.dim" \
          "docker.io_bitnami_redis-sentinel_7.0.4-debian-11-r0.dim" \
          "docker.io_bitnami_redis-exporter_1.43.0-debian-11-r9.dim" \
          "docker.io_bitnami_bitnami-shell_11-debian-11-r16.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE && rm -rf $IMAGE_FILE
      done
      for IMAGE in "docker.io/bitnami/redis:7.0.4-debian-11-r2" \
          "docker.io/bitnami/redis-sentinel:7.0.4-debian-11-r0" \
          "docker.io/bitnami/redis-exporter:1.43.0-debian-11-r9" \
          "docker.io/bitnami/bitnami-shell:11-debian-11-r16"
      do
          kind load docker-image ${IMAGE}
      done
      ```
2. prepare [redis.values.yaml](resources/redis.values.yaml.md)
3. install `redis` by helm
    * ```shell
      helm install \
          --create-namespace --namespace middleware \
          my-redis \
          https://resource-ops.lab.zjvis.net/charts/charts.bitnami.com/bitnami/redis-17.0.2.tgz \
          --values redis.values.yaml \
          --atomic
      ```
4. create deployment `redis-tool`
    * prepare [redis-tool.deployment.yaml](resources/redis-tool.deployment.yaml.md)
    * ```shell
      kubectl -n middleware apply -f redis-tool.deployment.yaml
      ```

## test
1. connect to `my-redis-cluster`
    * ```shell
      kubectl -n middleware exec -it deployment/redis-cluster-tool -- bash -c '\
          echo "ping" | redis-cli -c -h my-redis-master.middleware -a $REDIS_PASSWORD' \
      && kubectl -n middleware exec -it deployment/redis-cluster-tool -- bash -c '\
          echo "set mykey somevalue" | redis-cli -c -h my-redis-master.middleware -a $REDIS_PASSWORD' \
      && kubectl -n middleware exec -it deployment/redis-cluster-tool -- bash -c '\
          echo "get mykey" | redis-cli -c -h my-redis-master.middleware -a $REDIS_PASSWORD' \
      && kubectl -n middleware exec -it deployment/redis-cluster-tool -- bash -c '\
          echo "del mykey" | redis-cli -c -h my-redis-master.middleware -a $REDIS_PASSWORD' \
      && kubectl -n middleware exec -it deployment/redis-cluster-tool -- bash -c '\
          echo "get mykey" | redis-cli -c -h my-redis-master.middleware -a $REDIS_PASSWORD'
      ```

### uninstall
1. delete deployment `redis-tool`
    * ```shell
      kubectl -n middleware delete deployment redis-tool
      ```
2. uninstall `my-redis`
    * ```shell
      helm -n middleware uninstall my-redis-cluster
      ```
