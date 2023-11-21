## redis-cluster

### installation
1. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
      for IMAGE in "docker.io_bitnami_redis-cluster_6.2.2-debian-10-r0.dim" \
          "docker.io_bitnami_redis-exporter_1.20.0-debian-10-r27.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE && rm -rf $IMAGE_FILE
      done
      for IMAGE in "docker.io/bitnami/redis-cluster:6.2.2-debian-10-r0" \
          "docker.io/bitnami/redis-exporter:1.20.0-debian-10-r27"
      do
          kind load docker-image ${IMAGE}
      done
      ```
2. prepare helm values [redis-cluster.values.yaml](resources/redis-cluster.values.yaml.md)
3. install `redis-cluster` by helm
    * ```shell
      helm install \
          --create-namespace --namespace middleware \
          my-redis-cluster \
          https://resource-ops.lab.zjvis.net:32443/charts/charts.bitnami.com/bitnami/redis-cluster-5.0.1.tgz \
          --values redis-cluster.values.yaml \
          --atomic
      ```
4. create deployment `redis-cluster-tool`
    * prepare [redis-cluster-tool.deployment.yaml](resources/redis-cluster-tool.deployment.yaml.md)
    * ```shell
      kubectl -n middleware apply -f redis-cluster-tool.deployment.yaml
      ```

## test
1. connect to `my-redis-cluster`
    * ```shell
      kubectl -n middleware exec -it deployment/redis-cluster-tool -- bash -c '\
          echo "ping" | redis-cli -c -h my-redis-cluster.middleware -a $REDIS_PASSWORD' \
      && kubectl -n middleware exec -it deployment/redis-cluster-tool -- bash -c '\
          echo "set mykey somevalue" | redis-cli -c -h my-redis-cluster.middleware -a $REDIS_PASSWORD' \
      && kubectl -n middleware exec -it deployment/redis-cluster-tool -- bash -c '\
          echo "get mykey" | redis-cli -c -h my-redis-cluster.middleware -a $REDIS_PASSWORD' \
      && kubectl -n middleware exec -it deployment/redis-cluster-tool -- bash -c '\
          echo "del mykey" | redis-cli -c -h my-redis-cluster.middleware -a $REDIS_PASSWORD' \
      && kubectl -n middleware exec -it deployment/redis-cluster-tool -- bash -c '\
          echo "get mykey" | redis-cli -c -h my-redis-cluster.middleware -a $REDIS_PASSWORD'
      ```

### uninstall
1. delete deployment `redis-cluster-tool`
    * ```shell
      kubectl -n middleware delete deployment redis-cluster-tool
      ```
2. uninstall `my-redis-cluster`
    * ```shell
      helm -n middleware uninstall my-redis-cluster && \
      for INDEX in "0" "1" "2" "3" "4" "5"
      do
          kubectl -n middleware delete pvc redis-data-my-redis-cluster-${INDEX}
      done
      ```
