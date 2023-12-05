## nacos

### precondition
* [mariadb](../middleware/mariadb.md)

### installation
1. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops-dev.lab.zjvis.net:32443/docker-images"
      for IMAGE in "docker.io_nacos_nacos-server_v2.2.0.dim"
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
      for IMAGE in "docker.io/nacos/nacos-server:v2.2.0"
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
2. create database `nacos`
    * ```shell
      kubectl -n middleware exec -it deployment/mariadb-tool -- bash -c \
          'echo "create database nacos" | mysql -h my-mariadb.middleware -uroot -p$MARIADB_ROOT_PASSWORD'
      ```
3. prepare initialization `mariadb`
    * initialization `nacos` use [nacos.initialize.mariadb.20230320.sql](resources/nacos.initialize.mariadb.20230320.sql.md)
    * ```shell
      POD_NAME=$(kubectl get pod -n middleware -l "app.kubernetes.io/name=mariadb-tool" -o jsonpath="{.items[0].metadata.name}") \
      && export SQL_FILENAME="nacos.initialize.mariadb.20230320.sql" \
      && kubectl -n middleware cp ${SQL_FILENAME} ${POD_NAME}:/tmp/${SQL_FILENAME} \
      && kubectl -n middleware exec -it ${POD_NAME} -- bash -c \
             "mysql -h my-mariadb.middleware -uroot -p\${MARIADB_ROOT_PASSWORD} nacos < /tmp/nacos.initialize.mariadb.20230320.sql"
      ```
4. Obtain `mariadb` password
    * ```shell
      kubectl get secret --namespace middleware my-mariadb \
             -o jsonpath="{.data.mariadb-root-password}" | base64 --decode && echo
      ```
5. prepare helm values [nacos.values.yaml](resources/nacos.values.yaml.md)
   * modify `mariadb` password
6. install `nacos` by helm
    * ```shell
      helm install \
          --create-namespace --namespace application \
          my-nacos \
          https://resource-ops.lab.zjvis.net/charts/ygqygq2.github.io/charts/nacos-2.1.4.tgz \
          --values nacos.values.yaml \
          --timeout 1200s \
          --atomic
      ```

### test
1. connect to `nacos`
    * `http://nacos-simulation.cnconti.cc/nacos`
    * username: `nacos`
    * password: `Nacos@1234`
2. `nacos` create namespace
    * ![img.png](img.png)
3. `nacos` create Configuration
    * Query `middleware & password` and modify content
    * ![img_1.png](img_1.png)
4. configuration example
   *  [simulation-bootstrap.yaml](resources/simulation-bootstrap.yaml.md)
   *  modify `mariadb` password
   *  modify `redis-cluster` password
   *  modify `minio` accessKey、secretKey
   *  modify `influx` password
       
### uninstall
1. uninstall `my-nacos`
    * ```shell
      helm -n application uninstall my-nacos
      ```
    
