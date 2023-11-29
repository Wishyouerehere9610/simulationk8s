## pureLB

### installation
1. prepare [purelb.values.yaml](resources/purelb.values.yaml.md)
2. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops-dev.lab.zjvis.net:32443/docker-images"
      for IMAGE in "docker.io_purelb_allocator_v0.6.4.dim" \
          "docker.io_purelb_lbnodeagent_v0.6.4.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      DOCKER_REGISTRY="docker-registry-ops-dev.lab.zjvis.net:32443"
      for IMAGE in "docker.io/purelb/allocator:v0.6.4" \
          "docker.io/purelb/lbnodeagent:v0.6.4"
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
3. install `purelb`
    * ```shell
      helm install \
          --create-namespace --namespace basic-components \
          my-purelb \
          https://resource-ops-dev.lab.zjvis.net/charts/others/purelb-v0.6.4.tgz \
          --values purelb.values.yaml \
          --atomic
      ```
4. create `servicegroups`
    * prepare [purelb.layer2.ippool.servicegroups.yaml](resources/purelb.layer2.ippool.servicegroups.yaml.md)
    * ```shell
      kubectl -n basic-components apply -f purelb.layer2.ippool.servicegroups.yaml
      ```
    
### test
1. create `purelb-nginx` 
    * prepare [purelb.nginx.yaml](resources/purelb.nginx.yaml.md)
    * ```shell
      helm install \
          --create-namespace --namespace test \
          purelb-nginx \
          https://resource-ops.lab.zjvis.net:32443/charts/charts.bitnami.com/bitnami/nginx-9.5.7.tgz \
          --values purelb.nginx.yaml \
          --atomic
      ```
2. check connection
    * ```shell
      NGINX_IP=$(kubectl -n conti get svc purelb-nginx -o yaml \
               -o jsonpath={.status.loadBalancer.ingress[0].ip}) \
      && curl http://${NGINX_IP}:80
      ```
      
### uninstall
1. delete `servicegroups` `purelb-layer2-ippool`
    * ```shell
      kubectl -n basic-components delete servicegroups purelb-layer2-ippool
      ```
2. uninstall `my-purelb`
    * ```shell
      helm -n basic-components uninstall my-purelb
      ```