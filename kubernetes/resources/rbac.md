## RBAC 授权 showcase

### RBAC概念公式
```text
role/clusterrole = object + action
单个namespace授权: rolebinding = subject + role/clusterRole 
多个namespace授权: 多个rolebinding  = subject + clusterRole
整个集群授权： clusterRoleBinding = subject + clusterRole
```

主体subject
```text
user, group, serviceaccount 权限最终落地的对象
```

集群资源object
```shell
# 查看resources与apigroup组的包含关系
kubectl api-resources 
```
```yaml
# 基础object
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
  
# 其他              
mutatingwebhookconfigurations       "admissionregistration.k8s.io"     
validatingwebhookconfigurations     "admissionregistration.k8s.io"     
customresourcedefinitions           "apiextensions.k8s.io"     
apiservices                         "apiregistration.k8s.io"        
tokenreviews                        "authentication.k8s.io"     
localsubjectaccessreviews           "authorization.k8s.io"     
selfsubjectaccessreviews            "authorization.k8s.io"     
selfsubjectrulesreviews             "authorization.k8s.io"     
subjectaccessreviews                "authorization.k8s.io"     
horizontalpodautoscalers            "autoscaling"     
endpointslices                      "discovery.k8s.io"     
events                              "events.k8s.io"     
flowschemas                         "flowcontrol.apiserver.k8s.iobeta1"     
prioritylevelconfigurations         "flowcontrol.apiserver.k8s.iobeta1"        
runtimeclasses                      "node.k8s.io"     
poddisruptionbudgets                "policy"      
podsecuritypolicies                 "policybeta1"           
priorityclasses                     "scheduling.k8s.io"         
csistoragecapacities                "storage.k8s.iobeta1"
```

操作action: 
```text
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

### 案例场景
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


