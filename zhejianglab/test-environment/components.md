### components

1. storage class provided by `rook-ceph`
    * storage class = `rook-cephfs-01`
    * namespace = `rook-ceph`
2. `docker-registry`
    * exposed by `NodePort`, which means it can be accessed from any node in the k8s cluster
    * address = `docker-registry-test.lab.zjvis.net:32500` or `$ANY_NODE_IN_CLUSTER:32500`
    * http only, which means it's not secure
    * namespace = `base-service`
3. `cassandra`
    * namespace = `middleware`
    * exposed by `ClusterIP` which means it can only be accessed in the k8s cluster
    * address in cluster = `my-cassandra.middleware:9042`
4. `mariadb`, which is the same as `mysql`
    * namespace = `middleware`
    * exposed by `ClusterIP`
    * address in cluster = `my-mariadb.middleware:3306`
5. `minio`
    * namespace = `middleware`
    * exposed by `ClusterIP`
    * address in cluster = `my-minio.middleware:9000` and `my-mariadb.middleware:9001`
6. `redis-cluster`
    * namespace = `middleware`
    * exposed by `ClusterIP`
    * address in cluster = `my-redis-cluster.middleware:6379`
7. `nebula-ce-backend`
    * namespace = `middleware`
    * exposed by `NodePort`
    * address in cluster = `nebula-ce-backend.nebula:80` and `nebula-ce-backend.nebula:1080`
    * address exposed to outside the cluster: `$ANY_NODE_IN_CLUSTER:30277` and `$ANY_NODE_IN_CLUSTER:30337`
8. `nebula-ce-frontend`
    * namespace = `middleware`
    * exposed by `NodePort`
    * address in cluster = `nebula-ce-frontend.nebula:80`
    * address exposed to outside the cluster: `$ANY_NODE_IN_CLUSTER:31879`
    * example of address exposed outside, `http://k8s-test-01.lab.zjvis.net:31879/`
9. `greenplum` **not in k8s cluster**
10. `cdh` **not in k8s cluster**
    * spark
    * hdfs
    * yarn
    * zeppelin
    * spark job server
