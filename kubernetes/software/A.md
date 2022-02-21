## ali basic-components

### nfs-server by docker
1. prepare images
   * ```shell
     for IMAGE in  "docker.io/erichough/nfs-server:2.2.1"
     do
         LOCAL_IMAGE="localhost:5000/$IMAGE"
         docker image inspect $IMAGE || docker pull $IMAGE
         docker image tag $IMAGE $LOCAL_IMAGE
         docker push $LOCAL_IMAGE
     done
     ```
2. install nfs-server
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
1. prepare [nfs.subdir.external.provisioner.values.yaml](../storage/nfs.subdir.external.provisioner.values.yaml.md)
2.  configure /etc/hosts for nfs4.service.docker.local
   * ```shell
     echo 172.17.0.1 nfs4.service.docker.local >> /etc/hosts
     ```
3. prepare images 
   - ```shell
     for IMAGE in  "k8s.gcr.io/sig-storage/nfs-subdir-external-provisioner:v4.0.2"
     do
         LOCAL_IMAGE="localhost:5000/$IMAGE"
         docker image inspect $IMAGE || docker pull $IMAGE
         docker image tag $IMAGE $LOCAL_IMAGE
         docker push $LOCAL_IMAGE
     done
     ```
4. install by helm
   - ```shell
     helm install \
         --create-namespace --namespace nfs-provisioner \
         my-nfs-subdir-external-provisioner \
         https://resource.geekcity.tech/kubernetes/charts/https/kubernetes-sigs.github.io/nfs-subdir-external-provisioner/nfs-subdir-external-provisioner-4.0.14.tgz \
         --values nfs.subdir.external.provisioner.values.yaml \
         --atomic
     ```

### ingress-nginx
1.  prepare [ingress.nginx.values.yaml](ingress.nginx.values.yaml.md)
2. prepare images
   * at every node
   * ```shell
     DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
     BASE_URL="https://resource.static.zjvis.net/docker-images"
     for IMAGE in "k8s.gcr.io_ingress-nginx_controller_v1.0.3.dim" \
         "k8s.gcr.io_ingress-nginx_kube-webhook-certgen_v1.0.dim" \
         "k8s.gcr.io_defaultbackend-amd64_1.5.dim"
     do
         IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
         if [ ! -f $IMAGE_FILE ]; then
             TMP_FILE=$IMAGE_FILE.tmp \
                 && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                 && mv $TMP_FILE $IMAGE_FILE
         fi
         docker image load -i $IMAGE_FILE
     done
     ```
 
3. install
   * ````shell
     helm install \
         --create-namespace --namespace basic-components \
         my-ingress-nginx \
         https://resource.static.zjvis.net/charts/kubernetes.github.io/ingress-nginx/ingress-nginx-4.0.5.tgz \
         --values ingress.nginx.values.yaml \
         --atomic
     ````
 

