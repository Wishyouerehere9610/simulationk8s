## cert-manager

1. prepare [cert.manager.values.yaml](resources/cert.manager.values.yaml.md)
2. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      # BASE_URL="https://resource-ops-test.lab.zjvis.net:32443/docker-images"
      BASE_URL="https://resource.cnconti.cc/docker-images"
      for IMAGE in "quay.io_jetstack_cert-manager-controller_v1.5.4.dim" \
          "quay.io_jetstack_cert-manager-webhook_v1.5.4.dim" \
          "quay.io_jetstack_cert-manager-cainjector_v1.5.4.dim" \
          "quay.io_jetstack_cert-manager-ctl_v1.5.4.dim" \
          "quay.io_jetstack_cert-manager-acmesolver_v1.5.4.dim" \
          "ghcr.io_devmachine-fr_cert-manager-alidns-webhook_cert-manager-alidns-webhook_0.2.0.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE && rm -rf $IMAGE_FILE
      done
      DOCKER_REGISTRY="localhost:5000"
      for IMAGE in "quay.io/jetstack/cert-manager-controller:v1.5.4" \
          "quay.io/jetstack/cert-manager-webhook:v1.5.4" \
          "quay.io/jetstack/cert-manager-cainjector:v1.5.4" \
          "quay.io/jetstack/cert-manager-ctl:v1.5.4" \
          "quay.io/jetstack/cert-manager-acmesolver:v1.5.4" \
          "ghcr.io/devmachine-fr/cert-manager-alidns-webhook/cert-manager-alidns-webhook:0.2.0"
      do
          LOCAL_IMAGE="${DOCKER_REGISTRY}/$IMAGE"
          docker image inspect $IMAGE > /dev/null 2>&1 || docker pull $IMAGE
          docker image tag $IMAGE $LOCAL_IMAGE
          docker push $LOCAL_IMAGE
      done
      ```
3. install `cert-manager`
    * ```shell
      helm install \
          --create-namespace --namespace basic-components \
          my-cert-manager \
          https://resource.cnconti.cc/charts/charts.jetstack.io/cert-manager-v1.5.4.tgz \
          --values cert.manager.values.yaml \
          --atomic
      ```
4. create cluster issuer
    * prepare [self.signed.cluster.issuer.yaml](resources/self.signed.cluster.issuer.yaml.md)
    * ```shell
      kubectl -n basic-components apply -f self.signed.cluster.issuer.yaml
      ```
