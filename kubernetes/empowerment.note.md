# Empowerment note

```shell
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: application
rules:
- apiGroups: [""] # "" 标明 core API 组
  resources: ["pods"]
  verbs: ["get", "watch", "list", "create"]
EOF

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

cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: conti-read
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
EOF

cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: conti-read-b
  namespace: application
subjects:
  - kind: ServiceAccount
    name: conti
    namespace: application
roleRef:
  kind: ClusterRole
  name: conti-read
  apiGroup: "rbac.authorization.k8s.io"
EOF
```