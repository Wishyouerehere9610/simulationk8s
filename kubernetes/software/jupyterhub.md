# jupyterhub

## main usage
* jupyterhub

## conceptions
* none

## purpose
* none

## precondition
* [create local cluster for testing](../resources/local.cluster.for.testing.md)
* [ingress](../basic/ingress.nginx.md)
* [cert-manager](../basic/cert.manager.md)

## Do it
1. prepare [jupyterhub.values.yaml](resources/jupyterhub.values.uaml)
2. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
      BASE_URL="https://resources.conti2021.icu/docker-images"
      LOCAL_IMAGE="localhost:5000"
      for IMAGE in "docker.io/bitnami/jupyterhub:1.5.0-debian-10-r34" \
          "docker.io/bitnami/configurable-http-proxy:4.5.0-debian-10-r146" \
          "docker.io/bitnami/jupyter-base-notebook:1.5.0-debian-10-r34" \
          "docker.io/bitnami/bitnami-shell:10-debian-10-r281" \
          "docker.io/bitnami/postgresql:11.14.0-debian-10-r17" \
          "docker.io/bitnami/bitnami-shell:10-debian-10-r265" \
          "docker.io/bitnami/postgres-exporter:0.10.0-debian-10-r133"
      do
          IMAGE_FILE=$(echo ${IMAGE} | sed "s/\//_/g" | sed "s/\:/_/g").dim
          LOCAL_IMAGE_FIEL=/opt/data/docker-images/${IMAGE_FILE}
          if [ ! -f ${LOCAL_IMAGE_FIEL} ]; then
              docker pull ${IMAGE}
              docker save -o ${IMAGE_FILE}  ${IMAGE}
              mv -n ${IMAGE_FILE} ${LOCAL_IMAGE_FIEL} && rm -rf ${IMAGE_FILE}
              chmod 644 ${LOCAL_IMAGE_FIEL}
          fi
      done 
      ```
3. isntall by helm
    * ```shell
      helm install \
          --create-namespace --namespace application \
          my-jupyterhub \
          https://resources.conti2021.icu/charts/jupyterhub-1.2.0.tgz \
          --values jupyterhub.values.yaml \
          --atomic
      ```

## Test

* check connection
  * ```shell
    curl --insecure --header 'Host: jupyterhub.test.cnconti.cc' https://localhost
    ```
* visit gitea via website
   - configure hosts
     - ```shell
       echo $QEMU_HOST_IP jupyterhub.local >> /etc/hosts
       ```
   - visit `https://jupyterhub.local:10443/` with your browser
   - login with
     - default user: admin
     * ```shell
       # password extracted by command
       kubectl get secret --namespace application my-jupyterhub-hub -o jsonpath="{.data['values\.yaml']}" | base64 --decode | awk -F: '/password/ {gsub(/[ \t]+/, "", $2);print $2}'
       ```

## Uninstallation
* ```shell
  helm -n application uninstall my-jupyterhub \
      && kubectl -n application delete pvc data-my-jupyterhub-postgresql-0 \
      && kubectl -n application delete pvc my-jupyterhub-claim-admin
  ```