## dashboard
* ```shell
  # token
  NAMESPACE="application" \
      && kubectl -n ${NAMESPACE} get secret \
         $(kubectl -n ${NAMESPACE} get ServiceAccount dashboard-ro \
         -o jsonpath="{.secrets[0].name}") \
         -o jsonpath="{.data.token}" | base64 --decode && echo
  ```

## mariadb
* username: `root`
* ```shell
  NAMESPACE="middleware" \
      && kubectl get secret --namespace ${NAMESPACE} my-mariadb \
         -o jsonpath="{.data.mariadb-root-password}" | base64 --decode && echo
  ```

## minio
* ```shell
  NAMESPACE="middleware" \
      && kubectl get secret --namespace ${NAMESPACE} my-minio \
         -o jsonpath="{.data.access-key}" | base64 --decode && echo \
      && kubectl get secret --namespace ${NAMESPACE} my-minio \
         -o jsonpath="{.data.secret-key}" | base64 --decode && echo
  ```
* ```shell
  NAMESPACE="middleware" \
      && kubectl get secret --namespace ${NAMESPACE} my-minio \
         -o jsonpath="{.data.root-user}" | base64 --decode && echo \
      && kubectl get secret --namespace ${NAMESPACE} my-minio \
         -o jsonpath="{.data.root-password}" | base64 --decode && echo
  ```

## redis
* ```shell
  # password
  NAMESPACE="middleware" \
      && kubectl -n ${NAMESPACE} get secret my-redis \
         -o jsonpath={.data.redis-password} | base64 --decode && echo
  ```
  
## redis-cluster
* ```shell
  # password
  NAMESPACE="middleware" \
      && kubectl -n ${NAMESPACE} get secret my-redis-cluster \
         -o jsonpath={.data.redis-password} | base64 --decode && echo
  ```
## influx

* ```shell
  # get secret name
  kubectl -n middleware get secret
  ```

* ```shell
  # user
  kubectl get secret my-influxdb-auth -o "jsonpath={.data['influxdb-user']}" --namespace middleware | base64 --decode

  # password
  kubectl get secret my-influxdb-auth -o "jsonpath={.data['influxdb-password']}" --namespace middleware | base64 --decode
  ```

  
  
## postgresql
* username: `postgres`
* ```shell
  NAMESPACE="middleware" \
      && kubectl -n ${NAMESPACE} get secret my-postgresql \
         -o jsonpath={.data.postgres-password} | base64 --decode && echo
  ```

## cassandra
* username: `cassandra`
* ```shell
  NAMESPACE="middleware" \
      && kubectl -n ${NAMESPACE} get secret my-cassandra \
         -o jsonpath={.data.cassandra-password} | base64 --decode && echo
  ```

## verdaccio
* ```shell
  NAMESPACE="application" \
      && kubectl -n ${NAMESPACE} get secret verdaccio-admin-secret \
         -o jsonpath={.data.username} | base64 --decode && echo \
      && kubectl -n ${NAMESPACE} get secret verdaccio-admin-secret \
         -o jsonpath={.data.password} | base64 --decode && echo
  ```

## nexus
* username: `admin`
* ```shell
  NAMESPACE="application" \
      && kubectl -n ${NAMESPACE} get secret nexus-admin-secret \
         -o jsonpath={.data.password} | base64 --decode && echo
  ```

## jupyterhub
* username: `admin`
* password: `a-shared-secret-password`

## grafana
* username: `admin`
* ```shell
  NAMESPACE="monitor" \
      && kubectl -n ${NAMESPACE} get secret my-kube-prometheus-stack-grafana \
         -o jsonpath="{.data.admin-password}" | base64 --decode && echo
  ```

