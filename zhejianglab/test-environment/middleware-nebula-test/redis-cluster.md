## redis-cluster

1. prepare [redis-cluster.values.yaml](resource/redis-cluster.values.yaml.md)
2. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource.static.zjvis.net/docker-images"
      for IMAGE in "docker.io_bitnami_redis-cluster_6.2.2-debian-10-r0.dim" \
          "docker.io_bitnami_redis-exporter_1.20.0-debian-10-r27.dim" \
          "docker.io_bitnami_bitnami-shell_10.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE
      done
      DOCKER_REGISTRY="docker-registry-test.lab.zjvis.net:32443"
      for IMAGE in "docker.io/bitnami/redis-cluster:6.2.2-debian-10-r0" \
          "docker.io/bitnami/redis-exporter:1.20.0-debian-10-r27" \
          "docker.io/bitnami/bitnami-shell:10"
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
3. install `redis-cluster`
    * ```shell
      helm install \
          --create-namespace --namespace middleware-nebula-test \
          my-redis-cluster \
          https://resource.static.zjvis.net/charts/charts.bitnami.com/bitnami/redis-cluster-5.0.1.tgz \
          --values redis-cluster.values.yaml \
          --atomic
      ```
4. install `redis-cluster-tool`
    * prepare [redis.cluster.tool.yaml](resource/redis.cluster.tool.yaml.md)
    * ```shell
      kubectl -n middleware-nebula-test apply -f redis.cluster.tool.yaml
      ```
5. connect to `redis-cluster`
    * ```shell
      POD_NAME=$(kubectl get pod -n middleware-nebula-test \
          -l "app.kubernetes.io/name=redis-cluster-tool" \
          -o jsonpath="{.items[0].metadata.name}") \
          && kubectl -n middleware-nebula-test exec -it $POD_NAME -- bash -c '\
              echo "ping" | redis-cli -c -h my-redis-cluster.middleware-nebula-test -a $REDIS_PASSWORD' \
          && kubectl -n middleware-nebula-test exec -it $POD_NAME -- bash -c '\
              echo "set mykey somevalue" | redis-cli -c -h my-redis-cluster.middleware-nebula-test -a $REDIS_PASSWORD' \
          && kubectl -n middleware-nebula-test exec -it $POD_NAME -- bash -c '\
              echo "get mykey" | redis-cli -c -h my-redis-cluster.middleware-nebula-test -a $REDIS_PASSWORD' \
          && kubectl -n middleware-nebula-test exec -it $POD_NAME -- bash -c '\
              echo "del mykey" | redis-cli -c -h my-redis-cluster.middleware-nebula-test -a $REDIS_PASSWORD' \
          && kubectl -n middleware-nebula-test exec -it $POD_NAME -- bash -c '\
              echo "get mykey" | redis-cli -c -h my-redis-cluster.middleware-nebula-test -a $REDIS_PASSWORD'
      ```