# docs

## main usage

* 搭建docs系统，提供docs访问功能

## conceptions

* none

## purpose

* git服务周期性pull项目
* 搭建nginx进行web服务

## pre-requirements

* [local.cluster.for.testing.md](../resources/local.cluster.for.testing.md)
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

2. prepare [docs-conti.nginx.yaml](resources/docs-conti.nginx.yaml.md)
3. prepare images
    * ```shell
       DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
       BASE_URL="https://aconti.oss-cn-hangzhou.aliyuncs.com/docker-images"
       LOCAL_IMAGE="localhost:5000"
       for IMAGE in "docker.io/bitnami/nginx:1.21.4-debian-10-r0" \
           "docker.io/bitnami/git:2.33.0-debian-10-r76" 
       do
           IMAGE_FILE=$(echo ${IMAGE} | sed "s/\//_/g" | sed "s/\:/_/g").dim
           LOCAL_IMAGE_FIEL=${DOCKER_IMAGE_PATH}/${IMAGE_FILE}
           if [ ! -f ${LOCAL_IMAGE_FIEL} ]; then
               curl -o ${IMAGE_FILE} -L ${BASE_URL}/${IMAGE_FILE} \
                   && mv ${IMAGE_FILE} ${LOCAL_IMAGE_FIEL} \
                   || rm -rf ${IMAGE_FILE}
           fi
           docker image load -i ${LOCAL_IMAGE_FIEL}
           docker image inspect ${IMAGE} || docker pull ${IMAGE}
           docker image tag ${IMAGE} ${LOCAL_IMAGE}/${IMAGE}
           docker push ${LOCAL_IMAGE}/${IMAGE}
       done
       ```
4. install by helm
    * ```
      helm install \
          --create-namespace --namespace application \
          docs-conti \
          https://resources.conti2021.icu/charts/nginx-9.5.7.tgz \
          --values docs-conti.nginx.yaml \
          --atomic
      ```

## Test
* visit
    * ```
      curl  --header 'Host:docs-conti.cnconti.cc' http://localhost/
      ```
* upgrade
    * ```
      helm upgrade \
          --namespace application \
          docs-conti \
          https://resources.conti2021.icu/charts/nginx-9.5.7.tgz \
          --values docs-conti.nginx.yaml \
          --atomic
      ```

* uninstall
    * ````
      helm uninstall -n application docs-conti
      ````