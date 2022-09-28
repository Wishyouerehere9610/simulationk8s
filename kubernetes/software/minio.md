# minio

## main usage
* Provides Minio functionality for applications

## conceptions
* none

## purpose
* install minio
* test minio
* 
## precondition
* [create.local.cluster.with.kind](/kubernetes/create.local.cluster.with.kind.md)
* [installed ingress-nginx](/kubernetes/basic/ingress.nginx.md)
* [installed cert-manager](/kubernetes/basic/cert.manager.md)

## do it
1. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource.cnconti.cc/docker-images"
      # BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
      for IMAGE in "docker.io_bitnami_minio_2022.8.22-debian-11-r0.dim" \
          "docker.io_bitnami_minio-client_2022.8.11-debian-11-r3.dim" \
          "docker.io_bitnami_bitnami-shell_11-debian-11-r28.dim"
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
      for IMAGE in "docker.io/bitnami/minio:2022.8.22-debian-11-r0" \
          "docker.io/bitnami/minio-client:2022.8.11-debian-11-r3" \
          "docker.io/bitnami/bitnami-shell:11-debian-11-r28"
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
2. prepare [minio.values.yaml](resources/minio.values.yaml.md)
3. install by helm
    * NOTE: `https://resource-ops.lab.zjvis.net:32443/charts/charts.bitnami.com/bitnami/minio-11.9.2.tgz`
    * ```shell
      helm install \
          --create-namespace --namespace application \
          my-minio \
          https://resource.cnconti.cc/charts/charts.bitnami.com/bitnami/minio-11.9.2.tgz \
          --values minio.values.yaml \
          --atomic
      ```
4. apply `minio-tool`
    * prepare [minio.tool.yaml](resources/minio.tool.yaml.md)
    * ```shell
      kubectl -n application apply -f minio.tool.yaml
      ```
5. access `web-minio.local`
    * ```shell
      # access-key/secret-key
      kubectl get secret --namespace application my-minio \
          -o jsonpath="{.data.root-user}" | base64 --decode && echo
      kubectl get secret --namespace application my-minio \
          -o jsonpath="{.data.root-password}" | base64 --decode && echo
      ```

## test
1. TODO

## uninstall
1. delete deployment `minio-tool`
    * ```shell
      kubectl -n application delete deployment minio-tool
      ```
2. uninstall `my-minio`
    * ```shell
      helm -n application uninstall my-minio \
          && kubectl -n application delete pvc my-minio
      ```
