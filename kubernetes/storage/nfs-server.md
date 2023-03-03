## nfs-server
1. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource.cnconti.cc/docker-images"
      IMAGE_FILE=$DOCKER_IMAGE_PATH/docker.io_erichough_nfs-server_2.2.1.dim
      if [ ! -f $IMAGE_FILE ]; then
          TMP_FILE=$IMAGE_FILE.tmp \
              && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
              && mv $TMP_FILE $IMAGE_FILE
      fi
      docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
      ```
2. install nfs to provide storage class
    * ```shell
      mkdir -p /data/nfs/data \
      && echo '/data *(rw,fsid=0,no_subtree_check,insecure,no_root_squash)' > /data/nfs/exports \
      && modprobe nfs && modprobe nfsd \
      && docker run \
             --name nfs4 \
             --restart always \
             --privileged \
             -p 2049:2049 \
             -v /data/nfs/data:/data \
             -v /data/nfs/exports:/etc/exports:ro \
             -d docker.io/erichough/nfs-server:2.2.1
      ```