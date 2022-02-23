# gitea

## main usage

* service for git repositories

## conceptions

* none

## purpose

* prepare a kind cluster with basic components
* install gitea

## pre-requirements
* [create local cluster for testing](../resources/local.cluster.for.testing.md)
* [ingress](../basic/ingress.nginx.md)
* [cert-manager](../basic/cert.manager.md)

## Do it
1. prepare [gitea.values.yaml](resources/gitea.values.yaml.md)
2. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
      BASE_URL="https://resources.conti2021.icu/docker-images"
      LOCAL_IMAGE="localhost:5000"
      for IMAGE in "docker.io/gitea/gitea:1.15.3" \
          "docker.io/bitnami/memcached:1.6.9-debian-10-r114" \
          "docker.io/bitnami/memcached-exporter:0.8.0-debian-10-r105" \
          "docker.io/bitnami/postgresql:11.11.0-debian-10-r62" \
          "docker.io/bitnami/bitnami-shell:10" \
          "docker.io/bitnami/postgres-exporter:0.9.0-debian-10-r34" 
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
3. create `gitea-admin-secret`
    * ```shell
      # uses the "Array" declaration
      # referencing the variable again with as $PASSWORD an index array is the same as ${PASSWORD[0]}
      kubectl get namespace application \
          || kubectl create namespace application
      PASSWORD=($((echo -n $RANDOM | md5sum 2>/dev/null) || (echo -n $RANDOM | md5 2>/dev/null)))
      # NOTE: username should have at least 6 characters
      kubectl -n application \
          create secret generic gitea-admin-secret \
          --from-literal=username=gitea_admin \
          --from-literal=password=$PASSWORD
      ```
4. install with helm
    * ```shell
      helm install \
          --create-namespace --namespace application \
          my-gitea \
          https://resources.conti2021.icu/charts/gitea-4.1.1.tgz \
          --values gitea.values.yaml \
          --atomic
      ```

## Test
* visit `gitea.test.cnconti.cc`
    * port-forward
        + ```shell
          kubectl --namespace application port-forward svc/my-gitea-http 3000:3000 --address 0.0.0.0
          ```
    * visit http://$HOST:3000
    * password
        + ```shell
          kubectl get secret gitea-admin-secret -n gitea -o jsonpath={.data.password} | base64 --decode && echo
          ```

* visit gitea from SSH
    * port-forward
        + ```shell
          kubectl --namespace application port-forward svc/my-gitea-ssh 1022:22 --address 0.0.0.0
          ```
    + 测试ssh链接是否正常
        * ```shell
          git clone ssh://git@gitea.test.cnconti.cc:1022/gitea_admin/test-repo.git
          ```