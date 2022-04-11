
## Common commands

### port forwarding 端口映射

* ```shell
  kubectl port-forward --address 0.0.0.0 $SERVICE_OR_POD 8080:80 # local:pod
  ```
  
### pod sa POD内部获取sa token信息

* 通过将认证令牌直接发送到 API 服务器，也可以避免运行 kubectl proxy 命令。 内部的证书机制能够为链接提供保护
* ```shell
  # 指向内部 API 服务器的主机名
  APISERVER=https://kubernetes.default.svc
  
  # 服务账号令牌的路径
  SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount
  
  # 读取 Pod 的名字空间
  NAMESPACE=$(cat ${SERVICEACCOUNT}/namespace)
  
  # 读取服务账号的持有者令牌
  TOKEN=$(cat ${SERVICEACCOUNT}/token)
  
  # 引用内部证书机构（CA）
  CACERT=${SERVICEACCOUNT}/ca.crt
  
  # 使用令牌访问 API
  curl --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api
  ```

### 预准备(仓库无image)
* ```shell
   for IMAGE in "docker.elastic.co/elasticsearch/elasticsearch:7.17.1" \
       "docker.elastic.co/elasticsearch/elasticsearch:7.17.0"
   do
       docker pull ${IMAGE} \
           && docker inspect ${IMAGE} 2>&1 \
           && echo "success"
   done
   ```

### 制作在线镜像
* ```shell
  DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
  for IMAGE in "docker.io/busybox:1.33.1-uclibc"
  do
      IMAGE_NAME=$(echo ${IMAGE} | sed "s/\//_/g" | sed "s/\:/_/g").dim
      IMAGE_FILE=${DOCKER_IMAGE_PATH}/${IMAGE_NAME}
      if [ ! -f ${IMAGE_FILE} ]; then
          TMP_FILE=${IMAGE_NAME}.tmp
          docker inspect ${IMAGE} 2>&1 > /dev/null \
              && (docker save -o ${IMAGE_FILE} ${IMAGE} ) \
              || (docker pull ${IMAGE} \
                  && docker save -o ${IMAGE_FILE} ${IMAGE} )
      fi
      chmod 644 ${IMAGE_FILE}
      POD_NAME=$(kubectl -n application get pod \
          -l "app.kubernetes.io/instance=my-resource-nginx" \
          -o jsonpath="{.items[0].metadata.name}") \
          && kubectl cp ${IMAGE_FILE} \
             application/${POD_NAME}:/data/docker-images/${IMAGE_NAME} \
             -c busybox
      rm -rf ${IMAGE_FILE}
  done
  ```
* ```shell
  kubectl -n application exec -ti $(kubectl -n application get pod \
      -l "app.kubernetes.io/instance=my-resource-nginx" \
      -o jsonpath="{.items[0].metadata.name}" ) \
      -c busybox -- sh
  ```

### Chart上传
* ```shell
  FILE="binary/"
  POD_NAME=$(kubectl -n application get pod \
    -l "app.kubernetes.io/instance=my-resource-nginx" \
    -o jsonpath="{.items[0].metadata.name}") \
    && kubectl cp ${FILE} \
       application/${POD_NAME}:/data/${FILE} \
       -c busybox
    ```

### patch
* pass
  * ```shell
    kubectl patch svc my-redis-cluster -p '{"spec":{"ports":[{"name":"tcp-redis","nodePort":"new image"}]}}'
    ```



