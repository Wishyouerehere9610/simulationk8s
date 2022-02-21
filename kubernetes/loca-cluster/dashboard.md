# kubernetes dashboard
* CName: `dashboard-ops.lab.zjvis.net` `k8s-01.lab.zjvis.net`

## install kubernetes dashboard
1. prepare [dashboard.values.yaml](resources/dashboard.values.yaml.md)
2. prepare images
   * ```shell
     DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
     BASE_URL="https://resource.static.zjvis.net/docker-images"
     for IMAGE in "docker.io_kubernetesui_dashboard_v2.4.0.dim" \
         "docker.io_kubernetesui_metrics-scraper_v1.0.7.dim" 
     do
         IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
         if [ ! -f $IMAGE_FILE ]; then
             TMP_FILE=$IMAGE_FILE.tmp \
                 && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                 && mv $TMP_FILE $IMAGE_FILE
         fi
         docker image load -i $IMAGE_FILE
     done
     DOCKER_REGISTRY="docker-registry-ops.lab.zjvis.net:32443"
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
         https://resource.static.zjvis.net/charts/kubernetes.github.io/dashboard/kubernetes-dashboard-5.0.5.tgz \
         --values dashboard.values.yaml \
         --atomic
     ```
 
## test
1. check connection
   * ```shell
     curl --insecure --header 'Host: dashboard-ops.lab.zjvis.net' https://localhost
     ```
2. create read only `user`
   * prepare [create.user.yaml](resources/create.user.yaml.md)
   * ```shell
     kubectl apply -f create.user.yaml
     ```
3. extract user token
   * ```shell
     kubectl -n application get secret \
         $(kubectl -n application get ServiceAccount dashboard-ro -o jsonpath="{.secrets[0].name}") \
         -o jsonpath="{.data.token}" | base64 --decode \
         && echo
     ```
4. visit `https://dashboard-ops.lab.zjvis.net`
   * use the extracted token to login
     
## uninstallation
1. delete rbac resources
   * ```shell
     kubectl delete -f create.user.yaml
     ```
2. uninstall `dashboard`
   * ```shell
     helm -n application uninstall my-dashboard
     ```
     