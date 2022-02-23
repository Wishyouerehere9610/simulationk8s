# docker registry

## main usage
* a registry for docker

## conceptions
* none

## purpose
* create a kubernetes cluster by kind
* setup ingress
* setup cert-manager and self-signed issuer
* setup docker registry
* test docker registry

## pre-requirements
* [local.cluster.for.testing](../resources/local.cluster.for.testing.md)
* [ingress-nginx](ingress.nginx.md)
* [cert-manager](cert.manager.md)

## Do it
1. prepare [docker.registry.values.yaml](resources/docker.registry.values.yaml.md)
2. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
      BASE_URL="https://conti-docker-images.oss-cn-hangzhou.aliyuncs.com"
      LOCAL_IMAGE="localhost:5000"
      for IMAGE in "docker.io/registry:2.7.1" \
          "docker.io/busybox:1.33.1-uclibc"
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
         --create-namespace --namespace basic-components \
         my-docker-registry \
         https://resources.conti2021.icu/charts/docker-registry-1.14.0.tgz \
         --values docker.registry.values.yaml \
         --atomic
     ```
4. configure ingress with tls
   * NOTE: ingress in helm chart is not compatible enough for us, we have to install ingress manually
   * prepare [docker.registry.ingress.yaml](resources/docker.registry.ingress.yaml.md)
   * apply ingress
      + ```shell
          kubectl -n basic-components apply -f docker.registry.ingress.yaml
          ```

## Test
1. check with docker-registry
   * ```shell
      IMAGE=docker.io/busybox:1.33.1-uclibc \
          && TARGET_IMAGE=docker-registry.test.cnconti.cc:32443/$IMAGE \
          && docker tag $IMAGE $TARGET_IMAGE \
          && docker push $TARGET_IMAGE \
          && docker image rm $IMAGE \
          && docker image rm $TARGET_IMAGE \
          && docker pull $TARGET_IMAGE \
          && echo success
     ```