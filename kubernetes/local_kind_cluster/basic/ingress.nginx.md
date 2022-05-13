## ingress-nginx

### install
1. prepare [ingress.nginx.values.yaml](resources/ingress.nginx.values.yaml.md)
2. prepare images
   * ```shell
     DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
     # BASE_URL="https://resource-ops-test.lab.zjvis.net:32443/docker-images"
     BASE_URL="https://resource.cnconti.cc/docker-images"
     for IMAGE in "k8s.gcr.io_ingress-nginx_controller_v1.0.3.dim" \
         "k8s.gcr.io_ingress-nginx_kube-webhook-certgen_v1.0.dim" \
         "k8s.gcr.io_defaultbackend-amd64_1.5.dim"
     do
         IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
         if [ ! -f $IMAGE_FILE ]; then
             TMP_FILE=$IMAGE_FILE.tmp \
                 && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                 && mv $TMP_FILE $IMAGE_FILE
         fi
         docker image load -i $IMAGE_FILE && rm -rf $IMAGE_FILE
         docker 
     done
     DOCKER_REGISTRY="localhost:5000"
     for IMAGE in "k8s.gcr.io/ingress-nginx/controller:v1.0.3" \
         "k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.0" \
         "k8s.gcr.io/defaultbackend-amd64:1.5"
     do
         LOCAL_IMAGE="${DOCKER_REGISTRY}/$IMAGE"
         docker image inspect $IMAGE > /dev/null 2>&1 || docker pull $IMAGE
         docker image tag $IMAGE $LOCAL_IMAGE
         docker push $LOCAL_IMAGE
     done
     ```
3. install by helm
   * ```shell
      helm install \
          --create-namespace --namespace basic-components \
          my-ingress-nginx \
          https://resource.cnconti.cc/charts/kubernetes.github.io/ingress-nginx/ingress-nginx-4.0.5.tgz \
          --values ingress.nginx.values.yaml \
          --atomic
      ```

### uninstall
1. uninstall `my-ingress-nginx`
    * ```shell
      helm -n basic-components uninstall my-ingress-nginx
      ```