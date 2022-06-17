## Commands

### port forwarding 

* ```shell
  kubectl port-forward --address 0.0.0.0 $SERVICE_OR_POD 8080:80 # local:pod
  ```

### export images
* ```shell
  DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
  for IMAGE in "docker.io/nginx:1.19.9-alpine" \
      "docker.io/alpine:3.15.0"
  do 
      IMAGE_NAME=$(echo ${IMAGE} | sed "s/\//_/g" | sed "s/\:/_/g").dim
      IMAGE_FILE=${DOCKER_IMAGE_PATH}/${IMAGE_NAME}
      docker inspect ${IMAGE} 2>&1 > /dev/null \
          && (docker save -o ${IMAGE_FILE} ${IMAGE} ) \
          || (docker pull ${IMAGE} && docker save -o ${IMAGE_FILE} ${IMAGE})
      chmod 644 ${IMAGE_FILE}
  done
  ```
* ```shell
  TARGET_HOST="ops-test-01.lab.zjvis.net"
  for IMAGE in "docker.io_nginx_1.19.9-alpine.dim" \
      "docker.io_alpine_3.15.0.dim"
  do
      scp ${IMAGE} root@${TARGET_HOST}:/tmp/${IMAGE}
  done
  ```
  
### image upload
* ```shell
  kubectl -n application exec -ti deployment/my-resource-nginx -c busybox -- sh
  ```
* ```shell
  POD_NAME=$(kubectl -n application get pod -l "app.kubernetes.io/instance=my-resource-nginx" -o jsonpath="{.items[0].metadata.name}")
  for IMAGE in "docker.io_nginx_1.19.9-alpine.dim" \
      "docker.io_alpine_3.15.0.dim"
  do
      chmod 644 ${IMAGE}
      kubectl cp ${IMAGE} application/${POD_NAME}:/data/docker-images/${IMAGE} -c busybox
      echo "${IMAGE} upload done"
  done 
  ```
  
### File upload
* ```shell
  kubectl -n application exec -ti deployment/my-resource-nginx \
      -c busybox -- sh -c "cd /conti && sh"
  ```
* ```shell
  POD_NAME=$(kubectl -n application get pod \
      -l "app.kubernetes.io/instance=my-resource-nginx" \
      -o jsonpath="{.items[0].metadata.name}")
  for FILE in "main_path.png"
  do
      kubectl cp ${FILE} application/${POD_NAME}:/conti/${FILE} -c busybox
      echo "${FILE} upload done"
  done 
  ```
### patch
* ```shell
  kubectl patch -n application svc my-redis-cluster \ 
      -p '{"spec":{"ports":[{"name":"tcp-redis","nodePort":"new image"}]}}'
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

