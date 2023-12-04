## kubernetes dashboard
#### CName:
* `dashboard-ops-dev.lab.zjvis.net`
* `ops-dev-01.lab.zjvis.net`

### install resource-nginx
1. prepare [dashboard.values.yaml](resources/dashboard.values.yaml.md)
2. prepare images
    * ```shell
      
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
      curl --insecure --header 'Host: dashboard-ops-dev.lab.zjvis.net' https://localhost:32443
     ```
2. create read only user
   * prepare [dashboard.create.user.yaml](resources/dashboard.create.user.yaml.md)
   * ```shell
     kubectl apply -f dashboard.create.user.yaml
     ``` 
3. visit `https://dashboard-ops-dev.lab.zjvis.net:32443`
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
