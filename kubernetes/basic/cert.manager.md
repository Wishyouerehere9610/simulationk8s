# cert manager

## main usage

* ingress nginx to expose http/https endpoints

## conceptions

* none

## practise

### pre-requirements

* none

### purpose

* [create a kubernetes cluster by kind](/kubernetes/create.local.cluster.with.kind.md)
* [setup ingress-nginx](/kubernetes/basic/ingress.nginx.md)
* install nginx service and access it with https

### do it
1. prepare [cert.manager.values.yaml](resources/cert.manager.values.yaml.md)
2. prepare images
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
3. install by helm  
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
### 验证方式
* [DNS-01](/kubernetes/basic/alidns_webhook.md)
* [todo: HTTP-01](./ca.md)
