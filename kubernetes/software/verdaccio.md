# verdaccio

## main usage
* Provide a unified NPM source built in for the team

## conceptions
* none

## purpose
* none

## precondition
* [create local cluster for testing](/kubernetes/create.local.cluster.with.kind.md)
* [installed ingress](/kubernetes/basic/ingress.nginx.md)
* [installed cert-manager](/kubernetes/basic/cert.manager.md)

## do it
1. prepare images
    * ```shell  
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource.cnconti.cc/docker-images"
      # BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
      for IMAGE in "docker.io_verdaccio_verdaccio_5.2.0.dim" \
          "docker.io_node_17.5.0-alpine3.15.dim" \
          "docker.io_xmartlabs_htpasswd_latest-20220301.dim"
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
      for IMAGE in "docker.io/verdaccio/verdaccio:5.2.0"
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
2. create `verdaccio-secret`
   * ```shell
     # uses the "Array" declaration
     # referencing the variable again with as $PASSWORD an index array is the same as ${PASSWORD[0]}
     PASSWORD=($((echo -n $RANDOM | md5sum 2>/dev/null) || (echo -n $RANDOM | md5 2>/dev/null)))
     # NOTE: username should have at least 6 characters
     kubectl -n application create secret generic verdaccio-secret \
         --from-literal=username=admin \
         --from-literal=password=$PASSWORD \
     ```
3. prepare [verdaccio.values.yaml](resources/verdaccio.values.yaml.md)
4. install by helm
    * NOTE: `https://resource-ops.lab.zjvis.net:32443/charts/charts.verdaccio.org/verdaccio-4.6.2.tgz`
    * ```shell
      helm install \
          --create-namespace --namespace application \
          my-verdaccio \
          https://resource.cnconti.cc/charts/charts.verdaccio.org/verdaccio-4.6.2.tgz \
          --values verdaccio.values.yaml \
          --atomic
      ```

## test
1. check connection
    * ```shell
      curl --insecure --header 'Host: verdaccio.local' https://localhost
      ```
2. works as a npm proxy and private registry that can publish packages
    * nothing in storage before actions
        + ```shell
          kubectl -n application exec -it  deployment/my-verdaccio -- ls -l /verdaccio/storage/data
          ```
    * prepare [verdaccio.test.sh](resources/verdaccio.test.sh.md)
    * prepare [verdaccio.login.expect](resources/verdaccio.login.expect.md)
    * run npm test
        + ```shell
          PASSWORD=$(kubectl -n application get secret verdaccio-secret -o jsonpath={.data.password} | base64 --decode )
          docker run --rm \
              --add-host verdaccio.local:172.17.0.1 \
              -e NPM_ADMIN_USERNAME=admin \
              -e NPM_ADMIN_PASSWORD=${PASSWORD} \
              -e NPM_LOGIN_EMAIL=your-email@some.domain \
              -e NPM_REGISTRY=https://verdaccio.local \
              -v $(pwd)/verdaccio.test.sh:/app/verdaccio.test.sh:ro \
              -v $(pwd)/verdaccio.login.expect:/app/verdaccio.login.expect:ro \
              --workdir /app \
              -it docker.io/node:17.5.0-alpine3.15 \
              sh /app/verdaccio.test.sh
          ```
3. visit `https://npm.local`
    * ```shell
      # username & password
      kubectl -n application get secret verdaccio-secret -o jsonpath={.data.username} | base64 --decode && echo
      kubectl -n application get secret verdaccio-secret -o jsonpath={.data.password} | base64 --decode && echo
      ```
      
## uninstall 
1. uninstall `my-verdaccio`
    * ```shell
      helm -n application uninstall my-verdaccio \
          kubectl -n application delete pvc my-verdaccio
      ```
2. delete secret `verdaccio-secret`
    * ```shell
      kubectl -n application delete secret verdaccio-secret
      ```
