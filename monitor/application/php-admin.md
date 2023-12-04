## phpmyadmin
#### CName:
* `phpmyadmin-ops-dev.lab.zjvis.net`
* `ops-dev-01.lab.zjvis.net`

### install phpmyadmin
1. prepare [phpmyadmin.values.yaml](resources/phpmyadmin.values.yaml.md)
2. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
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
      DOCKER_REGISTRY="docker-registry-simulation.lab.zjvis.net:32443"
      for IMAGE in "docker.io/bitnami/phpmyadmin:5.1.1-debian-10-r147" \
          "docker.io/bitnami/apache-exporter:0.10.1-debian-10-r54"
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
3. install by helm
   * ```shell
     helm install \
     --create-namespace --namespace application \
     my-phpmyadmin \
     https://resource-ops.lab.zjvis.net:32443/charts/charts.bitnami.com/bitnami/phpmyadmin-8.3.1.tgz \
     --values phpmyadmin.values.yaml \
     --atomic
      ```

## test
1. check connection
     ```
     curl --insecure --header 'Host: phpmyadmin-ops-simulation.lab.zjvis.net' https://localhost:32080
     
2. how to login
    ```
    service:my-mariadb.middleware(db'spodname)
    user：root(auth secret user)
    password: ***** (auth secret password)
   
## uninstallation
1. uninstall `phpmyadmin`
    * ```shell
      helm -n application uninstall my-phpmyadmin
