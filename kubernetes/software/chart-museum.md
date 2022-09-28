## chart-museum

### installation
1. prepare [chartmuseum.values.yaml](resources/chartmuseum.values.yaml.md)
2. prepare images 
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource.cnconti.cc/docker-images"
      # BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
      for IMAGE in "ghcr.io_helm_chartmuseum_v0.13.1.dim" \
          "bitnami_minideb_buster.dim"
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
      for IMAGE in "ghcr.io/helm/chartmuseum:v0.13.1" \
          "bitnami/minideb:buster"
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
3. install by helm 
    * ```shell
      helm install \
          --create-namespace --namespace application \
          my-chart-museum \
          https://resource.cnconti.cc/charts/chartmuseum.github.io/charts/chartmuseum-3.4.0.tgz \
          --values chartmuseum.values.yaml \
          --atomic
      ```
      
### test
1. check connection
    * ```shell
      curl --insecure --header 'Host: chartmuseum.local' http://localhost
      ```
2. test `push`
    * ```shell
      helm create mychart \
          && helm package mychart \
          && curl --insecure --data-binary "@mychart-0.1.0.tgz" \
          http://chartmuseum.local/api/charts
      ```
3. test `pull`
    * ```shell
      rm -rf mychart mychart-0.1.0.tgz \
          && helm pull mychart \
              --version 0.1.0 \
              --repo http://chartmuseum.local \
              --insecure-skip-tls-verify
      ```

### uninstallation
1. uninstall `my-chart-museum`
    * ```shell
      helm -n application uninstall my-chart-museum \
          && kubectl -n application delete pvc my-chart-museum-chartmuseum
      ```
