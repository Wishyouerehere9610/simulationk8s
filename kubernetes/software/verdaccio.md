# haproxy

## main usage

* none

## conceptions

* none

## practise

## pre-requirements

* none

## purpose

* [create local cluster for testing](../local.cluster.for.testing.md)

## do it

1. prepare [haproxy.values.yaml](haproxy/haproxy.values.yaml.md)
2. prepart images
    * ```shell
     for IMAGE in "haproxytech/haproxy-alpine:2.5.0" 
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
         my-haproxy \
         haproxy \
         --version 1.9.0 \
         --repo https://charts.bitnami.com/bitnami \
         --values haproxy.values.yaml \
         --atomic
     ```

## test
1. [install nginx](/kubernetes/basic/nginx.web.md)
2. 准备三个nginx进行负载均衡测试
    * [nginx.www]()
    * [nginx.blog]()
    * [nginx.file]()
3.  
    




















