## cert-manager

### installation
1. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
      for IMAGE in "quay.io_jetstack_cert-manager-controller_v1.5.4.dim" \
          "quay.io_jetstack_cert-manager-webhook_v1.5.4.dim" \
          "quay.io_jetstack_cert-manager-cainjector_v1.5.4.dim" \
          "quay.io_jetstack_cert-manager-ctl_v1.5.4.dim" \
          "quay.io_jetstack_cert-manager-acmesolver_v1.5.4.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE && rm -rf $IMAGE_FILE
      done
      for IMAGE in "quay.io/jetstack/cert-manager-controller:v1.5.4" \
          "quay.io/jetstack/cert-manager-webhook:v1.5.4" \
          "quay.io/jetstack/cert-manager-cainjector:v1.5.4" \
          "quay.io/jetstack/cert-manager-ctl:v1.5.4" \
          "quay.io/jetstack/cert-manager-acmesolver:v1.5.4"
      do
          kind load docker-image ${IMAGE}
      done
      ```
2. prepare helm values [cert-manager.values.yaml](resources/cert-manager.values.yaml.md)
3. install `cert-manager` by helm
    * ```shell
      helm install \
          --create-namespace --namespace basic-components \
          my-cert-manager \
          https://resource-ops.lab.zjvis.net:32443/charts/charts.jetstack.io/cert-manager-v1.5.4.tgz \
          --values cert-manager.values.yaml \
          --atomic
      ```
4. create cluster issuer
    * prepare [self.signed.cluster.issuer.yaml](resources/self.signed.cluster.issuer.yaml.md)
    * ```shell
      kubectl -n basic-components apply -f self.signed.cluster.issuer.yaml
      ```
      
### uninstall
1. delete cluster-issuer `self-signed-cluster-issuer`
    * ```shell
      kubectl -n basic-components delete clusterissuer self-signed-cluster-issuer
      ```
2. uninstall `my-cert-manager`
    * ```shell
      helm -n basic-components uninstall my-cert-manager
      ```
