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
* 用户对单个namespace下的资源权限需求
  * ```text
    用户jeck 需要namespace(middleware)下resources(pods, services, configmaps)的读写(get,list,watch,patch,update)权限
    ```
  * ```shell
    kind: Role
    metadata:
      name: jeck-rw-role
      namespace: middleware
    rules:
      - apiGroups: [""] 
        resources: ["pods"]
        verbs: ["get", "watch", "list", "patch","update"]
    ```
  * ```shell
    kind: RoleBinding
    metadata:
      name: jack-rw-role-binding
      namespace: middleware
    subjects:
      - kind: ServiceAccount
        name: jack
        namespace: application
    roleRef:
      kind: Role
      name: jeck-rw-role
      apiGroup: "rbac.authorization.k8s.io"
    ```
* 用户对多个namespce下的资源权限需求
  * ```text
    用户bsyy需要namespace(application, middleware)下resources(pods, services, deployments, jobs)的只读(get, watch, list)权限
    ```
  * ```shell
    kind: ClusterRole
    metadata:
      name: bsyy-clusterrole-read
    rules:
      - apiGroups: [""]
        resources: ["pods" "services"]
        verbs: ["get", "watch", "list"]
      - apiGroups: ["apps"]
        resources: ["deployments"]
        verbs: ["get", "watch", "list"]
      - apiGroups: ["batch"]
        resources: ["jobs"]
        verbs: ["get", "watch", "list"]
    ```
  * ```shell
    kind: RoleBinding
    metadata:
      name: bsyy-clusterrole-read-binding
      namespace: middleware
    subjects:
      - kind: ServiceAccount
        name: bsyy
        namespace: application
      roleRef:
      kind: ClusterRole
      name: bsyy-clusterrole-read
      apiGroup: "rbac.authorization.k8s.io"
    ```
  * ```shell
    kind: RoleBinding
    metadata:
      name: bsyy-clusterrole-read-binding
      namespace: application
    subjects:
      - kind: ServiceAccount
        name: bsyy
        namespace: application
      roleRef:
      kind: ClusterRole
      name: bsyy-clusterrole-read
      apiGroup: "rbac.authorization.k8s.io"
    ```
* 用户对所有namespace下的资源权限需求
  * ```text
    用户rose需要所有namespace下的resource(pods, services)的只读权限(get, watch, list)
    ```
  * ```shell
    kind: ClusterRole
    metadata:
      name: bsyy-clusterrole-read
    rules:
      - apiGroups: [""]
        resources: ["pods", "services"]
        verbs: ["get", "watch", "list"]
    ```
  * ```shell
    kind: ClusterRoleBinding
    metadata:
      name: bsyy-clusterrole-read-binding
    subjects:
      - kind: ServiceAccount
        name: bsyy
        namespace: application
      roleRef:
      kind: ClusterRole
      name: bsyy-clusterrole-read
      apiGroup: "rbac.authorization.k8s.io"
    ```


