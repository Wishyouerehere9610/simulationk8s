# nginx.web

## main usage

* nginx.web

## conceptions

* none

## practise

### pre-requirements

* none

### purpose

* create a kubernetes cluster by kind

### do it
1. prepare [nginx.values.yaml](resources/nginx.values.yaml.md)
2. prepart images
   * ```shell
     for IMAGE in "docker.io/bitnami/nginx:1.21.3-debian-10-r29"
     do
         LOCAL_IMAGE="localhost:5000/$IMAGE"
         docker image inspect $IMAGE || docker pull $IMAGE
         docker image tag $IMAGE $LOCAL_IMAGE
         docker push $LOCAL_IMAGE
     done
     ```
3. install by helm
   * ```shell
     helm install \
         --create-namespace --namespace application \
         my-nginx \
         nginx \
         --version 9.5.7 \
         --repo https://charts.bitnami.com/bitnami \
         --values $(pwd)/nginx.values.yaml \
         --atomic
     ```
     
## test
* port-forward
  * ```shell
    kubectl --namespace application port-forward svc/my-nginx  --address 0.0.0.0 8080:80
    ```
* Connection test
  * ```shell
     curl http://localhost:8080
     ```