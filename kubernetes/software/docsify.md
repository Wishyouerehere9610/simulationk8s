# docs

## main usage

* 搭建docs系统，提供docs访问功能

## conceptions

* none

## purpose

* git服务周期性pull项目
* 搭建nginx进行web服务

## pre-requirements
* [create.local.cluster.with.kind](/kubernetes/create.local.cluster.with.kind.md)
* [local_kind_cluster](/kubernetes/local_kind_cluster/README.md)

## Do it
1. prepare `git-ssh-key`
    * add `ssh-keys/id_rsa.pub` to git repo server as deploy key
    * ```shell
      kubectl get namespace application || kubectl create namespace application
          && kubectl -n application create secret generic git-ssh-key \
                --from-file=${HOME}/.ssh/
      ```
2. prepare [docs.nginx.yaml](resources/docs.nginx.yaml.md)
4. prepare images
    * ```shell
       DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
       BASE_URL="https://resource.cnconti.cc/docker-images"
       # BASE_URL="https://resource-ops-test.lab.zjvis.net:32443/docker-images"
       for IMAGE in "docker.io_bitnami_nginx_1.21.4-debian-10-r0.dim" \
           "docker.io_bitnami_git_2.33.0-debian-10-r76.dim" 
       do
           IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
           if [ ! -f $IMAGE_FILE ]; then
               TMP_FILE=$IMAGE_FILE.tmp \
                   && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                   && mv $TMP_FILE $IMAGE_FILE
           fi
           docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
       done
       LOCAL_IMAGE="insecure.docker.registry.local:80"
       for IMAGE in "docker.io/bitnami/nginx:1.21.4-debian-10-r0" \
           "docker.io/bitnami/git:2.33.0-debian-10-r76" 
       do
           DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
           docker tag $IMAGE $DOCKER_TARGET_IMAGE \
               && docker push $DOCKER_TARGET_IMAGE \
               && docker image rm $DOCKER_TARGET_IMAGE
       done
       ```
5. install by helm
    * ```shell
      # https://resource-ops-test.lab.zjvis.net:32443/charts/charts.bitnami.com/bitnami/nginx-9.5.7.tgz
      helm install \
          --create-namespace --namespace application \
          my-docs \
          https://resource.cnconti.cc/charts/nginx-9.5.7.tgz \
          --values docs.nginx.yaml \
          --atomic
      ```

## Test
* visit
    * ```shell
      curl  --header 'Host:docs.local' http://localhost/
      ```
* upgrade
    * ```shell
      # https://resource-ops-test.lab.zjvis.net:32443/charts/charts.bitnami.com/bitnami/nginx-9.5.7.tgz
      helm upgrade \
          --namespace application \
          docs-conti \
          https://resource.cnconti.cc/charts/nginx-9.5.7.tgz \
          --values docs.nginx.yaml \
          --atomic
      ```

* uninstall
    * ````shell
      helm uninstall -n application my-docs
      ````
