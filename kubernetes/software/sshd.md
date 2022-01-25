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
* create `sshd-secret`
  * ```shell
    # uses the "Array" declaration
    # referencing the variable again with as $PASSWORD an index array is the same as ${PASSWORD[0]}
    PASSWORD=($((echo -n $RANDOM | md5sum 2>/dev/null) || (echo -n $RANDOM | md5 2>/dev/null)))
    # NOTE: username should have at least 6 characters
    kubectl -n application \
    create secret generic sshd-secret \
    --from-literal=password=$PASSWORD
    ```
* install by helm
  * ```shell
    helm install \
        --create-namespace --namespace application \
        my-sshd \
        https://resources.conti2021.icu/chart/sshd-0.2.1.tgz \
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
    # password
    kubectl --namespace application sshd-secret -o jsonpath={.data.password} | base64 -decode 
    # test login
    ssh -o "UserKnownHostsFile /dev/null" -o "StrictHostKeyChecking no" -p 2222 root@localhost
    ```
* rbac test
  * ```shell
    # namespace
    kubectl get pod --namespace application
    
    # cluster
    kubectl get pod --all-namespace
    ```
    
### [RBAC](../resources/rbac.md)