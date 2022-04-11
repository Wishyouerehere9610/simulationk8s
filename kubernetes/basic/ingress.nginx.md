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

* [create.local.cluster.with.kind](../create.local.cluster.with.kind.md)

## do it
1. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
      BASE_URL="https://resource.cnconti.cc/docker-images"
      for IMAGE in "k8s.gcr.io/ingress-nginx/controller:v1.0.3" \
          "k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.0" \
          "docker.io/bitnami/nginx:1.21.3-debian-10-r29" \
          "k8s.gcr.io/defaultbackend-amd64:1.5"
      do
          IMAGE_NAME=$(echo ${IMAGE} | sed "s/\//_/g" | sed "s/\:/_/g").dim
          IMAGE_FILE=${DOCKER_IMAGE_PATH}/${IMAGE_NAME}
          if [ ! -f ${IMAGE_FILE} ]; then
              TMP_FILE=${IMAGE_NAME}.tmp
              curl -o "${TMP_FILE}" -L ${BASE_URL}/${IMAGE_NAME} \
                  && mv ${TMP_FILE} ${IMAGE_FILE} \
                  || rm -rf ${IMAGE_FILE}
          fi
          docker image load -i ${IMAGE_FILE} && rm -rf ${IMAGE_FILE}
          kind load docker-image ${IMAGE}
      done
      ```
2. prepare [ingress.nginx.values.yaml](resources/ingress.nginx.values.yaml.md)
3. install by helm
    * ```shell
      helm install \
          --create-namespace --namespace basic-components \
          my-ingress-nginx \
          https://resource.cnconti.cc/charts/kubernetes.github.io/ingress-nginx/ingress-nginx-4.0.5.tgz \
          --values ingress.nginx.values.yaml \
          --atomic
      ```

# test
1. prepare `test` namespace
    * ```shell
         kubectl get namespace test > /dev/null 2>&1 || kubectl create namespace test
      ```
2. install nginx service
    * prepare [nginx.values.yaml](resources/nginx.values.yaml.md)
    * install by helm
      * ```shell
        helm install \
            --create-namespace --namespace test \
            my-nginx \
            https://resource.cnconti.cc/charts/charts.bitnami.com/bitnami/nginx-9.5.7.tgz  \
            --values nginx.values.yaml \
            --atomic
        ```
3. check connection
    + ```shell
      curl --header 'Host: my-nginx.local.com' http://localhost
      ```
