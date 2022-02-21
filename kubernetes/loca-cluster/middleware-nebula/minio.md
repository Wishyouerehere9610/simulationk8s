## minio

1. prepare [minio.values.yaml](resource/minio.values.yaml.md)
2. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource.static.zjvis.net/docker-images"
      for IMAGE in "docker.io_bitnami_minio_2021.9.18-debian-10-r0.dim" \
          "docker.io_bitnami_minio-client_2021.9.2-debian-10-r17.dim" \
          "docker.io_bitnami_bitnami-shell_10-debian-10-r198.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE
      done
      DOCKER_REGISTRY="docker-registry-ops.lab.zjvis.net:32443"
      for IMAGE in "docker.io/bitnami/minio:2021.9.18-debian-10-r0" \
          "docker.io/bitnami/minio-client:2021.9.2-debian-10-r17" \
          "docker.io/bitnami/bitnami-shell:10-debian-10-r198"
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
3. install `minio`
    * ```shell
      helm install \
          --create-namespace --namespace middleware-nebula \
          my-minio \
          https://resource.static.zjvis.net/charts/charts.bitnami.com/bitnami/minio-8.1.2.tgz \
          --values minio.values.yaml \
          --atomic
      ```
4. install `minio-tool`
    * prepare [minio.tool.yaml](resource/minio.tool.yaml.md)
    * ```shell
      kubectl -n middleware-nebula apply -f minio.tool.yaml
      ```
5. access `http://web-minio-nebula-ops.lab.zjvis.net:32080`
    * username/access-key
        + ```shell
          kubectl get secret --namespace middleware-nebula my-minio -o jsonpath="{.data.access-key}" \
              | base64 --decode \
              && echo
          ```
    * password/secret-key
        + ```shell
          kubectl get secret --namespace middleware-nebula my-minio -o jsonpath="{.data.secret-key}" \
              | base64 --decode \
              && echo
          ```