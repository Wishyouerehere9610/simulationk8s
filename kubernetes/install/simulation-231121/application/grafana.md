## grafana

### installation
1. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops-dev.lab.zjvis.net:32443/docker-images"
      for IMAGE in "docker.io_grafana_grafana_9.2.15.dim" \
          "docker.io_bats_bats_v1.4.1.dim" \
          "docker.io_curlimages_curl_7.85.0.dim" \
          "docker.io_library_busybox_1.31.1.dim" \
          "quay.io_kiwigrid_k8s-sidecar_1.22.0.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      for IMAGE in "docker.io/grafana/grafana:9.2.15" \
          "docker.io/bats/bats:v1.4.1" \
          "docker.io/curlimages/curl:7.85.0" \
          "docker.io/library/busybox:1.31.1" \
          "quay.io/kiwigrid/k8s-sidecar:1.22.0"
      do
          kind load docker-image ${IMAGE}
      done
      ```
2. prepare helm values [grafana.values.yaml](resources/grafana.values.yaml.md)
3. install `grafana` by helm
    * ```shell
      helm install \
          --create-namespace --namespace application \
          my-grafana \
          https://resource-ops-dev.lab.zjvis.net:32443/charts/grafana.github.io/helm-charts/grafana/grafana-6.54.0.tgz \
          --values grafana.values.yaml \
          --atomic
      ```

### uninstall 
1. uninstall `my-grafana`
    * ```shell
      helm -n middleware uninstall my-grafana
      ```
