## kubernetes dashboard
#### CName:
* `dashboard-ops-dev.lab.zjvis.net`
* `ops-dev-01.lab.zjvis.net`

### install resource-nginx
1. prepare [dashboard.values.yaml](resources/dashboard.values.yaml.md)
2. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
      for IMAGE in "docker.io_kubernetesui_dashboard_v2.4.0.dim" \
          "docker.io_kubernetesui_metrics-scraper_v1.0.7.dim" 
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      DOCKER_REGISTRY="docker-registry-simulation.lab.zjvis.net:32443"
      for IMAGE in "docker.io/kubernetesui/dashboard:v2.4.0" \
          "docker.io/kubernetesui/metrics-scraper:v1.0.7" 
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
3. install dashboard
   * ```shell
     helm install \
     --create-namespace --namespace application \
     my-dashboard \
     https://resource-ops.lab.zjvis.net:32443/charts/kubernetes.github.io/dashboard/kubernetes-dashboard-5.0.5.tgz \
     --values dashboard.values.yaml \*
     --atomic
     ```
     
## test
1. check connection
   * ```shell
      curl --insecure --header 'Host: dashboard-ops-simulation.lab.zjvis.net' https://localhost:32443
     ```
2. create read only user
   * prepare [dashboard.create.user.yaml](resources/dashboard.create.user.yaml.md)
   * ```shell
     kubectl apply -f dashboard.create.user.yaml
     ``` 
3. visit `https://dashboard-ops-simulation.lab.zjvis.net:32443/`
   * use the extracted token to login
   * ```shell
     kubectl -n application get secret \
      $(kubectl -n application get ServiceAccount dashboard-ro \
      -o jsonpath="{.secrets[0].name}") \
      -o jsonpath="{.data.token}" | base64 --decode && echo
     ```

## uninstallation
1. delete rbac resources
   * ```shell
      kubectl delete -f dashboard.create.user.yaml
     ```
2. uninstall `dashboard`
   * ```shell
      helm -n application uninstall my-dashboard
     ``` 
