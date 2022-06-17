## pypiserver

### main usage
* 为 `algo-py` 提供pypi仓库

### conceptions
* whl

### pre-requirements
* [create.local.cluster.with.kind](../create.local.cluster.with.kind.md)
* [ingress.nginx](../basic/ingress.nginx.md)
* [cert.manager](../basic/cert.manager.md)
* [docker.registry](../basic/docker.registry.md)

### installation
1. prepare [pypiserver.values.yaml](resources/pypiserver.values.yaml.md)
2. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops-test.lab.zjvis.net:32443/docker-images"
      for IMAGE in "docker.io_pypiserver_pypiserver_v1.3.2.dim" \
          "docker.io_python_3.9.12-buster.dim"
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
      for IMAGE in "docker.io/pypiserver/pypiserver:v1.3.2"
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
          my-pypiserver \
          https://resource.cnconti.cc/charts/sonatype.github.io/helm3-charts/nexus-repository-manager-37.3.2.tgz \
          --values pypiserver.values.yaml \
          --atomic
      ```

### test
1. check connection
    * ```shell
      curl --insecure --header 'Host: nexus-ops-test.lab.zjvis.net' https://localhost:32443
      ```
2. prepare [pypiserver.create.packaging.bash](resources/pypiserver.create.packaging.bash)
    * ```shell
      docker run --rm \
          --add-host http://pypiserver.local:192.168.31.31 \
          -v $(pwd)/pypiserver.create.packaging.bash:/app/pypiserver.create.packaging.bash:ro \
          --workdir /app \
          -it docker.io/python:3.9.12-buster \
          bash '/app/nexus.repository.manager.test.sh'
      ```
   
