# verdaccio

## main usage

* none

## conceptions

* none

## purpose
* none

## pre-requirements
* [create local cluster for testing](../resources/local.cluster.for.testing.md)
* [ingress](../basic/ingress.nginx.md)
* [cert-manager](../basic/cert.manager.md)

## Do it

1. prepare [verdaccio.values.yaml](resources/verdaccio.values.yaml.md)
2. prepare images
    * ```shell  
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
      BASE_URL="https://conti-docker-images.oss-cn-hangzhou.aliyuncs.com"
      LOCAL_IMAGE="localhost:5000"
      for IMAGE in "docker.io/verdaccio/verdaccio:5.2.0" 
      do
          IMAGE_FILE=$(echo ${IMAGE} | sed "s/\//_/g" | sed "s/\:/_/g").dim
          LOCAL_IMAGE_FIEL=${DOCKER_IMAGE_PATH}/${IMAGE_FILE}
          if [ ! -f ${LOCAL_IMAGE_FIEL} ]; then
              curl -o ${IMAGE_FILE} -L ${BASE_URL}/${IMAGE_FILE} \
                  && mv ${IMAGE_FILE} ${LOCAL_IMAGE_FIEL} \
                  || rm -rf ${IMAGE_FILE}
          fi
          docker image load -i ${LOCAL_IMAGE_FIEL}
          docker image inspect ${IMAGE} || docker pull ${IMAGE}
          docker image tag ${IMAGE} ${LOCAL_IMAGE}/${IMAGE}
          docker push ${LOCAL_IMAGE}/${IMAGE}
      done
      ```
3. create `verdaccio-secret`
   * ```shell
     # uses the "Array" declaration
     # referencing the variable again with as $PASSWORD an index array is the same as ${PASSWORD[0]}
     PASSWORD=($((echo -n $RANDOM | md5sum 2>/dev/null) || (echo -n $RANDOM | md5 2>/dev/null)))
     # NOTE: username should have at least 6 characters
     kubectl -n application \
         create secret generic verdaccio-secret \
         --from-literal=username=admin \
         --from-literal=password=$PASSWORD \
     # username & password
     kubectl -n application get secret verdaccio-secret -o jsonpath={.data.username} | base64 --decode && echo
     kubectl -n application get secret verdaccio-secret -o jsonpath={.data.password} | base64 --decode && echo
     ```
4. install by helm
    * ```shell
      helm install \
          --create-namespace --namespace application \
          my-verdaccio \
          https://conti-charts.oss-cn-hangzhou.aliyuncs.com/github.com/verdaccio/charts/releases/download/verdaccio-4.6.2/verdaccio-4.6.2.tgz \
          --values verdaccio.values.yaml \
          --atomic
      ```

## test
1. check connection
    * ```shell
      curl --insecure --header 'Host: npm.test.cnconti.cc' https://localhost
      ```
2. works as a npm proxy and private registry that can publish packages
    * nothing in storage before actions
      * ```shell
        kubectl -n application exec -it  deployment/my-verdaccio -- ls -l /verdaccio/storage/data
        ```
      * prepare [npm.registry.test.sh]
      * prepare [npm.login.expect]
      * run npm install
        + ```shell
          docker run --rm \
              --add-host verdaccio.local:172.17.0.1 \
              -e NPM_ADMIN_USERNAME=admin \
              -e NPM_ADMIN_PASSWORD=${PASSWORD} \
              -e NPM_LOGIN_EMAIL=your-email@some.domain \
              -e NPM_REGISTRY=https://verdaccio.local.com \
              -v $(pwd)/npm.registry.test.sh:/app/npm.registry.test.sh:ro \
              -v $(pwd)/npm.login.expect:/app/npm.login.expect:ro \
              --workdir /app \
              -it docker.io/node:17.5.0-alpine3.15 \
              sh /app/npm.registry.test.sh
          ```
3. 
4. 
5. 
6. visit `https://npm.test.cnconti.cc`
      
## uninstall 
* ```shell
  helm -n application uninstall my-verdaccio
  ```



















