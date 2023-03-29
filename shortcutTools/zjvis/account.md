## dashboard
* ```shell
  # token
  kubectl -n application get secret \
      $(kubectl -n application get ServiceAccount dashboard-ro \
      -o jsonpath="{.secrets[0].name}") \
      -o jsonpath="{.data.token}" | base64 --decode && echo
  ```

## mariadb
* username: `root`
* ```shell
  # password
  NAMESPACE="middleware-test"
  kubectl get secret --namespace ${NAMESPACE} my-mariadb \
      -o jsonpath="{.data.mariadb-root-password}" | base64 --decode && echo
  ```

## minio
* ```shell
  # access-key & secret-key
  NAMESPACE="middleware-test"
  kubectl get secret --namespace ${NAMESPACE} my-minio \
      -o jsonpath="{.data.access-key}" | base64 --decode && echo
  kubectl get secret --namespace ${NAMESPACE} my-minio \
      -o jsonpath="{.data.secret-key}" | base64 --decode && echo
  ```

## minio-2022
* ```shell
  # access-key & secret-key
  NAMESPACE="middleware-test"
  kubectl get secret --namespace ${NAMESPACE} my-minio \
      -o jsonpath="{.data.root-user}" | base64 --decode && echo
  kubectl get secret --namespace ${NAMESPACE} my-minio \
      -o jsonpath="{.data.root-password}" | base64 --decode && echo
  ```

## cassandra
* ```shell
  NAMESPACE="middleware-test"
  kubectl -n ${NAMESPACE} get secret my-cassandra \
      -o jsonpath={.data.cassandra-password} | base64 --decode && echo
  ```
## postgresql
* ```shell
  NAMESPACE="middleware-test"
  kubectl -n ${NAMESPACE} get secret my-postgresql \
      -o jsonpath={.data.postgres-password} | base64 --decode && echo
  ```

## redis-cluster
* ```shell
  # password
  NAMESPACE="middleware-test"
  kubectl -n ${NAMESPACE} get secret my-redis-cluster \
      -o jsonpath={.data.redis-password} | base64 --decode && echo
  ```

## verdaccio
* ```shell
  # username & password
  kubectl -n application get secret verdaccio-admin-secret \
      -o jsonpath={.data.username} | base64 --decode && echo
  kubectl -n application get secret verdaccio-admin-secret \
      -o jsonpath={.data.password} | base64 --decode && echo
  ```

## nexus
* username: `admin`
* ```shell
  # password
  kubectl -n application get secret nexus-admin-secret \
      -o jsonpath={.data.password} | base64 --decode && echo
  ```

## jupyterhub
* username: `admin`
* password: `a-shared-secret-password`

## grafana
* username: `admin`
* ```shell
   # password
  kubectl -n monitor get secret my-kube-prometheus-stack-grafana \
      -o jsonpath="{.data.admin-password}" | base64 --decode && echo
  ```

