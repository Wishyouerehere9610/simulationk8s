# SSHD springboard machine

## mainusage
* K8s cluster springboard machine

## conceptions
* none

## purpose
* Provide a unified access environment for development, operation and maintenance

## precondition
* [create local cluster for testing](/kubernetes/basic/local.cluster.for.testing.md)

## do it
* prepart [sshd.values.yaml](sshd/sshd.values.yaml.md)
* prepare images
  * ```shell
    for IMAGE in "busybox:1.35" \
            "docker.io/panubo/sshd:1.5.0"
    do
        LOCAL_IMAGE="localhost:5000/$IMAGE"
        docker image inspect $IMAGE || docker pull $IMAGE
        docker image tag $IMAGE $LOCAL_IMAGE
        docker push $LOCAL_IMAGE
    done
    ```
* prepare chart
  * ```shell
    git clone --single-branch --branch dev https://github.com/ContiCat/sshd.git sshd
    ```
* install by helm
  * ```shell
    helm install \
        --create-namespace --namespace application \
        my-sshd ./sshd \
        --values sshd.values.yaml \
        --atomic
    ```
    
## test
* Exposed port
  * ```shell
    kubectl --namespace application port-forward svc/my-sshd  --address 0.0.0.0 2222:2222
    ```
* Login
  * ```shell
    # username: sshdtest
    # password: AAaa1234
    ssh -o "UserKnownHostsFile /dev/null" -o "StrictHostKeyChecking no" -p 2222 sshdtest@localhost
    
    # 用户可以获取自己的sshd服务pod的TOKEN信息
    cat /var/run/secrets/kubernetes.io/serviceaccount/token
    
    ```
* rbac test
  * ```shell
    # role test
    kubectl get pod -n application
    
    # clusterrole test
    kubectl get pod -A
    ```
    
* 用户创建
  * 单个namespace的管理员权限
    * prepare [rbac.namespace.admin.yaml](sshd/1.rbac.yaml.md)
    * ```shell
      kubectl -n application apply -f rbac.namespace.admin.yaml
      ```
  * 单个namespace的只读权限
    * prepare [rbac.namespace.view.yaml](sshd/1.rbac.yaml.md)
    * ```shell
      kubectl -n application apply -f rbac.namespace.view.yaml
      ```
  * 单个namespace的读写权限
    * prepare [rbac.namespace.edit.yaml](sshd/1.rbac.yaml.md)
    * ```shell
      kubectl -n application apply -f rbac.namespace.edit.yaml
      ```
  * cluster的只读权限
    * prepare [rbac.namespace.edit.yaml](sshd/1.rbac.yaml.md)
    * ```shell
      # 这里要注意serviceaccount的namespace
      kubectl apply -f rbac.cluster.view.yaml
      ```
  * cluster的读写权限
    * prepare [rbac.namespace.edit.yaml](sshd/1.rbac.yaml.md)
    * ```shell
      # 这里要注意serviceaccount的namespace
      kubectl apply -f rbac.cluster.edit.yaml
      ```    
  * [自定义权限](../resources/rbac.md)