
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

### 制作在线镜像
* ```shell
  for IMAGE in "docker.io/bitnami/minio:2021.9.18-debian-10-r0" \
      "docker.io/bitnami/minio-client:2021.9.2-debian-10-r17" \
      "docker.io/bitnami/bitnami-shell:10-debian-10-r198"
  do
      IMAGE_FILE=$(echo ${IMAGE} | sed "s/\//_/g" | sed "s/\:/_/g").dim
      LOCAL_IMAGE_FIEL=/opt/data/docker-images/${IMAGE_FILE}
      if [ ! -f ${LOCAL_IMAGE_FIEL} ]; then
          docker pull ${IMAGE}
          docker save -o ${IMAGE_FILE}  ${IMAGE}
          mv -n ${IMAGE_FILE} ${LOCAL_IMAGE_FIEL} && rm -rf ${IMAGE_FILE}
          chmod 644 ${LOCAL_IMAGE_FIEL}
      fi
  done
  ```