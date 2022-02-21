# docs

## main usage

* 搭建docs系统，提供docs访问功能

## conceptions

* none

## purpose

* git服务周期性pull项目
* 搭建nginx进行web服务

## pre-requirements

* [local.cluster.for.testing.md](../local.cluster.for.testing.md)
* [ingress](../basic/ingress.nginx.md)
* [cert-manager](../basic/cert.manager.md)

## Do it

1. prepare ssh-key-secret
    * create `rsa` keys by `ssh-keygen` if not generated before
        + ```
          mkdir -p ssh-keys/ \
              && ssh-keygen -t rsa -b 4096 -N "" -f ssh-keys/id_rsa
          ```
    * create namespace `application` if not exists
        + ```
          kubectl get namespace application \
              || kubectl create namespace application
          ```
    * generate `git-ssh-key-secret`
        + ```
          kubectl -n application create secret generic git-ssh-key-secret --from-file=ssh-keys/
          ```
    * add `ssh-keys/id_rsa.pub` to git repo server as deploy key

2. install by helm 
    * prepare [docs-conti.nginx.yaml](resources/docs-conti.nginx.yaml.md)
    * install by helm
        + ```
          helm install \
              --create-namespace --namespace application \
              docs-conti \
              https://resources.conti2021.icu/charts/nginx-9.5.7.tgz \
              --values docs-conti.nginx.yaml \
              --atomic
          ```

3. visit
    * ```
      curl  --header 'Host:docs-conti.cnconti.cc' http://localhost/
      ```

4. upgrade
    * ```
      helm upgrade \
          --namespace application \
          docs-conti \
          https://resources.conti2021.icu/charts/nginx-9.5.7.tgz \
          --values docs-conti.nginx.yaml \
          --atomic
      ```

5. uninstall
    * ````
      helm uninstall -n application docs-conti
      ````