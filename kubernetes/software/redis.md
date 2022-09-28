# redis

## main usage
* Provide Redis functionality for applications

## conceptions
* none

## purpose
* none

## precondition
* [create.local.cluster.with.kind](/kubernetes/create.local.cluster.with.kind.md)
* [installed ingress-nginx](/kubernetes/basic/ingress.nginx.md)
* [installed cert-manager](/kubernetes/basic/cert.manager.md)

## do it
1. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      # BASE_URL="https://resource-ops.lab.zjvis.net/docker-images"
      BASE_URL="https://resource.cnconti.cc/docker-images"
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
          docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      DOCKER_REGISTRY="localhost:5000"
      for IMAGE in "docker.io/bitnami/redis:7.0.4-debian-11-r2" \
          "docker.io/bitnami/redis-sentinel:7.0.4-debian-11-r0" \
          "docker.io/bitnami/redis-exporter:1.43.0-debian-11-r9" \
          "docker.io/bitnami/bitnami-shell:11-debian-11-r16"
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
2. prepare [redis.values.yaml](resources/redis.values.yaml.md)
3. install `redis`
    * NOTE: `https://resource-ops.lab.zjvis.net:32443/charts/charts.bitnami.com/bitnami/redis-17.0.2.tgz`
    * ```shell
      helm install \
          --create-namespace --namespace application \
          my-redis \
          https://resource.cnconti.cc/charts/charts.bitnami.com/bitnami/redis-17.0.2.tgz \
          --values redis.values.yaml \
          --atomic
      ```
5. install `redis-tool`
    * prepare [redis.tool.yaml](resources/redis.tool.yaml.md)
    * ```shell
      kubectl -n application apply -f redis.tool.yaml
      ```

## test
1. connect to `redis`
    * ```shell
      kubectl -n application exec -it deployment/redis-tool -- bash -c '\
          echo "ping" | redis-cli -c -h my-redis-master.application -a $REDIS_PASSWORD' \
      && kubectl -n application exec -it deployment/redis-tool -- bash -c '\
          echo "set mykey somevalue" | redis-cli -c -h my-redis-master.application -a $REDIS_PASSWORD' \
      && kubectl -n application exec -it deployment/redis-tool -- bash -c '\
          echo "get mykey" | redis-cli -c -h my-redis-master.application -a $REDIS_PASSWORD' \
      && kubectl -n application exec -it deployment/redis-tool -- bash -c '\
          echo "del mykey" | redis-cli -c -h my-redis-master.application -a $REDIS_PASSWORD' \
      && kubectl -n application exec -it deployment/redis-tool -- bash -c '\
          echo "get mykey" | redis-cli -c -h my-redis-master.application -a $REDIS_PASSWORD'
      ```

### uninstall
1. uninstall `my-redis`
    * ```shell
      helm -n application uninstall my-redis && \
          && kubectl -n application delete pvc redis-data-my-redis-master-0
      ```
2. delete `redis-tool`
    * ```shell
      kubectl -n application delete deployment redis-tool
      ```
