# ingress nginx

## main usage

* ingress nginx to expose http/https endpoints

## conceptions

* none

## purpose

* create a kubernetes cluster by kind
* setup ingress-nginx
* install nginx service and access it with ingress

## pre-requirements

* none

## Do it
1. [create local cluster for testing](../local.cluster.for.testing.md)
2. install ingress nginx
    * prepare [ingress.nginx.values.yaml](resources/ingress.nginx.values.yaml.md)
    * prepare images
        + ```shell
          DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
          BASE_URL="https://resources.conti2021.icu/docker-images"
          LOCAL_IMAGE="localhost:5000"
          for IMAGE in "k8s.gcr.io/ingress-nginx/controller:v1.0.3" \
              "k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.0" \
              "k8s.gcr.io/defaultbackend-amd64:1.5"
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
    * install by helm
      * ```shell
        helm install \
            --create-namespace --namespace basic-components \
            my-ingress-nginx \
            https://resources.conti2021.icu/charts/ingress-nginx-4.0.5.tgz \
            --values ingress.nginx.values.yaml \
            --atomic
        ```
3. install nginx service
    * prepare [nginx.values.yaml](resources/nginx.values.yaml.md)
    * prepare images
        + ```shell
          DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
          BASE_URL="https://resources.conti2021.icu/docker-images"
          LOCAL_IMAGE="localhost:5000"
          for IMAGE in "docker.io/bitnami/nginx:1.21.3-debian-10-r29" 
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
    * isntall by helm
      * ```shell
        helm install \
            --create-namespace --namespace test \
            my-nginx \
            https://resources.conti2021.icu/charts/nginx-9.5.7.tgz  \
            --values nginx.values.yaml \
            --atomic
        ```

## Test
1. access nginx service with ingress
    + ```shell
      curl --header 'Host: my.nginx.tech' http://localhost
      ```
