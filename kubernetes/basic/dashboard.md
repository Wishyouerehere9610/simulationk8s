# kubernetes dashboard

## main usage
* a web based dashboard to manage kubernetes cluster

## conceptions
* none

## purpose

* create a kubernetes cluster by kind
* setup kubernetes dashboard
* create a read only user

## pre-requirements
* [download kubernetes binary tools](../resources/download.kubernetes.binary.tools.md)
* [create local cluster for testing](../resources/local.cluster.for.testing.md)
* [ingress-nginx](ingress.nginx.md)
* [cert-manager](cert.manager.md)

## Do it
1. prepart [dashboard.values.yaml](resources/dashboard.values.yaml.md)
2. prepare images
   * ```shell  
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
      BASE_URL="https://resource.cnconti.cc/docker-images"
      LOCAL_IMAGE="localhost:5000"
      for IMAGE in "docker.io/kubernetesui/dashboard:v2.4.0" \
          "docker.io/kubernetesui/metrics-scraper:v1.0.7"
      do
          IMAGE_FILE=$(echo ${IMAGE} | sed "s/\//_/g" | sed "s/\:/_/g").dim
          LOCAL_IMAGE_FIEL=${DOCKER_IMAGE_PATH}/${IMAGE_FILE}
          if [ ! -f ${LOCAL_IMAGE_FIEL} ]; then
              curl -o ${IMAGE_FILE} -L ${BASE_URL}/${IMAGE_FILE} \
                  && mv ${IMAGE_FILE} ${LOCAL_IMAGE_FIEL} \
                  || rm -rf ${IMAGE_FILE}
          fi
          docker image load -i ${LOCAL_IMAGE_FIEL} && rm -rf ${LOCAL_IMAGE_FIEL}
          docker image inspect ${IMAGE} || docker pull ${IMAGE}
          docker image tag ${IMAGE} ${LOCAL_IMAGE}/${IMAGE}
          docker push ${LOCAL_IMAGE}/${IMAGE}
      done
     ```
3. install by helm
   * ```shell
     helm install \
         --create-namespace --namespace basic-components \
         my-dashboard \
         https://resource.cnconti.cc/charts/kubernetes-dashboard-5.0.5.tgz
         --values dashboard.values.yaml \
         --atomic
     ```

## test
1. check connection
    * ```shell
      curl --insecure --header 'Host: dashboard.local.com' https://localhost
      ```
2. create read only `user`
    * prepare [create.user.yaml](resources/create.user.yaml.md)
    * ```shell
      kubectl apply -f create.user.yaml
      ```
3. extract user token
    * ```shell
      kubectl -n application get secret \
          $(kubectl -n basic-components get ServiceAccount dashboard-ro -o jsonpath="{.secrets[0].name}") \
          -o jsonpath="{.data.token}" | base64 --decode \
          && echo
      ```
4. visit `https://dashboard.local.com`
    * use the extracted token to login

## uninstallation
1. delete rbac resources
    * ```shell
      kubectl delete -f create.user.yaml
      ```
2. uninstall `dashboard`
    * ```shell
      helm -n basic-components uninstall my-dashboard
      ```





