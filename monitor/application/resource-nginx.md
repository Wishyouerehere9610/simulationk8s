## resouce-nginx
 #### CName: 
 * resource-ops-dev.lab.zjvis.net 
 * ops-dev-01.lab.zjvis.net

### install resource-nginx
1. prepare [resource.nginx.values.yaml](resources/resource.nginx.values.yaml.md)
2. prepare images
   * ```shell
      
      ```
3. creat namespace `application` if not exits 
   * ```shell
      kubectl get namespace application || kubectl create namespace application
     ```
4. create `resource-nginx-pvc`
   * prepare [resource.nginx.pvc.yaml](resources/resource.nginx.pvc.yaml.md)
   
5. install resource-nginx
   * ```shell
     helm install \
     --create-namespace --namespace application \
     my-resource-nginx \
     https://resource-ops.lab.zjvis.net:32443/charts/charts.bitnami.com/bitnami/nginx-9.5.7.tgz \
     --values resource.nginx.values.yaml \
     --atomic
     ```

## test
1. check connection
   * ```shell
      curl --insecure --header 'Host: resource-ops-dev.lab.zjvis.net' https://localhost:32443
     ```
2. add resource
   * ```shell
     kubectl -n application exec -it deployment/my-resource-nginx -c busybox \
     -- sh -c "echo this is a test > /data/file-created-by-busybox"
     ``` 
3. check resource by `curl`
   * ```shell
     curl --insecure --header 'Host: resource-ops-dev.lab.zjvis.net' https://localhost:32443/file-created-by-busybox
     ```

## uninstallation
1. check `resource-nginx`
   * ```shell
      helm -n application uninstall my-resource-nginx
     ```
2. delete pvc `resource-nginx-pvc`
   * ```shell
     kubectl -n application delete pvc resource-nginx-pvc
     ``` 
