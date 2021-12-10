# Haproxy

## main usage

* none

## conceptions

* none

## practise

### pre-requirements

* none

### purpose

* create a kubernetes cluster by kind
* setup ingress-nginx
* install confluence

### do it

1. [create local cluster for testing](../../basic/local.cluster.for.testing.md)

2. install ingress nginx

   * prepare [ingress.nginx.values.yaml](../../basic/resources/ingress.nginx.values.yaml.md)

   * prepare images

     + ```shell
       for IMAGE in "haproxytech/haproxy-alpine:1.7.1" 
       do
           LOCAL_IMAGE="localhost:5000/$IMAGE"
           docker image inspect $IMAGE || docker pull $IMAGE
           docker image tag $IMAGE $LOCAL_IMAGE
           docker push $LOCAL_IMAGE
       done
       ```

   * install with helm

     + ```shell
       ./bin/helm install \
           --create-namespace --namespace basic-components \
           my-ingress-nginx \
           ingress-nginx \
           --version 4.0.5 \
           --repo https://kubernetes.github.io/ingress-nginx \
           --values ingress.nginx.values.yaml \
           --atomic
       ```

3. install confluence

   * prepare [confluence.values.yaml](resources/confluence.values.yaml.md)

   * prepare images

     + ```shell
       for IMAGE in "haproxytech/haproxy-alpine:2.4.8" 
       do
           LOCAL_IMAGE="localhost:5000/$IMAGE"
           docker image inspect $IMAGE || docker pull $IMAGE
           docker image tag $IMAGE $LOCAL_IMAGE
           docker push $LOCAL_IMAGE
       done
       ```

   * install with confluence

     + ```shell
       ./bin/helm install \
           --create-namespace --namespace application \
           my-haproxy \
           haproxy \
           --version 1.7.1 \
           --repo https://haproxytech.github.io/helm-charts \
           --values haproxy.values.yaml \
           --atomic
       ```

4. visit gitea from website

   * port-forward

     + ```shell
       ./bin/kubectl --namespace application port-forward svc/my-confluence-confluence-server 8090:8 --address 0.0.0.0
       ```

   * visit http://$HOST:3000

   * password

     + ```shell
       ./bin/kubectl get secret gitea-admin-secret -n gitea -o jsonpath={.data.password} | base64 --decode && echo
       ```

5. visit gitea from SSH

   * port-forward

     + ```shell
       ./bin/kubectl --namespace application port-forward svc/my-gitea-ssh 222:22 --address 0.0.0.0
       ```

   * 创建测试仓库

     * ```tex
       在网页上创建测试库(用户创建)
       ```

   + 测试ssh链接是否正常

     * ```shell
       git clone ssh://git@192.168.31.31:222/libokang/test.git
       ```