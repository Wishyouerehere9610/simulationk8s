#  local

* roles
    + master: z51-192.168.31.51
    + worker1: z52-192.168.31.52
    + worker2: z53-192.168.31.53
    + worker3: z54-192.168.31.54
* [k8s installation](k8s.installation.md)
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
