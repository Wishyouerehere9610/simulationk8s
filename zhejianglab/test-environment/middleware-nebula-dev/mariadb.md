## mariadb

1. prepare [mariadb.values.yaml](resource/mariadb.values.yaml.md)
2. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource.static.zjvis.net/docker-images"
      for IMAGE in "docker.io_bitnami_mariadb_10.5.12-debian-10-r0.dim" \
          "docker.io_bitnami_bitnami-shell_10-debian-10-r153.dim" \
          "docker.io_bitnami_mysqld-exporter_0.13.0-debian-10-r56.dim" \
          "docker.io_bitnami_phpmyadmin_5.1.1-debian-10-r147.dim" \
          "docker.io_bitnami_apache-exporter_0.10.1-debian-10-r54.dim"
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
      for IMAGE in "docker.io/bitnami/mariadb:10.5.12-debian-10-r0" \
          "docker.io/bitnami/bitnami-shell:10-debian-10-r153" \
          "docker.io/bitnami/mysqld-exporter:0.13.0-debian-10-r56" \
          "docker.io/bitnami/phpmyadmin:5.1.1-debian-10-r147" \
          "docker.io/bitnami/apache-exporter:0.10.1-debian-10-r54"
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
3. install `mariadb`
    * ```shell
      helm install \
          --create-namespace --namespace middleware-nebula-dev \
          my-mariadb \
          https://resource.static.zjvis.net/charts/charts.bitnami.com/bitnami/mariadb-9.4.2.tgz \
          --values mariadb.values.yaml \
          --atomic
      ```
4. install `phpmyadmin`
    * prepare [php.my.admin.values.yaml](resource/php.my.admin.values.yaml.md)
    * ```shell
      helm install \
          --create-namespace --namespace middleware-nebula-dev \
          my-phpmyadmin \
          https://resource.static.zjvis.net/charts/charts.bitnami.com/bitnami/phpmyadmin-8.3.1.tgz \
          --values php.my.admin.values.yaml \
          --atomic
      ```
5. access `http://phpmyadmin-nebula-dev.lab.zjvis.net:32080`
    * address: `ops-test-01.lab.zjvis.net:32306`
    * username: `root`
    * password
        + ```shell
          kubectl get secret --namespace middleware-nebula-dev my-mariadb -o jsonpath="{.data.mariadb-root-password}" \
              | base64 --decode \
              && echo
          ```