## simualtion-backend

### precondition
* [nacos](../application/nacos.md)
* [mariadb](../middleware/mariadb.md)
* [minio](../middleware/minio.md)
* [redis-cluster](../middleware/redis-cluster.md)

### installation
1. create database `simulation`
    * ```shell
      kubectl -n middleware exec -it deployment/mariadb-tool -- bash -c \
          'echo "create database simulation" | mysql -h my-mariadb.middleware -uroot -p$MARIADB_ROOT_PASSWORD'
      ```
2. prepare initialization `simulation`
    * initialization `simulation` use `simulation.initialize.mariadb.20231127.sql`
    * ```shell
      POD_NAME=$(kubectl get pod -n middleware -l "app.kubernetes.io/name=mariadb-tool" -o jsonpath="{.items[0].metadata.name}") \
          && export SQL_FILENAME="simulation.initialize.mariadb.20231127.sql" \
          && kubectl -n middleware cp ${SQL_FILENAME} ${POD_NAME}:/tmp/${SQL_FILENAME} \
          && kubectl -n middleware exec -it ${POD_NAME} -- bash -c \
                 "mysql -h my-mariadb.middleware -uroot -p\${MARIADB_ROOT_PASSWORD} simulation < /tmp/simulation.initialize.mariadb.20231127.sql"
      ```
3. prepare helm values 
    * prepare [simulation-backend.values.yaml](resources/simulation-backend.values.yaml.md)
   
4. install `simulation-backend` by helm
    * ```shell
      helm install \
          --create-namespace --namespace simulation \
          simulation-backend \
          java \
          --repo https://chartmuseum-ops-dev.lab.zjvis.net:32443 \
          --version 1.0.0-C4f979aa \
          --values simulation-backend.values.yaml \
          --atomic
      ```
6. upgrade `simulation-backend` by helm
    * change [simulation.backend.values.yaml](resources/simulation-backend.values.yaml.md)
    * ```shell
      helm upgrade --namespace simulation \
          simulation-backend \
          java \
          --repo https://chartmuseum-ops-dev.lab.zjvis.net:32443 \
          --version 1.0.0-C4f979aa \
          --values simulation-backend.values.yaml \
          --atomic
      ```

### test
   * http://simulation.cnconti.cc:32080/


### uninstall
1. uninstall `simulation-backend`
    * ```shell
      helm -n simulation uninstall simulation-backend
      ```
