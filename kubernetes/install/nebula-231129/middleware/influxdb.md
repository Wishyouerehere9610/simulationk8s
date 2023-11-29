## influxdb

### installation
1. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops-dev.lab.zjvis.net:32443/docker-images"
      for IMAGE in "docker.io_library_influxdb_1.8.10-alpine.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      kind load docker-image docker.io/library/influxdb:1.8.10-alpine
      ```
2. prepare helm values [influxdb.values.yaml](resources/influxdb.values.yaml.md)
3. install `influxdb` by helm
    * ```shell
      helm install \
          --create-namespace --namespace middleware \
          my-influxdb \
          https://resource-ops-dev.lab.zjvis.net:32443/charts/helm.influxdata.com/influxdb/influxdb-4.12.1.tgz \
          --values influxdb.values.yaml \
          --atomic
      ```
      
### uninstall
1. uninstall `my-influxdb`
    * ```shell
      helm -n middleware uninstall my-influxdb \
          && kubectl -n middleware delete pvc my-influxdb-data-my-influxdb-0
      ```
