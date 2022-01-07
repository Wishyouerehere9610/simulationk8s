## SSHD

### mainusage
* 跳板机

### conceptions
* none

### purpose
* 跳板机

### precondition
* K8S

### do it
* prepart [entry]()
* prepart [dockerfile]()
* Make image 
  * images directory `./sshd_docker`
  * ```dockerfile
    docker build -t conti2021.icu/sshd:0.1.1 ./sshd_docker
    ```
* prepart [sshd.values.yaml](sshd.values.yaml.md)
* prepare images
  * ```shell
    for IMAGE in "conti2021.icu/sshd:0.1.1"
    do
        LOCAL_IMAGE="localhost:5000/$IMAGE"
        docker image inspect $IMAGE || docker pull $IMAGE
        docker image tag $IMAGE $LOCAL_IMAGE
        docker push $LOCAL_IMAGE
    done
    ```
* install by helm
  * ```shell
    helm install \
        --create-namespace --namespace application \
        my-sshd ./sshd \
        --atomic
    ```
    

### CREATE USER & ServiceAccount
* create ServiceAccount
  * ```shell
    kubectl create -f - <<EOF
    apiVersion: v1
    kind: ServiceAccount
    metadata:
    name: ${USER}
    namespace: ${NAMESPACE}
    automountServiceAccountToken: false
    EOF
    ```
* Create user and bind with ServiceAccount
  * ```shell
    SECRET=$( kubectl get secret -n ${NAMESPACE} | grep "^${USER}-token" | awk '{print $1}' )
    TOKEN=$( kubectl get secret ${SECRET} -n ${NAMESPACE} -o jsonpath={.data.token} | base64 -d )
    PODNAME=$( kubectl get pod -n ${NAMESPACE} | grep 'sshd' | awk '{print $1}' )
    
    kubectl -n application exec -ti "${PODNAME}" -- /bin/bash <<EOF
    /usr/sbin/useradd ${USER} -m -s /bin/bash
    EOF
    
    kubectl -n application exec -ti "${PODNAME}" -- su ${USER} <<EOF
    /bin/kubectl config set-cluster ${KUBE_NAME} --server=${KUBE_APISERVER} --insecure-skip-tls-verify=true --kubeconfig=/home/${USER}/.kube/config
    /bin/kubectl config set-credentials ${USER} --token=${TOKEN} --kubeconfig=/home/${USER}/.kube/config
    /bin/kubectl config set-context ${USER}@${KUBE_NAME} --cluster=${KUBE_NAME} --user=${USER} --kubeconfig=/home/${USER}/.kube/config
    /bin/kubectl config use-context ${USER}@${KUBE_NAME} --kubeconfig=/home/${USER}/.kube/config
    EOF
    ```

### Weighting operation
* create clusterrole & clusterrolebinding
  * create clusterrole
    * ```shell
      cat <<EOF | kubectl apply -f -
      apiVersion: rbac.authorization.k8s.io/v1
      kind: ClusterRole
      metadata:
      name: read-clusterrole
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
      ```
  * create clusterrolebinding
    * ```shell
      cat <<EOF | kubectl apply -f -
      apiVersion: rbac.authorization.k8s.io/v1
      kind: ClusterRoleBinding
      metadata:
      name: conti-read-clusterrole
      namespace: application
      subjects:
      - kind: ServiceAccount
        name: conti
        namespace: application
        roleRef:
        kind: ClusterRole
        name: read-clusterrole
        apiGroup: "rbac.authorization.k8s.io"
      EOF
      ```

* create role & rolebinding
  * create role
    * ```shell
      cat <<EOF | kubectl apply -f -
      apiVersion: rbac.authorization.k8s.io/v1
      kind: Role
      metadata:
      name: pod-reader-role
      namespace: application
      rules:
      - apiGroups: [""] 
        resources: ["pods"]
        verbs: ["get", "watch", "list", "create"]
      EOF
      ```
  
  * create clusterrolebinding
    * ```shell
      cat <<EOF | kubectl apply -f -
      apiVersion: rbac.authorization.k8s.io/v1
      kind: RoleBinding
      metadata:
      name: conti-pod-reader-role
      namespace: application
      subjects:
      - kind: ServiceAccount
        name: conti
        namespace: application
        roleRef:
        kind: ClusterRole
        name: pod-reader-role
        apiGroup: "rbac.authorization.k8s.io"
      EOF
      ```

