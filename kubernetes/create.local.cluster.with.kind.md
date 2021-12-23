### 创建kind集群

1. be sure your machine have 2 cores and 4G memory at least
2. [download kubernetes binary tools](download.kubernetes.binary.tools.md)
    * kind
    * kubectl
3. configuration
    * [kind.create.cluster.sh](resources/kind.create.cluster.sh.md)
4. create cluster
    * ```shell
      bash kind.create.cluster.sh
      ```
5. check with kubectl
    * ```shell
      kubectl get node -o wide
      kubectl get pod --all-namespaces
      ```
6. delete cluster
    * ```shell
      kind delete cluster
      ```

### useful commands

1. check images loaded by node
    + ```shell
      docker exec -it kind-control-plane crictl images
      ```
