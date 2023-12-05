## simulation-231129-kubeadm
* role
    + master: `simulation-01`
    + worker: `simulation-02` ~ `simulation-03`

### installation
* [k8s_installation](k8s_installation.md)
* basic-components
    + [ingress-nginx](basic-components/ingress-nginx.md)
    + [cert-manager](basic-components/cert-manager.md)
    + [docker-registry](basic-components/docker-registry.md)
* application
  * [nacos](application/nacos.md)
  * [grafana](application/grafana.md)
  * [influxdb](middleware/influxdb.md)
* middleware
  + [mariadb](middleware/mariadb.md)
  + [minio](middleware/minio.md)
  + [redis-cluster](middleware/redis-cluster.md)
* simulation
  + [simulation-backend](simulation/simulation-backend.md)
  + [simulation-frontend](simulation/simulation-frontend.md)

### kubeadm rest
   * [kubeadm reset](kubeadm-reset.md)