### export images
* ```shell
  DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
  for IMAGE in "docker.io/nginx:1.19.9-alpine" \
      "docker.io/alpine:3.15.0"
  do 
      IMAGE_NAME=$(echo ${IMAGE} | sed "s/\//_/g" | sed "s/\:/_/g").dim
      IMAGE_FILE=${DOCKER_IMAGE_PATH}/${IMAGE_NAME}
      if [ ! -f ${IMAGE_FILE} ]; then
          docker inspect ${IMAGE} 2>&1 > /dev/null \
              && (docker save -o ${IMAGE_FILE} ${IMAGE} ) \
              || (docker pull ${IMAGE} && docker save -o ${IMAGE_FILE} ${IMAGE})
          echo $IMAGE_FILE save success
      else
          echo $IMAGE_FILE exits
      fi     
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

### file upload
* ```shell
  kubectl -n application exec -ti deployment/my-resource-nginx \
      -c busybox -- sh -c "cd /conti && sh"
  ```
* ```shell
  POD_NAME=$(kubectl -n application get pod \
      -l "app.kubernetes.io/instance=my-resource-nginx" \
      -o jsonpath="{.items[0].metadata.name}")
  for FILE in "docker.io_nginx_1.19.9-alpine.dim" \
      "docker.io_alpine_3.15.0.dim"
  do
      chmod 644 ${FILE} \
          && kubectl cp ${FILE} application/${POD_NAME}:/conti/${FILE} -c busybox \
          && echo "${FILE} upload done"
  done 
  ```
