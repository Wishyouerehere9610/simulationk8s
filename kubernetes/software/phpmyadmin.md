# phpmyadmin
* CName: `phpmyadmin-ops-dev.lab.zjvis.net` `ops-dev-01.lab.zjvis.net`

## main usage
* Provides a Web page for managing mysql in a cluster

## conceptions
* none

## purpose
* none

## precondition
* [create.local.cluster.with.kind](/kubernetes/create.local.cluster.with.kind.md)
* [installed ingress-nginx](/kubernetes/basic/ingress.nginx.md)
* [installed cert-manager](/kubernetes/basic/cert.manager.md)

### install phpmyadmin
1. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      # BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
      BASE_URL="https://resource.cnconti.cc/docker-images"
      for IMAGE in "docker.io_bitnami_phpmyadmin_5.1.1-debian-10-r147.dim" \
          "docker.io_bitnami_apache-exporter_0.10.1-debian-10-r54.dim"
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
      for IMAGE in "docker.io/bitnami/phpmyadmin:5.1.1-debian-10-r147" \
          "docker.io/bitnami/apache-exporter:0.10.1-debian-10-r54"
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
2. prepare [php.my.admin.values.yaml](resources/php.my.admin.values.yaml.md)
3. install by helm
    * NOTE: `https://resource-ops.lab.zjvis.net:32443/charts/charts.bitnami.com/bitnami/phpmyadmin-8.3.1.tgz`
    * ```shell
      helm install \
          --create-namespace --namespace application \
          my-phpmyadmin \
          https://resource.cnconti.cc/charts/charts.bitnami.com/bitnami/phpmyadmin-8.3.1.tgz \
          --values php.my.admin.values.yaml \
          --atomic
      ```

### test
1. check connection
    * ```shell
      curl --insecure --header 'Host: phpmyadmin.local' https://localhost
      ```
2. access `http://phpmyadmin.local`
    * address: `my-mariadb.application`
    * username: `root`
    * password:
        + ```shell
          kubectl get secret --namespace application my-mariadb \
              -o jsonpath="{.data.mariadb-root-password}" | base64 --decode && echo
          ```

## uninstallation
1. uninstall `phpmyadmin`
    * ```shell
      helm -n application uninstall my-phpmyadmin
      ```
