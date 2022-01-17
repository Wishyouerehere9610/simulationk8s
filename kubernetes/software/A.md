## NFS

### docker NSFserver
* ```shell
  mkdir -p $(pwd)/data/nfs/data \
      && echo '/data *(rw,fsid=0,no_subtree_check,insecure,no_root_squash)' > $(pwd)/data/nfs/exports \
      && modprobe nfs && modprobe nfsd \
      && docker run \
          --name nfs4 \
          --rm \
          --privileged \
          -p 2049:2049 \
          -v $(pwd)/data/nfs/data:/data \
          -v $(pwd)/data/nfs/exports:/etc/exports:ro \
          -d docker.io/erichough/nfs-server:2.2.1
  ```

### nfs subdir external provisioner
* prepare [nfs.subdir.external.provisioner.values.yaml](https://blog.geekcity.tech/#/kubernetes/storage/resources/nfs.subdir.external.provisioner/nfs.subdir.external.provisioner.values.yaml)
* 写入hosts文件
  * ```shell
    echo 172.17.0.1 nfs4.service.docker.local >> /etc/hosts \
        && docker exec kind-control-plane bash -c 'echo 172.17.0.1 nfs4.service.docker.local >> /etc/hosts' 
    ```
* prepare images
  - ```shell
    for IMAGE in  "k8s.gcr.io/sig-storage/nfs-subdir-external-provisioner:v4.0.2"
    do
        LOCAL_IMAGE="localhost:5000/$IMAGE"
        docker image inspect $IMAGE || docker pull $IMAGE
        docker image tag $IMAGE $LOCAL_IMAGE
        docker push $LOCAL_IMAGE
    done
    ```
* install by helm
  - ```shell
    helm install \
        --create-namespace --namespace nfs-provisioner \
        my-nfs-subdir-external-provisioner \
        https://resource.geekcity.tech/kubernetes/charts/https/kubernetes-sigs.github.io/nfs-subdir-external-provisioner/nfs-subdir-external-provisioner-4.0.14.tgz \
        --values nfs.subdir.external.provisioner.values.yaml \
        --atomic
    ```

### ingress-nginx
* [ingress]()

### cert-manage
* [cert-manage]()

### docker-registry
* prepare [self.signed.and.ca.issuer.yaml](self.signed.and.ca.issuer.yaml.md)
* prepare [docker.registry.values.yaml](docker.registry.values.yaml.md)
* 生成issuer
  * ```shell
    kubectl -n basic-components apply -f self.signed.and.ca.issuer.yaml
    ```
* prepare images
  * ```shell
    for IMAGE in  "docker.io/registry:2.7.1"
    do
        LOCAL_IMAGE="localhost:5000/$IMAGE"
        docker image inspect $IMAGE || docker pull $IMAGE
        docker image tag $IMAGE $LOCAL_IMAGE
        docker push $LOCAL_IMAGE
    done
    ```
* install docker-registry
  * ```shell
    helm install \
    --create-namespace --namespace basic-components \
    my-docker-registry \
    https://resource.geekcity.tech/kubernetes/charts/https/helm.twun.io/docker-registry-1.14.0.tgz \
    --values docker.registry.values.yaml \
    --atomic
    ```
* configure ingress with tls
  * pass
  * pass
  * prepare [docker.registry.ingress.yaml]()
    - ```shell
      kubectl -n basic-components apply -f docker.registry.ingress.yaml
      ```











