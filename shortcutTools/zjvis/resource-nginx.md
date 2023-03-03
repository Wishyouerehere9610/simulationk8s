## file upload
* ```shell
  kubectl -n application exec -ti deployment/my-resource-nginx \
      -c busybox -- sh -c "cd /tmp && sh"
  ```
* ```shell
  POD_NAME=$(kubectl -n application get pod \
            -l "app.kubernetes.io/instance=my-resource-nginx" \
            -o jsonpath="{.items[0].metadata.name}")
  for FILE in "docker.io_nginx_1.19.9-alpine.dim" \
      "docker.io_alpine_3.15.0.dim"
  do
      chmod 644 ${FILE} \
          && kubectl cp ${FILE} application/${POD_NAME}:/tmp/${FILE} -c busybox \
          && echo "${FILE} upload done"
  done 
  ```

