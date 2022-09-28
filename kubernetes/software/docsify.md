# docs

## main usage
* Set up the DOCS system and provide the DOCS access function

## conceptions
* none

## purpose
* Build Nginx for Web services

## precondition
* [create.local.cluster.with.kind](/kubernetes/create.local.cluster.with.kind.md)
* [installed ingress-nginx](/kubernetes/basic/ingress.nginx.md)
* [installed cert-manager](/kubernetes/basic/cert.manager.md)


## do it
1. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
      # BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
      BASE_URL="https://resource.cnconti.cc/docker-images"
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
      LOCAL_IMAGE="localhost:5000"
      for IMAGE in "docker.io/bitnami/nginx:1.21.4-debian-10-r0" \
          "docker.io/bitnami/git:2.33.0-debian-10-r76" 
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
2. Set `git-ssh-key` to the DeploymentKey of the project
    * ```shell
      kubectl get namespace application || kubectl create namespace application \
          && kubectl -n application create secret generic git-ssh-key --from-file=${HOME}/.ssh/
      ```
3. prepare [docs.nginx.yaml](resources/docs.nginx.yaml.md)
4. install by helm
    * NOTE: `https://resource-ops.lab.zjvis.net:32443/charts/charts.bitnami.com/bitnami/nginx-9.5.7.tgz`
    * ```shell
      helm install \
          --create-namespace --namespace application \
          my-docs \
          https://resource.cnconti.cc/charts/charts.bitnami.com/bitnami/nginx-9.5.7.tgz \
          --values docs.nginx.yaml \
          --atomic
      ```

## test
1. check connection
    * ```shell
      curl  --header 'Host:docs.local' http://localhost/
      ```

## uninstall
1. uninstall `my-docs`
    * ````shell
      helm -n application uninstall  my-docs
      ````
