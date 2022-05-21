# ZJVIS

## docker-registry
* ops: https://docker-registry-ops.lab.zjvis.net:32443/v2/_catalog
* ops-test: https://docker-registry-ops-test.lab.zjvis.net:32443/v2/_catalog

## dashboart
* token
    * ```shell
    kubectl -n application get secret \
        $(kubectl -n application get ServiceAccount dashboard-ro \
        -o jsonpath="{.secrets[0].name}") \
        -o jsonpath="{.data.token}" | base64 --decode && echo
    ```

## chart-museum
* ops: https://chartmuseum-ops.lab.zjvis.net:32443/api/charts
* ops-test: https://chartmuseum-ops-test.lab.zjvis.net:32443/api/charts
* 

## mariadb
* username: `root`
* password
    * ```shell
    NAMESPACE="middleware-nebula-test"
    kubectl get secret --namespace ${NAMESPACE} my-mariadb \
        -o jsonpath="{.data.mariadb-root-password}" | base64 --decode && echo
    ```

## minio
* username & password
    * ```shell
    NAMESPACE="middleware-nebula-test"
    kubectl get secret --namespace ${NAMESPACE} my-minio \
        -o jsonpath="{.data.access-key}" | base64 --decode && echo
    kubectl get secret --namespace ${NAMESPACE} my-minio \
        -o jsonpath="{.data.secret-key}" | base64 --decode && echo
    ```

## redis-cluster
* password
    * ```shell
    NAMESPACE="middleware-nebula-test"
    kubectl -n ${NAMESPACE} get secret my-redis-cluster \
        -o jsonpath={.data.redis-password} | base64 --decode && echo
    ```

## verdaccio
* username & password
    * ```shell
    kubectl -n application get secret verdaccio-admin-secret \
        -o jsonpath={.data.username} | base64 --decode && echo
    kubectl -n application get secret verdaccio-admin-secret \
        -o jsonpath={.data.password} | base64 --decode && echo
    ```

## nexus
* username: `admin`
* password
    * ```shell
    kubectl -n application get secret nexus-admin-secret \
        -o jsonpath={.data.password} | base64 --decode && echo
    ```

## jupyterhub
* username: `admin`
* password: `a-shared-secret-password`

## grafana
* username: `admin`
* password
    * ```shell
    kubectl -n monitor get secret my-kube-prometheus-stack-grafana \
        -o jsonpath="{.data.admin-password}" | base64 --decode && echo
    ```
  
Copy to clipboard