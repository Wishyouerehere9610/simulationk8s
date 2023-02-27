# ingress nginx

## main usage
* ingress nginx to expose http/https endpoints
* create a kubernetes cluster by kind
* setup ingress-nginx

## conceptions
* none

## precondition
* [kind_cluster](/kubernetes/kind.cluster.md)

## operation
1. prepare [ingress.nginx.values.yaml](resources/ingress.nginx.values.yaml.md)
2. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
      BASE_URL="https://resource.cnconti.cc/docker-images"
      # BASE_URL="https://resource.static.zjvis.net/docker-images"
      for IMAGE in "k8s.gcr.io_ingress-nginx_controller_v1.0.3.dim" \
          "k8s.gcr.io_ingress-nginx_kube-webhook-certgen_v1.0.dim" \
          "k8s.gcr.io_defaultbackend-amd64_1.5.dim" \
          "docker.io_bitnami_nginx_1.21.3-debian-10-r29.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      DOCKER_REGISTRY="localhost:5000"
      for IMAGE in "k8s.gcr.io/ingress-nginx/controller:v1.0.3" \
          "k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.0" \
          "k8s.gcr.io/defaultbackend-amd64:1.5" \
          "docker.io/bitnami/nginx:1.21.3-debian-10-r29"
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
3. install `ingress nginx` by helm
    * NOTE: `https://resource.static.zjvis.net/charts/kubernetes.github.io/ingress-nginx/ingress-nginx-4.0.5.tgz`
    * ```shell
      helm install \
          --create-namespace --namespace basic-components \
          my-ingress-nginx \
          https://resource.cnconti.cc/charts/kubernetes.github.io/ingress-nginx/ingress-nginx-4.0.5.tgz \
          --values ingress.nginx.values.yaml \
          --atomic
      ```

## test
1. prepare `test` namespace
    * ```shell
      kubectl get namespace test > /dev/null 2>&1 || kubectl create namespace test
      ```
2. install nginx service
    * prepare [nginx.values.yaml](resources/nginx.values.yaml.md)
    * install `nginx`
        + ```shell
          helm install \
              --create-namespace --namespace test \
              my-nginx \
              https://resource.cnconti.cc/charts/charts.bitnami.com/bitnami/nginx-9.5.7.tgz  \
              --values nginx.values.yaml \
              --atomic
          ```
3. check connection
    + ```shell
      curl --header 'Host: my-nginx.local' http://localhost
      ```

## uninstall
1. uninstall `my-nginx`
    * ```shell
      helm -n test uninstall my-nginx \
          && kubectl delte namespace test
      ```
