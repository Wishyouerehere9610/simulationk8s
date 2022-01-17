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
    for IMAGE in "docker.io/panubo/sshd:1.5.0"
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
    # username: sshdguest
    # password: AAaa1234
    ssh -o "UserKnownHostsFile /dev/null" -o "StrictHostKeyChecking no" -p 2222 sshdguest@localhost
    ```
* rbac test
  * ```shell
    kubectl --namespace application get pod
    ```
    
### RBAC
* pass上边案例是单个namespace的赋权
  * prepart [sshd.test1.values.yaml](sshd/sshd.values.yaml.md)
  * ```shell

```
* 


## 业务场景
```text
namespace: application, basic-components, middleware
pods: nginx-pod, gitea-pod, mysql-pod, Rediscluster-pod, my-
service:
secret: Rediscluster-svc
serviceaccount:
```
* 用户A1需求application中pod资源的只读权限
* 用户A2需求middleware中


* 运维人员需要查看数据库运行情况
  ```yaml
  apiVersion: rbac.authorization.k8s.io/v1
  kind: Role
  metadata: 
    name: Rediscluster-read
    namespace: middleware
  rules:
  - apiGroups: [""]
    resources: ["pods", "services"]
    verbs: ["get", "watch", "list"]
    EOF
  ---
  apiVersion: rbac.authorization.k8s.io/v1
  kind: RoleBinding
  metadata:
  name: read-pods-rd
  namespace: application
  subjects:
    - kind: ServiceAccount
      name: libk
      namespace: application
  roleRef:
    kind: Role
    name: pod-reader
  apiGroup: "rbac.authorization.k8s.io"
  ```
* DBA需要获取一个pod 还需要调整mysql的一些参数

* 开发人员A需要middleware下mysql的读权限



* 





* 开发人员D1访问Rediscluster的服务进行查看状态的的需求
  ```yaml
  apiVersion: rbac.authorization.k8s.io/v1
  kind: Role
  metadata: 
  name: Rediscluster-read
  namespace: middleware
  rules:
  - apiGroups: [""]
    resources: ["namespaces", "endpoints","pods", "services"]
    verbs: ["get", "watch", "list", ]
    EOF
  ---
  cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
name: read-pods-rd
namespace: application
subjects:
- kind: ServiceAccount
  name: libk
  namespace: application
  roleRef:
  kind: Role
  name: pod-reader
  apiGroup: "rbac.authorization.k8s.io"
  EOF
  ```


    
* sa namespace rouserc
  * 访问所有namespace的所有资源的权限(仅展示)
    * ```yaml
      rules:
        - apiGroups: ['*']
          resources: ['*']
          verbs: ['*']
      ```
  * 基础 apiGroups及其resources
    * ```yaml
        - apiGroups: [""]
          resources:
            - "nodes"
            - "namespaces"
            - "configmaps"
            - "endpoints"
            - "persistentvolumes"
            - "persistentvolumeclaims"
            - "secrets"
            - "services"
            - "pods"
        - apiGroups: ["apps"]
          resources:
            - "statefulsets"
            - "replicasets" 
            - "deployments"
            - "daemonsets"
        - apiGroups: ["batch"]
            - "cronjobs"
            - "jobs"
        - apiGroups: ["storage.k8s.io"]
            - "storageclasses"
      ```
  * 基础 操作
    * [基础resource常规操作](sshd/resource-verbvs.yaml.md)
    
* 常见的赋权场景
  * 用户conti 访问application下的pod资源的get权限
      * ```yaml
        apiVersion: rbac.authorization.k8s.io/v1
        kind: Role
        metadata:
        name: pod-reader
        namespace: application
        rules:
        - apiGroups: [""]
        resources: ["pod"]
        verbs: ["get", "watch", "list", "create"]
        ```
      * ```yaml
        apiVersion: rbac.authorization.k8s.io/v1
        kind: RoleBinding
        metadata:
        name: read-pods-rd
        subjects:
        - kind: ServiceAccount
          name: conti
          namespace: application
          roleRef:
          kind: Role
          name: pod-reader
          apiGroup: "rbac.authorization.k8s.io"
        ```
  * 用户conti 访问所有namespace下的pod资源的get权限
      * ``````
      

* 常见的apiGroups
  * ```yaml
    - apiGroups: [""]
      resources: 
        - "nodes"
        - "namespaces"
        - "configmaps"
        - "endpoints"
        - "persistentvolumes"
        - "persistentvolumeclaims"
        - "secrets"
        - "services"
        - "pods"
    - apiGroups: ["apps"]
```
  * namspace内权限规整
    *    - apiGroups: [""]
          resources: [", "endpoints", "persistentvolumes", "persistentvolumeclaims", "secrets", "services", "pods"]
          verbs: ["get", "list", "watch"]
        - apiGroups: ["apps"]
          resources: ["statefulsets", "replicasets", "deployments", "daemonsets"]
          verbs: ["get", "list", "watch"]
        - apiGroups: ["batch"]
          resources: ["cronjobs", "jobs"]
          verbs: ["get", "list", "watch"]
        - apiGroups: ["storage.k8s.io"]
          resources: ["storageclasses"]
          verbs: ["get", "list", "watch"]



    * ```yaml
      rules:
        - apiGroups: [""]
          resources: ["nodes", "namespaces", "configmaps", "endpoints", "persistentvolumes", "persistentvolumeclaims", "secrets", "services", "pods"]
          verbs: ["get", "list", "watch"]
        - apiGroups: ["apps"]
          resources: ["statefulsets", "replicasets", "deployments", "daemonsets"]
          verbs: ["get", "list", "watch"]
        - apiGroups: ["batch"]
          resources: ["cronjobs", "jobs"]
          verbs: ["get", "list", "watch"]
        - apiGroups: ["storage.k8s.io"]
          resources: ["storageclasses"]
          verbs: ["get", "list", "watch"] 
      ```
    * clusterrole
  * 访问单个namespace的所有资源的权限
    * namespace role
  * 访问部分namespace的所有资源的权限
    创建多个rolebinding绑定部分namespace role
  * 资源对象分类
    * 单个资源对象
    * 多个资源对象
    * 

* 允许访问pod资源
```yaml
rules:
- apiGroup: [""]
  resource: ["pod"]
  verbs: ["get", "list", "watch"]
```
    





