### cert-manage
1. prepare [cert.manager.values.yaml](https://nebula-ops.lab.zjvis.net/#/nebula-ops-test/basic/resource/cert.manager.values.yaml)
2. prepare images
   - at every node
   - ```shell
     DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
     BASE_URL="https://resource.static.zjvis.net/docker-images"
     for IMAGE in "quay.io_jetstack_cert-manager-controller_v1.5.4.dim" \
         "quay.io_jetstack_cert-manager-webhook_v1.5.4.dim" \
         "quay.io_jetstack_cert-manager-cainjector_v1.5.4.dim" \
         "quay.io_jetstack_cert-manager-ctl_v1.5.4.dim" \
         "quay.io_jetstack_cert-manager-acmesolver_v1.5.4.dim" \
         "ghcr.io_devmachine-fr_cert-manager-alidns-webhook_cert-manager-alidns-webhook_0.2.0.dim"
     do
         IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
         if [ ! -f $IMAGE_FILE ]; then
             TMP_FILE=$IMAGE_FILE.tmp \
                 && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                 && mv $TMP_FILE $IMAGE_FILE
         fi
         docker image load -i $IMAGE_FILE
     done
     ```

3. install `cert-manager`
   - ```shell
     helm install \
         --create-namespace --namespace basic-components \
         my-cert-manager \
         https://resource.static.zjvis.net/charts/charts.jetstack.io/cert-manager-v1.5.4.tgz \
         --values cert.manager.values.yaml \
         --atomic
     ```

4. install `alidns-webhook`
   - prepare [alidns.webhook.values.yaml](https://nebula-ops.lab.zjvis.net/#/nebula-ops-test/basic/resource/alidns.webhook.values.yaml)
   - make sure permissions added to `$YOUR_ACCESS_KEY_ID`
     - ```json
       {
         "Version": "1",
         "Statement": [
           {
             "Effect": "Allow",
             "Action": [
               "alidns:AddDomainRecord",
               "alidns:DeleteDomainRecord"
             ],
             "Resource": "acs:alidns:*:*:domain/zjvis.net"
           }, {
             "Effect": "Allow",
             "Action": [
               "alidns:DescribeDomains",
               "alidns:DescribeDomainRecords"
             ],
             "Resource": "acs:alidns:*:*:domain/*"
           }
         ]
       }
       ```

   - create secret of `alidns-webhook-secrets`
     - ```shell
       kubectl -n basic-components create secret generic alidns-webhook-secrets \
           --from-literal="access-token=$YOUR_ACCESS_KEY_ID" \
           --from-literal="secret-key=$YOUR_ACCESS-KEY-SECRET"
       ```

   - ```shell
     helm install \
         --create-namespace --namespace basic-components \
         my-alidns-webhook \
         https://resource.static.zjvis.net/charts/github.com/DEVmachine-fr/cert-manager-alidns-webhook/releases/download/alidns-webhook-0.6.0/alidns-webhook-0.6.0.tgz \
         --values alidns.webhook.values.yaml \
         --atomic
     ```

5. create cluster issuer

   - prepare [alidns.webhook.cluster.issuer.yaml](https://nebula-ops.lab.zjvis.net/#/nebula-ops-test/basic/resource/alidns.webhook.cluster.issuer.yaml)

   - ```shell
     kubectl -n basic-components apply -f alidns.webhook.cluster.issuer.yaml
     ```

### docker-registry
1. prepare [docker.registry.values.yaml](docker.registry.values.yaml.md)
2. prepare images
   * ```shell
     for IMAGE in  "docker.io/registry:2.7.1"
     do
         LOCAL_IMAGE="localhost:5000/$IMAGE"
         docker image inspect $IMAGE || docker pull $IMAGE
         docker image tag $IMAGE $LOCAL_IMAGE
         docker push $LOCAL_IMAGE
     done
     ```
3. install docker-registry
   * ```shell
     helm install \
         --create-namespace --namespace basic-components \
         my-docker-registry \
         https://resource.geekcity.tech/kubernetes/charts/https/helm.twun.io/docker-registry-1.14.0.tgz \
         --values docker.registry.values.yaml \
         --atomic
     ```
4. docker-registry ingress
   * NOTE: ingress in helm chart is not compatible enough for us, we have to install ingress manually
   * prepare [docker.registry.ingress.yaml](docker.registry.ingress.yaml.md)
   * apply ingress
     - ```shell
       kubectl -n basic-components apply -f docker.registry.ingress.yaml
       ```
   
5. check with every node
   * ```shell
     IMAGE=docker.io/busybox:1.33.1-uclibc \
         && TARGET_IMAGE=docker-registry-ops-test.lab.zjvis.net:32443/$IMAGE \
         && docker tag $IMAGE $TARGET_IMAGE \
         && docker push $TARGET_IMAGE \
         && docker image rm $IMAGE \
         && docker image rm $TARGET_IMAGE \
         && docker pull $TARGET_IMAGE \
         && echo success
     ```











