# RBAC 

## subject
* ```text
  user, group, serviceaccount 
  ```
### SA 示例
* ```shell
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    name: conti-test  # sa-name
    namespace: test   # sa-namespace
  labels:
    app.kubernetes.io/service: my-sshd
  ```
## object
* ```shell
  # 查看resources与apigroup组的包含关系
  kubectl api-resources 
  ```
* ```yaml
  # basic object
  - apiGroup:[""]
    resource:
      -"bindings"
      -"componentstatuses"
      -"configmaps"
      -"endpoints"
      -"events"
      -"limitranges"
      -"namespaces"
      -"nodes"
      -"persistentvolumeclaims"
      -"persistentvolumes"
      -"pods"
      -"podtemplates"
      -"replicationcontrollers"
      -"resourcequotas"
      -"secrets"
      -"serviceaccounts"
      -"services"
  
  - apiGroup:["apps"]
    resource:
      -"controllerrevisions"
      -"daemonsets"
      -"deployments"
      -"replicasets"
      -"statefulsets"
  
  - apiGroup:["batch"]
    resource:
      -"cronjobs"
      -"jobs"
  
  - apiGroup:["storage.k8s.io"]
    resource:
      -"csidrivers"
      -"csinodes"
      -"storageclasses"
      -"volumeattachment"
  
  - apiGroup:["rbac.authorization.k8s.io"]
    resource:
      -"clusterrolebindings"
      -"clusterroles"
      -"rolebindings"
      -"roles"
  
  -apiGroup:["networking.k8s.io"]
    resource:
      -"ingressclasses"
      -"ingresses"
      -"networkpolicies"           
  ```

## action: 
* ```text
  verbs:
    - "create"
    - "delete"
    - "deletecollection"
    - "get"
    - "list"
    - "patch"
    - "update"
    - "watch"
    - "impersonate"
  ```

## Role 示例

* 允许在核心API Group中读取“pods”资源:
  ```yaml
  rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]
  ```
* 允许在“extensions”和“apps”API Group中读/写“deployments”
  ```yaml
  rules:
  - apiGroups: ["extensions", "apps"]
    resources: ["deployments"]
    verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
* 允许读取 “Pod” 和 读/写 “jobs”
  ```yaml
  rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]
  - apiGroups: ["batch", "extensions"]
    resources: ["jobs"]
    verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
* 允许读取名称为 “my-config” 的 ConfigMap
  ```yaml
  rules:
  - apiGroups: [""]
    resources: ["configmaps"]
    resourceNames: ["my-config"]
    verbs: ["get"]
* 允许读取核心 Group中资源“Node”（Node属于集群范围，则必须将ClusterRole绑定ClusterRoleBinding）
  ```yaml
  rules:
  - apiGroups: [""]
    resources: ["nodes"]
    verbs: ["get", "list", "watch"]
* 允许非资源型“/ healthz”和所有子路径进行 “GET”和“POST”请求：（必须将ClusterRole绑定ClusterRoleBinding）：
  ```yaml
  rules:
  - nonResourceURLs: ["/healthz", "/healthz/*"] # '*' in a nonResourceURL is a suffix glob match
    verbs: ["get", "post"]

## illustrate
* 单个namespace下的资源权限需求
  * prepare [rbac.test.yaml](rbac.test.yaml.md)
  * ```shell
    # namespace(test)下resources(pods, services, configmaps)的读写(get,list,watch,patch,update)权限
    kubectl -n test apply -f rbac.test.yaml
    ```
* 多个namespce下的资源权限需求
  * prepare [rbac.cluster.test.yaml](rbac.cluster.test.yaml.md)
  * ```shell
    # namespace(application, middleware)下resources(pods, services, deployments, jobs)的只读(get, watch, list)权限
    kubectl -n test apply -f rbac.cluster.test.yaml
    ```
* 用户Token信息获取
  * ```shell
    kubectl -n test get secret $(kubectl -n test get sa conti-test -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode && echo
    ```


