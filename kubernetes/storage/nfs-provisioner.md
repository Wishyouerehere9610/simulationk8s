# nfs-provisioner

## installation
1. prepare [nfs.provisioner.values.yaml](resources/nfs.provisioner.values.yaml.md) as file `/tmp/nfs.provisioner.values.yaml`
2. prepare images in all node
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource.cnconti.cc/docker-images"
      for IMAGE in "k8s.gcr.io_sig-storage_nfs-subdir-external-provisioner_v4.0.2.dim" \
          "docker.io_bitnami_mariadb_10.5.12-debian-10-r0.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      ```
3. install `nfs.provisioner` by helm
    * ```shell
      helm install \
          --create-namespace --namespace nfs-provisioner \
          my-nfs-subdir-external-provisioner \
          https://resource.cnconti.cc/charts/kubernetes-sigs.github.io/nfs-subdir-external-provisioner/nfs-subdir-external-provisioner-4.0.14.tgz \
          --values /tmp/nfs.provisioner.values.yaml \
          --atomic
      ```

## test
1. prepare [mariadb-test.values.yaml](resources/mariadb-test.values.yaml.md) as file `/tmp/mariadb-test.values.yaml`
2. install `mariadb-test` by helm
    * ```shell
      helm install \
          --create-namespace --namespace test \
          mariadb-test \
          https://resource.cnconti.cc/charts/charts.bitnami.com/bitnami/mariadb-9.4.2.tgz \
          --values /tmp/mariadb-test.values.yaml \
          --timeout 600s \
          --atomic
      ```
3. connect to `mariadb-test`
    * ```shell
      kubectl -n test exec -it deployment/mariadb-tool -- bash -c \
          'echo "show databases" | mysql -h mariadb-test.test -uroot -p$MARIADB_ROOT_PASSWORD'
      ```
4. checking pvc and pv
    * ```shell
      kubectl -n test get pvc
      kubectl get sc && kubectl get pv
      ```
5. uninstall `mariadb-test`
    * ```shell
      helm -n test uninstall mariadb-test \
          && kubectl -n test delete pvc data-mariadb-test-0 \
          && kubectl delete namespace test
      ```
6. checking pv
    * ```shell
      kubectl get sc && kubectl get pv
      ```
