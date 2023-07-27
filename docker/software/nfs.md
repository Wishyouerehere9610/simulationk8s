# nfsv4

## installation
1. prepare images
    * ```shell
      docker pull docker.io/erichough/nfs-server:2.2.1
      ```
2. install `nfsv4`
    * ```shell
      mkdir -p $(pwd)/data/nfs/data \
          && echo '/data *(rw,fsid=0,no_subtree_check,insecure,no_root_squash)' > $(pwd)/data/nfs/exports \
          && modprobe nfs && modprobe nfsd \
          && docker run \
               --name nfs4 \
               --privileged \
               --restart always \
               -p 2049:2049 \
               -v $(pwd)/data/nfs/data:/data \
               -v $(pwd)/data/nfs/exports:/etc/exports:ro \
               -d docker.io/erichough/nfs-server:2.2.1
      ```

## test
1. run `nfs test`
    * ```shell
      # you may need nfs-utils
      # for centos:
      # yum install nfs-utils
      # for ubuntu:
      # apt-get install nfs-common
      mkdir -p $(pwd)/mnt/nfs \
          && mount -t nfs4 -v localhost:/ $(pwd)/mnt/nfs
      ```
