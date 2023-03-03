## rook-ceph-installation
1. what we have
   * `/dev/sda1` which have initialized as `xfs` in every node
   * `/dev/sdb` in every node
2. prepare images for all nodes
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource.cnconti.cc/docker-images"
      for IMAGE in "k8s.gcr.io_sig-storage_csi-attacher_v3.2.1.dim" \
          "k8s.gcr.io_sig-storage_csi-node-driver-registrar_v2.2.0.dim" \
          "k8s.gcr.io_sig-storage_csi-provisioner_v2.2.2.dim" \
          "k8s.gcr.io_sig-storage_csi-resizer_v1.2.0.dim" \
          "k8s.gcr.io_sig-storage_csi-snapshotter_v4.1.1.dim" \
          "k8s.gcr.io_sig-storage_local-volume-provisioner_v2.4.0.dim" \
          "docker.io_rook_ceph_v1.9.12.dim" \
          "quay.io_cephcsi_cephcsi_v3.6.2.dim" \
          "quay.io_ceph_ceph_v16.2.5.dim" \
          "docker.io_bitnami_mariadb_10.5.12-debian-10-r0.dim"    
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          ctr -n k8s.io i import $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      ```
3. prepare storage class named `rook-monitor` by `local-static-provisioner`
    * prepare resources at every node except master node
        + ```shell
          HOSTNAME=$(hostname)
          PREFIX=${HOSTNAME:0:11}
          mkdir -p /data/local-static-provisioner/rook-ceph/monitor/rook-$PREFIX
          echo "/dev/sdb1 /data/local-static-provisioner/rook-ceph/monitor/rook-$PREFIX-01 xfs defaults 0 0" >> /etc/fstab
          mount -a
          ```
    * prepare [local.rook.monitor.values.yaml](resources/local.rook.monitor.values.yaml.md) as file `/tmp/local.rook.monitor.values.yaml`
        + ```shell
          helm install \
             --create-namespace --namespace local-disk \
             disk-rook-monitor \
             https://resource.cnconti.cc/charts/others/sig-storage-local-static-provisioner.v2.4.0.tar.gz \
             --values /tmp/local.rook.monitor.values.yaml \
             --atomic
          ```
4. prepare storage class named `rook-data` by `local-static-provisioner`
    * prepare resources at every node except master
        + ```shell
          HOSTNAME=$(hostname)
          PREFIX=${HOSTNAME:0:11}
          mkdir -p /data/local-static-provisioner/rook-ceph/data
          ln -s /dev/sdc /data/local-static-provisioner/rook-ceph/data/rook-$PREFIX-01
          ```
    * prepare [local.rook.data.values.yaml](resources/local.rook.data.values.yaml.md) as file `/tmp/local.rook.data.values.yaml`
        + ```shell
          helm install \
             --create-namespace --namespace local-disk \
             disk-rook-data \
             https://resource.cnconti.cc/charts/others/sig-storage-local-static-provisioner.v2.4.0.tar.gz \
             --values /tmp/local.rook.data.values.yaml \
             --atomic
          ```
    * check pod healthy and pvs created
        + ```shell
          kubectl -n local-disk get pod
          kubectl -n local-disk wait --for=condition=ready pod --all
          kubectl get pv
          ```
5. create rook operator by helm
    * prepare [rook.ceph.operator.values.yaml](resources/rook.ceph.operator.values.yaml.md) as file `/tmp/rook.ceph.operator.values.yaml`
        + ```shell
          helm install \
              --create-namespace --namespace rook-ceph \
              my-rook-ceph-operator \
              https://resource.cnconti.cc/charts/charts.rook.io/release/rook-ceph-v1.9.12.tgz \
              --values /tmp/rook.ceph.operator.values.yaml \
              --atomic
          ```
    * check pod healthy
        + ```shell
          kubectl -n rook-ceph get pod
          kubectl -n rook-ceph wait --for=condition=ready pod --all
          ```
6. create `CephCluster`
    * prepare [rook.ceph.cluster-on-pvc.yaml](resources/rook.ceph.cluster-on-pvc.yaml.md) as file `/tmp/rook.ceph.cluster-on-pvc.yaml`
        + ```shell
          kubectl -n rook-ceph apply -f /tmp/rook.ceph.cluster-on-pvc.yaml
          ```
    * check healthy
        + ```shell
          # waiting for osd(s) to be ready, 3 pod named rook-ceph-osd-$index-... are expected to be Running
          kubectl -n rook-ceph get pod -w
          ```
7. install `toolbox` check ceph status
    * prepare [rook.ceph.toolbox.yaml](resources/rook.ceph.toolbox.yaml.md) as file `/tmp/rook.ceph.toolbox.yaml`
        + ```shell
          kubectl -n rook-ceph apply -f /tmp/rook.ceph.toolbox.yaml
          ```
    * check ceph status
        +  ```shell
           # 3 osd(s) and 3 mon(s)
           # pgs(if exists any) should be active and clean
           kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- ceph status
           ```
8. create ceph filesystem and storage class
    * prepare [ceph.filesystem.yaml](resources/ceph.filesystem.yaml.md) as file `/tmp/ceph.filesystem.yaml`
    * prepare [ceph.storage.class.yaml](resources/ceph.storage.class.yaml.md) as file `/tmp/ceph.storage.class.yaml`
        + ```shell
          kubectl -n rook-ceph apply -f /tmp/ceph.filesystem.yaml
          kubectl -n rook-ceph apply -f /tmp/ceph.storage.class.yaml
          ```
    * check ceph status
        + ```shell
          # pgs(if exists any) should be active and clean
          kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- ceph status
          ```
    * check ceph filesystem status
        + ```shell
          # one file system, which is active, is expected
          # in addition, check available storage size
          # 1 pool are expected
          kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- ceph fs status
          ```
9. install `ceph-mariadb`
    * prepare [ceph.mariadb.values.yaml](resources/ceph.mariadb.values..md) as file `/tmp/ceph.mariadb.values.yaml`
    * install `ceph-mariadb` by helm
        + ```shell
          helm install \
              --create-namespace --namespace test \
              ceph-mariadb \
              https://resource.cnconti.cc/charts/charts.bitnami.com/bitnami/mariadb-9.4.2.tgz \
              --values /tmp/ceph.mariadb.values.yaml \
              --timeout 600s \
              --atomic
          ```
    * prepare [ceph.mariadb.tool.yaml](resources/ceph.mariadb.tool.yaml.md) as file `/tmp/ceph.mariadb.tool.yaml`
        + ```shell
          kubectl -n test apply -f /tmp/ceph.mariadb.tool.yaml
          ```
    * connect to `ceph-mariadb`
        + ```shell
          kubectl -n test exec -it deployment/ceph-mariadb-tool -- bash -c \
              'echo "show databases" | mysql -h ceph-mariadb.test -uroot -p$MARIADB_ROOT_PASSWORD'
          ```
    * checking pvc and pv
        + ```shell
          kubectl -n test get pvc && kubectl get sc && kubectl get pv
          ```
    * uninstall mariadb to test
        + ```shell
          helm -n test uninstall ceph-mariadb \
              && kubectl -n test delete pvc data-ceph-mariadb-0 \
              && kubectl delete namespace test
          ```
    * checking pv
        + ```shell
          kubectl get sc && kubectl get pv
          ```
