# neo4j-standalone

## main usage
* none

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
      # BASE_URL="https://resource-ops-dev.lab.zjvis.net:32443/docker-images"
      for IMAGE in "docker.io_neo4j_4.4.10.dim"
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
      for IMAGE in "docker.io/neo4j:4.4.10"
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
2. prepare [neo4j-standalone.values.yaml](resources/neo4j-standalone.values.yaml.md)
3. install by helm
    * ```shell
      helm install \
          --create-namespace --namespace application \
          my-neo4j-standalone \
          https://resource.cnconti.cc/charts/neo4j-standalone-4.4.10.tgz \
          --values neo4j-standalone.values.yaml \
          --atomic
      ```
4. apply `neo4j-standalone-tool`
    * prepare [neo4j-standalone.tool.yaml](resources/neo4j-standalone.tool.yaml.md)
    * ```shell
      kubectl -n application apply -f neo4j-standalone.tool.yaml
      ```
    
## test
1. connect to maria-db
    * prepare [neo4j-standalone.test.cql](resources/neo4j-standalone.test.cql.md)
    * ```shell
      POD_NAME=$(kubectl -n application get pod \
          -l "app.kubernetes.io/name=neo4j-standalone-tool" \
          -o jsonpath="{.items[0].metadata.name}")
      NEO4J_PASSWORD=$(kubectl -n application get secret my-neo4j-standalone-auth \
          -o jsonpath="{.data.NEO4J_AUTH}" | base64 --decode | awk -F'/' '{print $2}')
      kubectl -n application cp neo4j-standalone.test.cql ${POD_NAME}:/tmp/neo4j-standalone.test.cql
      kubectl -n application exec -it deployment/neo4j-standalone-tool -- bash -c "\
          cat /tmp/neo4j-standalone.test.cql | cypher-shell -u neo4j -p$NEO4J_PASSWORD -a 'neo4j://my-neo4j-standalone.middleware:7687'"
      ```

## uninstall
1. uninstall `my-neo4j-standalone`
    * ```shell
      helm -n application uninstall my-neo4j-standalone \
          && kubectl -n application delete pvc data-my-neo4j-standalone-0
      ```
2. delete `neo4j-standalone-tool`
    * ```shell
      kubectl -n application delete deployment neo4j-standalone-tool
      ```
