# nexus

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

1. prepare [nexus.values.yaml](resources/nexus.values.yaml.md)
2. prepare images
    * ```shell  
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
      BASE_URL="https://aconti.oss-cn-hangzhou.aliyuncs.com/docker-images"
      LOCAL_IMAGE="localhost:5000"
      for IMAGE in "docker.io/busybox:1.33.1-uclibc" \
          "docker.io/sonatype/nexus3:3.37.3" 
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
3. install by helm
    * ```shell
      helm install \
          --create-namespace --namespace application \
          my-nexus \
          https://aconti.oss-cn-hangzhou.aliyuncs.com/charts/sonatype.github.io/helm3-charts/nexus-repository-manager-37.3.2.tgz \
          --values nexus.values.yaml \
          --atomic
      ```
  
## test

1. check connection
    * ```shell
      curl --insecure --header 'Host: nexus.cnconti.cc' https://localhost
    * ```
2. works as a npm proxy and private registry that can publish packages
    * nothing in storage before actions
      * ```shell
        kubectl -n application exec -it  deployment/my-nexus -- ls -l /verdaccio/storage/data
        ```
    * [test.sh]()
    * [login.expect]()
    * run install
      + ```shell
        docker run --rm \
            --add-host verdaccio.local:172.17.0.1 \
            -e NPM_ADMIN_USERNAME=admin \
            -e NPM_ADMIN_PASSWORD=your-admin-password \
            -e NPM_LOGIN_EMAIL=your-email@some.domain \
            -e NPM_REGISTRY=https://verdaccio.local \
            -v $(pwd)/npm.registry.test.sh:/app/npm.registry.test.sh:ro \
            -v $(pwd)/npm.login.expect:/app/npm.login.expect:ro \
            --workdir /app \
            -it docker.io/node:17.5.0-alpine3.15 \
            sh /app/npm.registry.test.sh
        
        ```
3. visit `nexus.test.cnconti.cc`
    * login

## uninstall 
* ```shell
  helm -n application uninstall my-nexus
  ```



















