## docker-registry
CNAME: `docker-registry-simulation.lab.zjvis.net`: `10.101.16.62`

1. prepare [docker.registry.values.yaml](resources/docker.registry.values.yaml.md)
2. prepare images at every node
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
      for IMAGE in "docker.io_registry_2.7.1.dim" \
          "docker.io_busybox_1.33.1-uclibc.dim"
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
3. install
    * ```shell
      helm install \
          --create-namespace --namespace basic-components \
          my-docker-registry \
          https://resource-ops.lab.zjvis.net:32443/charts/helm.twun.io/docker-registry-1.14.0.tgz \
          --values docker.registry.values.yaml \
          --atomic
      ```
4. configure ingress with tls
    * NOTE: ingress in helm chart is not compatible enough for us, we have to install ingress manually
    * prepare [docker.registry.ingress.yaml](resources/docker.registry.ingress.yaml.md)
    * apply ingress
        + ```shell
          kubectl -n basic-components apply -f docker.registry.ingress.yaml
          ```
5. check with every node
    * ```shell
      IMAGE=docker.io/busybox:1.33.1-uclibc \
          && TARGET_IMAGE=docker-registry-simulation.lab.zjvis.net:32443/$IMAGE \
          && docker tag $IMAGE $TARGET_IMAGE \
          && docker push $TARGET_IMAGE \
          && docker image rm $IMAGE \
          && docker image rm $TARGET_IMAGE \
          && docker pull $TARGET_IMAGE \
          && echo success
      ```
