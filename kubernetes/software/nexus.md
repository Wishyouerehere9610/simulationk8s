# haproxy

## main usage

* none

## conceptions

* none

## purpose
* none

## pre-requirements
* [create local cluster for testing](../local.cluster.for.testing.md)


## Do it

1. prepare [nexus.values.yaml](resources/nexus.values.yaml)
2. prepare images
    * ```shell  
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
      BASE_URL="https://resources.conti2021.icu/docker-images"
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
          https://resources.conti2021.icu/charts/nexus-repository-manager-37.3.2.tgz \
          --values nexus.values.yaml \
          --atomic
      ```
      
## test

## uninstall 
* ```shell
  helm -n application uninstall my-nexus
  ```



















