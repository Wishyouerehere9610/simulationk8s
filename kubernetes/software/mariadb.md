# mariadb

## main usage
* Provides the functions of the mysql database for applications

## conceptions
* none

## purpose
* Create a mariADB
* Create a mariADB-tools
* Test the MariADB functionality

## precondition
* [create.local.cluster.with.kind](/kubernetes/create.local.cluster.with.kind.md)
* [installed ingress-nginx](/kubernetes/basic/ingress.nginx.md)
* [installed cert-manager](/kubernetes/basic/cert.manager.md)

## do it
1. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      # BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
      BASE_URL="https://resource.cnconti.cc/docker-images"
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
          docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      DOCKER_REGISTRY="localhost:5000"
      for IMAGE in "docker.io/bitnami/mariadb:10.5.12-debian-10-r0" \
          "docker.io/bitnami/bitnami-shell:10-debian-10-r153" \
          "docker.io/bitnami/mysqld-exporter:0.13.0-debian-10-r56"
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
2. prepare [mariadb.values.yaml](resources/mariadb.values.yaml.md)
3. install by helm
    * NOTE: `https://resource-ops.lab.zjvis.net:32443/charts/charts.bitnami.com/bitnami/mariadb-9.4.2.tgz`
    * ```shell
      helm install \
          --create-namespace --namespace application \
          my-mariadb \
          https://resource.cnconti.cc/charts/charts.bitnami.com/bitnami/mariadb-9.4.2.tgz \
          --values mariadb.values.yaml \
          --atomic
      ```
4. apply `mariadb-tool`
    * prepare [mariadb.tool.yaml](resources/mariadb.tool.yaml.md)
    * ```shell
      kubectl -n application apply -f mariadb.tool.yaml
      ```

## test
1. connect to `mariadb`
    * ```shell
      kubectl -n application exec -it deployment/maria-db-tool -- bash -c \
          'echo "show databases" | mysql -h my-mariadb.middleware-test -uroot -p$MARIADB_ROOT_PASSWORD'
      ```

## uninstall
1. delete deployment `mariadb-tool`
    * ```shell
      kubectl -n application delete deployment mariadb-tool
      ```
2. uninstall `my-mariadb`
    * ```shell
      helm -n application uninstall my-mariadb \
          && kubectl -n application delete pvc data-my-mariadb-0
      ```
