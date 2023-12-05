## mariadb

## installation
1. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
      for IMAGE in "docker.io_bitnami_mariadb_10.5.12-debian-10-r0.dim" \
          "docker.io_bitnami_bitnami-shell_10-debian-10-r153.dim" \
          "docker.io_bitnami_mysqld-exporter_0.13.0-debian-10-r56.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE && rm -rf $IMAGE_FILE
      done
      for IMAGE in "docker.io/bitnami/mariadb:10.5.12-debian-10-r0" \
          "docker.io/bitnami/bitnami-shell:10-debian-10-r153" \
          "docker.io/bitnami/mysqld-exporter:0.13.0-debian-10-r56"
      do
          kind load docker-image ${IMAGE}
      done
      ```
2. prepare helm values [mariadb.values.yaml](resources/mariadb.values.yaml.md)
3. install `mariadb` by helm
    * ```shell
      helm install \
          --create-namespace --namespace middleware \
          my-mariadb \
          https://resource-ops.lab.zjvis.net:32443/charts/charts.bitnami.com/bitnami/mariadb-9.4.2.tgz \
          --values mariadb.values.yaml \
          --atomic
      ```
4. create deployment `mariadb-tool`
    * prepare [mariadb-tool.deployment.yaml](resources/mariadb-tool.deployment.yaml.md)
    * ```shell
      kubectl -n middleware apply -f mariadb-tool.deployment.yaml
      ```
      
## test
1. connect to `my-mariadb`
    * ```shell
      kubectl -n middleware exec -it deployment/mariadb-tool -- bash -c \
          'echo "show databases" | mysql -h my-mariadb.middleware -uroot -p$MARIADB_ROOT_PASSWORD'
      ```
    
### uninstall
1. delete deployment `mariadb-tool`
    * ```shell
      kubectl -n middleware delete deployment mariadb-tool
      ```
2. uninstall `my-mariadb`
    * ```shell
      helm -n middleware uninstall my-mariadb \
          && kubectl -n middleware delete pvc data-my-mariadb-0
      ```
