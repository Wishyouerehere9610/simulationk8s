# resources-nginx

## main usage

* none

## conceptions

* none

## purpose
* none

## pre-requirements
* [create.local.cluster.with.kind](/kubernetes/create.local.cluster.with.kind.md)
* [local_kind_cluster](/kubernetes/local_kind_cluster/README.md)

## do it
1. prepare [resource.nginx.values.yaml](resources/resource.nginx.values.yaml.md)
2. prepare images
    * ```shell  
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource.cnconti.cc/docker-images"
      # BASE_URL="https://resource-ops-test.lab.zjvis.net:32443/docker-images"
      for IMAGE in "docker.io_bitnami_nginx_1.21.3-debian-10-r29.dim" \
          "docker.io_busybox_1.33.1-uclibc.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      DOCKER_REGISTRY="insecure.docker.registry.local:80"
      for IMAGE in "docker.io/bitnami/nginx:1.21.3-debian-10-r29" \
          "docker.io/busybox:1.33.1-uclibc"
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
3. create namespace `application` if not exists
    * ```shell
      kubectl get namespace application || kubectl create namespace application
      ```
4. create `resource-nginx-pvc`
    * prepare [resource.nginx.pvc.yaml](resources/resource.nginx.pvc.yaml.md)
    * ```shell
      kubectl -n application apply -f resource.nginx.pvc.yaml
      ```
5. install by helm
    * ```shell
      helm install \
          --create-namespace --namespace application \
          my-resource-nginx \
          https://resource.cnconti.cc/charts/charts.bitnami.com/bitnami/nginx-9.5.7.tgz \
          --values resource.nginx.values.yaml \
          --atomic
      ```

## test
1. check connection
    * ```shell
      echo '127.0.0.1 resource.local' >> /etc/hosts \
          && curl --insecure --header 'Host: resource.local' https://localhost
      ```
2. test resource
   * add reource
     * ```shell
       kubectl -n application exec -it deployment/my-resource-nginx -c busybox -- sh -c \
           "echo this is a resource > /data/file-created-by-busybox"
       ```
   * check resource by `curl`
     * ```shell
       curl --insecure --header 'Host: resource.local' https://localhost/file-created-by-busybox
       ```

## uninstall
1. uninstall `resource-nginx`
    * ```shell
      helm -n application uninstall resource-nginx
      ```
2. delete pvc `resource-nginx-pvc`
    * ```shell
      kubectl -n application delete pvc resource-nginx-pvc
      ```



















