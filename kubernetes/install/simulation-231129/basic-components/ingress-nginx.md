## ingress-nginx

### installation
1. prepare [ingress.nginx.values.yaml](resources/ingress.nginx.values.yaml.md)
2. prepare images at every node
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
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
          docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      ```
3. install `ingress-nginx`
    * ```shell
      helm install \
          --create-namespace --namespace basic-components \
          my-ingress-nginx \
          https://resource-ops.lab.zjvis.net:32443/charts/kubernetes.github.io/ingress-nginx/ingress-nginx-4.0.5.tgz \
          --values ingress.nginx.values.yaml \
          --atomic
      ```
