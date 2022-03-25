# nexus

## main usage

* none

## conceptions

* none

## purpose

* none

## pre-requirements

* [create local cluster for testing](../create.local.cluster.with.kind.md)
* [ingress](../basic/ingress.nginx.md)
* [cert-manager](../basic/cert.manager.md)

## Do it

1. prepare [nexus.values.yaml](resources/nexus.values.yaml.md)
2. prepare images
    * ```shell  
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
      BASE_URL="https://resource.cnconti.cc/docker-images"
      LOCAL_IMAGE="localhost:5000"
      for IMAGE in "docker.io/sonatype/nexus3:3.37.3" 
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
          --create-namespace --namespace application \
          my-nexus \
          https://resource.cnconti.cc/charts/sonatype.github.io/helm3-charts/nexus-repository-manager-37.3.2.tgz \
          --values nexus.values.yaml \
          --atomic
      ```
  
## test
1. check connection
   * ```shell
      curl --insecure --header 'Host: nexus.cnconti.cc' https://localhost
      ```
2. visit `https://nexus.cnconti.cc`
   * login `admin`
   * password
      * ```shell
       kubectl -n application exec -it  deployment/my-nexus -- cat /nexus-data/admin.password && echo
       ```

## uninstall 
* ```shell
  helm -n application uninstall my-nexus
  ```



















