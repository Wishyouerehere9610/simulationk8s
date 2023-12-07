## resouce-nginx
 #### CName: 
 * `resource-ops-dev.lab.zjvis.net`
 * `ops-dev-01.lab.zjvis.net`

### install resource-nginx
1. prepare [resource.nginx.values.yaml](resources/resource.nginx.values.yaml.md)
2. prepare images
   * ```shell
     DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p
     $DOCKER_IMAGE_PATH
     BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
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
     DOCKER_REGISTRY="docker-registry-simulation.lab.zjvis.net:32443"
     for IMAGE in "docker.io/bitnami/nginx:1.21.3-debian-10-r29" \
         "docker.io/busybox:1.33.1-uclibc"
     do
         DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
         docker tag $IMAGE $DOCKER_TARGET_IMAGE \
             && docker push $DOCKER_TARGET_IMAGE \
             && docker image rm $DOCKER_TARGET_IMAGE
     done   
      ```
3. creat namespace `application` if not exits 
   * ```shell
      kubectl get namespace application || kubectl create namespace application
     ```
4. create `resource-nginx-pvc`
   * prepare [resource.nginx.pvc.yaml](resources/resource.nginx.pvc.yaml.md)
   * ```shell
     kubectl -n application apply -f resource.nginx.pvc.yaml
     ```

5. install resource-nginx
   * ```shell
     helm install \
     --create-namespace --namespace application \
     my-resource-nginx \
     https://resource-ops.lab.zjvis.net:32443/charts/charts.bitnami.com/bitnami/nginx-9.5.7.tgz \
     --values resource.nginx.values.yaml \
     --atomic
     ```

## test
1. check connection
   * ```shell
      curl --insecure --header 'Host: resource-ops-dev.lab.zjvis.net' https://localhost:32443
     ```
2. add resource
   * ```shell
     kubectl -n application exec -it deployment/my-resource-nginx -c busybox \
     -- sh -c "echo this is a test > /data/file-created-by-busybox"
     ``` 
3. check resource by `curl`
   * ```shell
     curl --insecure --header 'Host: resource-ops-dev.lab.zjvis.net' https://localhost:32443/file-created-by-busybox
     ```

## uninstallation
1. check `resource-nginx`
   * ```shell
      helm -n application uninstall my-resource-nginx
     ```
2. delete pvc `resource-nginx-pvc`
   * ```shell
     kubectl -n application delete pvc resource-nginx-pvc
     ``` 
