## phpmyadmin
#### CName:
* `phpmyadmin-ops-dev.lab.zjvis.net`
* `ops-dev-01.lab.zjvis.net`

### install phpmyadmin
1. prepare [phpmyadmin.values.yaml](resources/phpmyadmin.values.yaml.md)
2. prepare images
    * ```shell
      
      ```
3. install by helm
   * ```shell
     helm install \
     --create-namespace --namespace application \
     my-phpmyadmin \
     https://resource-ops.lab.zjvis.net:32443/charts/charts.bitnami.com/bitnami/phpmyadmin-8.3.1.tgz \
     --values phpmyadmin.values.yaml \
     --atomic
      ```

## test
1. check connection
   * ```
     curl --insecure --header 'Host: phpmyadmin-ops-dev.lab.zjvis.net' https://localhost:32080
   
## uninstallation
1. uninstall `phpmyadmin`
    * ```shell
      helm -n application uninstall my-phpmyadmin