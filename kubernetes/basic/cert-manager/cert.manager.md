# cert manager

## main usage

* create certification of ssl automatically by cert-manager
* use dns01 method

## conceptions

* none

## purpose

* create a kubernetes cluster by kind
* setup cert-manager
* setup alidns-webhook
* install nginx service and access it with https

## do it
1. [create qemu machine for kind](../create.qemu.machine.for.kind.md)
2. [install ingress-nginx](../ingress.nginx.md)
3. prepare [cert.manager.values.yaml](../resources/cert.manager.values.yaml.md)
4. prepare images
     * ```shell
       for IMAGE in "quay.io/jetstack/cert-manager-controller:v1.5.4" \
           "quay.io/jetstack/cert-manager-webhook:v1.5.4" \
           "quay.io/jetstack/cert-manager-cainjector:v1.5.4" \
           "quay.io/jetstack/cert-manager-ctl:v1.5.4"
       do
           LOCAL_IMAGE="localhost:5000/$IMAGE"
           docker image inspect $IMAGE || docker pull $IMAGE
           docker image tag $IMAGE $LOCAL_IMAGE
           docker push $LOCAL_IMAGE
       done
       ```
5. install by helm  
     * ```shell
       ./bin/helm install \
           --create-namespace --namespace basic-components \
           my-cert-manager \
           cert-manager \
           --version 1.5.4 \
           --repo https://charts.jetstack.io \
           --values $(pwd)/cert.manager.values.yaml \
           --atomic
       ```

## test
* test with certificate
  * create issuse
    * prepare [alidns.webhook.staging.issuer.yaml](./alidns.webhook.staging.issuer.yaml.md)
    * ```shell
      kubectl -n basic-components apply -f alidns.webhook.staging.issuer.yaml
      ```
  * create certificate
    * prepare [test.certificaete.yaml](./test.certificaete.yaml.md)
    * ```shell
      kubectl -n basic-components apply -f test.certificaete.yaml
      ```
  * certificate should have been after a while `successfully` `issued`
    * ```shell
      kubectl -n basic-components describe certificate cm-test
      ```
* test with nginx
  * prepare [alidns.webhook.staging.nginx.values.yaml](./alidns.webhook.staging.nginx.values.yaml.md)
  * prepare images
    * ```shell
      for IMAGE in \
          "docker.io/bitnami/nginx:1.21.3-debian-10-r29"
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
          --create-namespace --namespace basic-components-plus \
          alidns-letsencrypt-staging-nginx \
          https://resource.geekcity.tech/kubernetes/charts/https/charts.bitnami.com/bitnami/nginx-9.5.7.tgz \
          --values alidns.webhook.staging.nginx.values.yaml \
          --atomic
      ```
      
      