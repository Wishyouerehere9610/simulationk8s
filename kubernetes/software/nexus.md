# nexus

## main usage
* Provide teams with built-in Maven repositories

## conceptions
* none

## purpose
* none

## precondition
* [create local cluster for testing](/kubernetes/create.local.cluster.with.kind.md)
* [installed ingress](/kubernetes/basic/ingress.nginx.md)
* [installed cert-manager](/kubernetes/basic/cert.manager.md)

## do it
1. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource.cnconti.cc/docker-images"
      # BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
      for IMAGE in "docker.io_sonatype_nexus3_3.37.3.dim" \
          "docker.io_library_gradle_7.4.0-jdk8.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      DOCKER_REGISTRY="localhost:5000"
      for IMAGE in "docker.io/sonatype/nexus3:3.37.3"
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
2. create `nexus-secret`
    * ```shell
      kubectl get namespace application || kubectl create namespace application
      PASSWORD=($((echo -n $RANDOM | md5sum 2>/dev/null) || (echo -n $RANDOM | md5 2>/dev/null)))
      # NOTE: username should have at least 6 characters
      kubectl -n application \
          create secret generic nexus-secret \
          --from-literal=username=admin \
          --from-literal=password=${PASSWORD}
      ```
3. prepare [nexus.values.yaml](resources/nexus.values.yaml.md)
4. install by helm
    * NOTE: `https://resource-ops.lab.zjvis.net:32443/charts/sonatype.github.io/helm3-charts/nexus-repository-manager-37.3.2.tgz`
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
     curl --insecure --header 'Host: nexus.local' https://localhost
     ```
2. visit `https://nexus.local`
    * authentication `admin`
        + ```shell
          kubectl -n application exec -it  deployment/my-nexus \
               -- cat /nexus-data/admin.password && echo
          ```
    * New password for first login
        + ```shell
          kubectl -n application get secret nexus-admin-secret \
              -o jsonpath={.data.password} | base64 --decode && echo
          ```
    * enable `anonymous access`
    * click `Finish` button
3. configure maven-central repository
    * visit `https://nexus.local/#admin/repository/repositories:maven-central`
    * change Proxy.Remote storage to `https://maven.aliyun.com/repository/central`
    * click `Save` button
4. works as a npm proxy and private registry that can publish packages
    * `commons-math3` not in storage before actions
        + ```shell
          kubectl -n application exec -it deployment/my-nexus-nexus-repository-manager -- \
              bash -c 'grep -r commons-math3 /nexus-data/blobs || echo not found anything'
          ```
    * prepare [nexus.repository.manager.test.sh](resources/nexus.repository.manager.test.sh.md)
    * prepare [nexus.build.gradle](resources/nexus.build.gradle.md)
    * run `nexus test`
        + ```shell
          PASSWORD=$(kubectl -n application get secret nexus-secret -o jsonpath={.data.password} | base64 --decode)
          docker run --rm \
              -e ADMIN_PASSWORD=${PASSWORD} \
              -v $(pwd)/nexus.repository.manager.test.sh:/app/nexus.repository.manager.test.sh:ro \
              -v $(pwd)/nexus.build.gradle:/app/nexus.build.gradle:ro \
              --workdir /app \
              -it docker.io/gradle:7.4.0-jdk8 \
              bash '/app/nexus.repository.manager.test.sh'
          ```
    * `commons-math3` in storage after actions
        + ```shell
          kubectl -n application exec -it deployment/my-nexus \
              -- grep -r commons-math3 /nexus-data/blobs
          ```
5. visit `https://nexus.local/#browse/browse:maven-releases`
    * ```shell
      kubectl -n application get secret nexus-admin-secret \
          -o jsonpath={.data.username} | base64 --decode && echo
      kubectl -n application get secret nexus-admin-secret \
          -o jsonpath={.data.password} | base64 --decode && echo
      ```

## uninstall
1. uninstall `my-nexus`
    * ```shell
      helm -n application uninstall my-nexus \
          && kubectl -n application delete pvc my-nexus-nexus-repository-manager-data
      ```
2. delete secret `nexus-secret`
    * ```shell
      kubectl -n application delete secret nexus-secret
      ```



















