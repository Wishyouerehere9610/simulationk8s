#  local

* roles
    + master: TH51-10.0.0.128
    + worker1: TH52-10.0.0.129
    + worker2: TH53-10.0.0.130
    + worker3: TH54-10.0.0.131
* TODO: [k8s installation](README.md)
* basic-components
    + [ingress-nginx](basic/ingress-nginx.md)
    + [cert-manager](basic/cert-manager.md)
    + [docker-registry](basic/docker.registry.md)
* middleware-nebula
    + [mariadb](middleware-nebula/mariadb.md)
    + [minio](middleware-nebula/minio.md)
    + [redis-cluster](middleware-nebula/redis-cluster.md)
* application
    * [gitea](gitea.md)
    * [dashboard](dashboard.md)
    * [verdaccio](application/verdaccio)
    * [nexus](application/nexus)
* monitor
    * [kube-prometheus-stack](monitor/kube-prometheus-stack.md)
* [haproxy](haproxy.md)
