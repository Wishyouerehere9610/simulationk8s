## minio

### installation
1. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
      for IMAGE in "docker.io_bitnami_minio_2022.8.22-debian-11-r0.dim" \
          "docker.io_bitnami_minio-client_2022.8.11-debian-11-r3.dim" \
          "docker.io_bitnami_bitnami-shell_11-debian-11-r28.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      DOCKER_REGISTRY="docker-registry-ops-dev.lab.zjvis.net:32443"
      for IMAGE in "docker.io/bitnami/minio:2022.8.22-debian-11-r0" \
          "docker.io/bitnami/minio-client:2022.8.11-debian-11-r3" \
          "docker.io/bitnami/bitnami-shell:11-debian-11-r28"
      do
          kind load docker-image ${IMAGE}
      done
      ```
2. prepare helm values [minio.values.yaml](resources/minio.values.yaml.md)
3. install `minio` by helm
    * ```shell
      helm install \
          --create-namespace --namespace middleware \
          my-minio \
          https://resource-ops.lab.zjvis.net:32443/charts/charts.bitnami.com/bitnami/minio-11.9.2.tgz \
          --values minio.values.yaml \
          --atomic
      ```
4. create deployment `minio-tool`
    * prepare [minio-tool.deployment.yaml](resources/minio-tool.deployment.yaml.md)
    * ```shell
      kubectl -n middleware apply -f minio-tool.deployment.yaml
      ```

### uninstall
1. delete deployment
    * ```shell
      kubectl -n middleware delete deployment minio-tool
      ```
2. uninstall `my-minio`
    * ```shell
      helm -n middleware uninstall my-minio \
          && kubectl -n middleware delete pvc my-minio
      ```
